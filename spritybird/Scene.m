//
//  BouncingScene.m
//  Bouncing
//
//  Created by Seung Kyun Nam on 13. 7. 24..
//  Copyright (c) 2013년 Seung Kyun Nam. All rights reserved.
//



#import "Scene.h"

#import "SKScrollingNode.h"

#import "BirdNode.h"
#import "Score.h"

#define FIRST_BLOCK_PADDING 100

#define FLOOR_SCROLLING_SPEED 3
#define BACK_SCROLLING_SPEED 1

#define FLOOR_HEIGHT 108
#define VERTICAL_GAP_SIZE 130

#define BLOCK_MIN_HEIGHT 52
#define BLOCK_WIDTH 52
#define BLOCK_INTERVAL_SPACE 120

#define BLOCK_VARIANCE 180

#define TOP_PIPE_HEIGHT 568
#define BOTTOM_PIPE_HEIGHT 568

@implementation Scene{
    SKScrollingNode * floor;
    SKScrollingNode * back;
    BirdNode * bird;
    
    int nbObstacles;
    NSMutableArray * topPipes;
    NSMutableArray * bottomPipes;
    
    SKLabelNode * scoreLabel;
    
    bool wasted;
}

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.physicsWorld.contactDelegate = self;
        
        [self startGame];
        
    }
    return self;
}

- (void) startGame
{
    if([self.delegate respondsToSelector:@selector(eventStart)]){
        [self.delegate eventStart];
    }
    
    wasted = NO;
    
    [self removeAllChildren];
    
    [self createBackground];
    [self createScore];
    [self createBlocks];
    [self createFloor];
    [self createBird];
}

- (void) createBackground
{
    back = [SKScrollingNode spriteNodeWithImageNamed:@"back"];
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [back setPosition:CGPointMake(0, 0)];
    
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    back.physicsBody.dynamic = NO;
    back.physicsBody.categoryBitMask = floorBitMask;
    back.physicsBody.contactTestBitMask = birdBitMask;
    
    [self addChild:back];

}

- (void) createScore
{
    self.score=0;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 500;
    scoreLabel.position = CGPointMake( CGRectGetMidX(self.frame), 100);
    scoreLabel.alpha = 0.2;
    [self addChild:scoreLabel];
}


- (void)createFloor {
    // Physic
    
    floor = [SKScrollingNode spriteNodeWithImageNamed:@"floor"];
    [floor setScrollingSpeed:FLOOR_SCROLLING_SPEED];
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = floorBitMask;
    floor.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:floor];
}

- (void)createBird{
    
    
    bird = [BirdNode new];
    [bird setPosition:CGPointMake(100, CGRectGetMidY(self.frame))];
    [bird setName:@"bird"];
    [self addChild:bird];
}

- (void) createBlocks
{

    nbObstacles = 3;
    
    CGFloat lastBlockPos = 0;
    bottomPipes = @[].mutableCopy;
    topPipes = @[].mutableCopy;
    for(int i=0;i<nbObstacles;i++){
        
        SKSpriteNode * topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_top"];
        [topPipe setAnchorPoint:CGPointZero];
        [self addChild:topPipe];
        [topPipes addObject:topPipe];
        
        SKSpriteNode * bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_bottom"];
        [bottomPipe setAnchorPoint:CGPointZero];
        [self addChild:bottomPipe];
        [bottomPipes addObject:bottomPipe];
        
        
        if(0 == i){
            [self place:bottomPipe and:topPipe atX:WIDTH(self)+FIRST_BLOCK_PADDING];
        }else{
            [self place:bottomPipe and:topPipe atX:lastBlockPos + BLOCK_WIDTH+BLOCK_INTERVAL_SPACE];
        }
        lastBlockPos = topPipe.position.x;
        //NSLog(@"x : %f",lastBlockPos);
    }

}


