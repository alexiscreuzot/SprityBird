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
#import "PipeNode.h"
#import "Score.h"

#define FIRST_BLOCK_PADDING 100

#define FLOOR_SCROLLING_SPEED 5

#define VERTICAL_GAP_SIZE 125
#define BLOCK_WIDTH 55
#define BLOCK_MIN_HEIGHT 40
#define BLOCK_INTERVAL_SPACE 140


@implementation Scene{
    SKScrollingNode * floor;
    SKScrollingNode * city;
    SKScrollingNode * clouds;
    BirdNode * bird;
    
    int nbObstacles;
    NSMutableArray * topPipes;
    NSMutableArray * bottomPipes;
    
    int score;
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
    [self createFloor];
    [self createLandscape];
    [self createBird];
    [self createBlocks];
    
}

- (void) createBackground
{
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    back.anchorPoint = CGPointZero;
    [self addChild:back];

}

- (void) createScore
{
    score=0;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 500;
    scoreLabel.position = CGPointMake( CGRectGetMidX(self.frame), 100);
    scoreLabel.alpha = 0.2;
    [self addChild:scoreLabel];
}

- (void) createLandscape
{
    clouds = [SKScrollingNode spriteNodeWithImageNamed:@"clouds"];
    clouds.anchorPoint = CGPointZero;
    clouds.position = CGPointMake(0, floor.size.height + 30);
    clouds.scrollingSpeed = .5;
    clouds.alpha = .5;
    [self addChild:clouds];
    
    city = [SKScrollingNode spriteNodeWithImageNamed:@"city"];
    city.anchorPoint = CGPointZero;
    city.position = CGPointMake(0, floor.size.height);
    city.scrollingSpeed = .7;
    [self addChild:city];
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
    bird = [BirdNode spriteNodeWithImageNamed:@"bird"];
    [bird setPosition:CGPointMake(120, CGRectGetMidY(self.frame))];
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
        PipeNode * topPipe = [PipeNode pipeOfType:PipeNodeTypeTop];
        [topPipe setAnchorPoint:CGPointZero];
        PipeNode * bottomPipe = [PipeNode pipeOfType:PipeNodeTypeBottom];
        
        [self addChild:topPipe];
        [bottomPipes addObject:topPipe];
        
        [self addChild:bottomPipe];
        [topPipes addObject:bottomPipe];
        
        if(0 == i){
            [self place:bottomPipe and:topPipe atX:WIDTH(self)+FIRST_BLOCK_PADDING];
        }else{
            [self place:bottomPipe and:topPipe atX:lastBlockPos + BLOCK_WIDTH+BLOCK_INTERVAL_SPACE];
        }
        lastBlockPos = topPipe.position.x;
        //NSLog(@"x : %f",lastBlockPos);
    }

}


- (void) place:(SKSpriteNode *) bottomBlock and:(SKSpriteNode *) topBlock atX:(float) xPos
{
    float availableSpace = self.frame.size.height - floor.frame.size.height;
    
    float bottomBlockHeight = [Math randomFloatBetween:BLOCK_MIN_HEIGHT and:(BLOCK_MIN_HEIGHT, availableSpace-VERTICAL_GAP_SIZE-BLOCK_MIN_HEIGHT)];
    bottomBlock.size = CGSizeMake(BLOCK_WIDTH, bottomBlockHeight);
    bottomBlock.position = CGPointMake(xPos,HEIGHT(floor));
    bottomBlock.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, BLOCK_WIDTH, bottomBlockHeight)];
    
    bottomBlock.physicsBody.categoryBitMask = blockBitMask;
    bottomBlock.physicsBody.contactTestBitMask = birdBitMask;
    
    float topBlockHeight = availableSpace-bottomBlockHeight-VERTICAL_GAP_SIZE;
    float topBlockYPos = HEIGHT(floor)+bottomBlockHeight+VERTICAL_GAP_SIZE;
    topBlock.size = CGSizeMake(BLOCK_WIDTH, topBlockHeight);
    topBlock.position = CGPointMake(xPos,topBlockYPos);
    topBlock.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, BLOCK_WIDTH, topBlockHeight)];
    
    topBlock.physicsBody.categoryBitMask = blockBitMask;
    topBlock.physicsBody.contactTestBitMask = birdBitMask;
    
    
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
    [floor update:currentTime];
    [city update:currentTime];
    [clouds update:currentTime];
    
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
        
        PipeNode * topPipe = (PipeNode *) topPipes[i];
        PipeNode * bottomPipe = (PipeNode *) bottomPipes[i];
        
        if (topPipe.position.x < -topPipe.size.width){
            PipeNode * mostRightPipe = (PipeNode *) topPipes[(i+(nbObstacles-1))%nbObstacles];
            [self place:topPipe and:bottomPipe atX:mostRightPipe.position.x+BLOCK_WIDTH+BLOCK_INTERVAL_SPACE];
        }
        topPipe.position = CGPointMake(topPipe.position.x - FLOOR_SCROLLING_SPEED, topPipe.position.y);
        bottomPipe.position = CGPointMake(bottomPipe.position.x - FLOOR_SCROLLING_SPEED, bottomPipe.position.y);
        
    }
    
}

- (void) updateScore:(NSTimeInterval) currentTime
{
    for(int i=0;i<nbObstacles;i++){
        
        PipeNode * topPipe = (PipeNode *) topPipes[i];
        
        // Score
        if(topPipe.frame.origin.x + BLOCK_WIDTH > CGRectGetMidX(self.frame) &&
           topPipe.frame.origin.x + BLOCK_WIDTH < CGRectGetMidX(self.frame)+FLOOR_SCROLLING_SPEED){
            score +=1;
            scoreLabel.text = [NSString stringWithFormat:@"%d",score];
            if(score>=10){
                scoreLabel.fontSize = 340;
                scoreLabel.position = CGPointMake( CGRectGetMidX(self.frame), 120);
            }
            if(score>=100){
                scoreLabel.fontSize = 200;
                scoreLabel.position = CGPointMake( CGRectGetMidX(self.frame), 160);
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
    [Score registerScore:score];
    NSLog(@"wasted");
    
    if([self.delegate respondsToSelector:@selector(eventWasted)]){
        [self.delegate eventWasted];
    }
    
}
@end