- (void) place:(SKSpriteNode *) bottomPipe and:(SKSpriteNode *) topPipe atX:(float) xPos
{
    
    float availableSpace = HEIGHT(self) - FLOOR_HEIGHT;
    float maxVariance = availableSpace - (2*BLOCK_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
    float variance = [Math randomFloatBetween:0 and:maxVariance];
    
    float minBottomPosY = FLOOR_HEIGHT + BLOCK_MIN_HEIGHT - HEIGHT(self);
    float bottomPosY = minBottomPosY + variance;
    bottomPipe.position = CGPointMake(xPos,bottomPosY);
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, BLOCK_WIDTH, HEIGHT(bottomPipe))];
    bottomPipe.physicsBody.categoryBitMask = blockBitMask;
    bottomPipe.physicsBody.contactTestBitMask = birdBitMask;

    topPipe.position = CGPointMake(xPos,bottomPosY + HEIGHT(bottomPipe) + VERTICAL_GAP_SIZE);
    topPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, BLOCK_WIDTH, HEIGHT(topPipe))];

    topPipe.physicsBody.categoryBitMask = blockBitMask;
    topPipe.physicsBody.contactTestBitMask = birdBitMask;
    
}


#pragma mark - Interaction 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(wasted){
        [self startGame];
        return;
    }
    
    if (!bird.physicsBody) {
        
        [self.view endEditing:YES];
        
        if([self.delegate respondsToSelector:@selector(eventPlay)]){
            [self.delegate eventPlay];
        }
        
        [bird startPlaying];
    }
    
    [bird bounce];
}

#pragma mark - Update


- (void)update:(NSTimeInterval)currentTime
{
    if(wasted){
        return;
    }
    
    // ScrollingNodes
    [back update:currentTime];
    [floor update:currentTime];
    
    // Other
    [bird update:currentTime];
    [self updateBlocks:currentTime];
    [self updateScore:currentTime];
}


- (void) updateBlocks:(NSTimeInterval)currentTime
{
    if(!bird.physicsBody){
        return;
    }
    
    
    for(int i=0;i<nbObstacles;i++){
        
        // Get pipes bby pairs
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        SKSpriteNode * bottomPipe = (SKSpriteNode *) bottomPipes[i];
        
        // Check if pair has exited screen, and place them upfront again
        if (topPipe.position.x < -topPipe.size.width){
            SKSpriteNode * mostRightPipe = (SKSpriteNode *) topPipes[(i+(nbObstacles-1))%nbObstacles];
            [self place:bottomPipe and:topPipe atX:mostRightPipe.position.x+BLOCK_WIDTH+BLOCK_INTERVAL_SPACE];
        }
        
        // Move according to the scrolling speed
        topPipe.position = CGPointMake(topPipe.position.x - FLOOR_SCROLLING_SPEED, topPipe.position.y);
        bottomPipe.position = CGPointMake(bottomPipe.position.x - FLOOR_SCROLLING_SPEED, bottomPipe.position.y);
        
    }
    
}

- (void) updateScore:(NSTimeInterval) currentTime
{
    for(int i=0;i<nbObstacles;i++){
        
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        
        // Score, adapt font size
        if(topPipe.frame.origin.x + BLOCK_WIDTH > CGRectGetMidX(self.frame) &&
           topPipe.frame.origin.x + BLOCK_WIDTH < CGRectGetMidX(self.frame)+FLOOR_SCROLLING_SPEED){
            self.score +=1;
            scoreLabel.text = [NSString stringWithFormat:@"%lu",self.score];
            if(self.score>=10){
                scoreLabel.fontSize = 340;
                scoreLabel.position = CGPointMake( CGRectGetMidX(self.frame), 120);
            }
        }
    }
}

#pragma mark - Physic

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if(wasted){
        return;
    }

    wasted = true;
    [Score registerScore:self.score];
    NSLog(@"wasted");
    
    if([self.delegate respondsToSelector:@selector(eventWasted)]){
        [self.delegate eventWasted];
    }
    
}
@end
