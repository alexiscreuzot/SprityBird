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

#define BACK_SCROLLING_SPEED .5
#define FLOOR_SCROLLING_SPEED 3

// Obstacles
#define VERTICAL_GAP_SIZE 120
#define FIRST_OBSTACLE_PADDING 100
#define OBSTACLE_MIN_HEIGHT 60
#define OBSTACLE_INTERVAL_SPACE 130

@implementation Scene{
    SKScrollingNode * floor;
    SKScrollingNode * back;
    SKLabelNode * scoreLabel;
    BirdNode * bird;
    
    int nbObstacles;
    NSMutableArray * topPipes;
    NSMutableArray * bottomPipes;
}

static bool wasted = NO;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
        [self startGame];
    }
    return self;
}

- (void) startGame
{
    // Reinit
    wasted = NO;
    
    [self removeAllChildren];
    
    [self createBackground];
    [self createFloor];
    [self createScore];
    [self createObstacles];
    [self createBird];
    
    // Floor needs to be in front of tubes
    floor.zPosition = bird.zPosition + 1;
    
    if([self.delegate respondsToSelector:@selector(eventStart)]){
        [self.delegate eventStart];
    }
}

#pragma mark - Creations

- (void) createBackground
{
    back = [SKScrollingNode scrollingNodeWithImageNamed:@"back" inContainerWidth:WIDTH(self)];
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    back.physicsBody.categoryBitMask = backBitMask;
    back.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:back];
}

- (void) createScore
{
    self.score = 0;
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 500;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 100);
    scoreLabel.alpha = 0.2;
    [self addChild:scoreLabel];
}


- (void)createFloor
{
    floor = [SKScrollingNode scrollingNodeWithImageNamed:@"floor" inContainerWidth:WIDTH(self)];
    [floor setScrollingSpeed:FLOOR_SCROLLING_SPEED];
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.categoryBitMask = floorBitMask;
    floor.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:floor];
}

- (void)createBird
{
    bird = [BirdNode new];
    [bird setPosition:CGPointMake(100, CGRectGetMidY(self.frame))];
    [bird setName:@"bird"];
    [self addChild:bird];
}

- (void) createObstacles
{
    // Calculate how many obstacles we need, the less the better
    nbObstacles = ceil(WIDTH(self)/(OBSTACLE_INTERVAL_SPACE));
    
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
        
        // Give some time to the player before first obstacle
        if(0 == i){
            [self place:bottomPipe and:topPipe atX:WIDTH(self)+FIRST_OBSTACLE_PADDING];
        }else{
            [self place:bottomPipe and:topPipe atX:lastBlockPos + WIDTH(bottomPipe) +OBSTACLE_INTERVAL_SPACE];
        }
        lastBlockPos = topPipe.position.x;
    }
    
}

#pragma mark - Interaction 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(wasted){
        [self startGame];
    }else{
        if (!bird.physicsBody) {
            [bird startPlaying];
            if([self.delegate respondsToSelector:@selector(eventPlay)]){
                [self.delegate eventPlay];
            }
        }
        [bird bounce];
    }
}

#pragma mark - Update & Core logic


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
    [self updateObstacles:currentTime];
    [self updateScore:currentTime];
}


- (void) updateObstacles:(NSTimeInterval)currentTime
{
    if(!bird.physicsBody){
        return;
    }
    
    for(int i=0;i<nbObstacles;i++){
        
        // Get pipes bby pairs
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        SKSpriteNode * bottomPipe = (SKSpriteNode *) bottomPipes[i];
        
        // Check if pair has exited screen, and place them upfront again
        if (X(topPipe) < -WIDTH(topPipe)){
            SKSpriteNode * mostRightPipe = (SKSpriteNode *) topPipes[(i+(nbObstacles-1))%nbObstacles];
            [self place:bottomPipe and:topPipe atX:X(mostRightPipe)+WIDTH(topPipe)+OBSTACLE_INTERVAL_SPACE];
        }
        
        // Move according to the scrolling speed
        topPipe.position = CGPointMake(X(topPipe) - FLOOR_SCROLLING_SPEED, Y(topPipe));
        bottomPipe.position = CGPointMake(X(bottomPipe) - FLOOR_SCROLLING_SPEED, Y(bottomPipe));
    }
}

- (void) place:(SKSpriteNode *) bottomPipe and:(SKSpriteNode *) topPipe atX:(float) xPos
{
    // Maths
    float availableSpace = HEIGHT(self) - HEIGHT(floor);
    float maxVariance = availableSpace - (2*OBSTACLE_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
    float variance = [Math randomFloatBetween:0 and:maxVariance];
    
    // Bottom pipe placement
    float minBottomPosY = HEIGHT(floor) + OBSTACLE_MIN_HEIGHT - HEIGHT(self);
    float bottomPosY = minBottomPosY + variance;
    bottomPipe.position = CGPointMake(xPos,bottomPosY);
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(bottomPipe) , HEIGHT(bottomPipe))];
    bottomPipe.physicsBody.categoryBitMask = blockBitMask;
    bottomPipe.physicsBody.contactTestBitMask = birdBitMask;
    
    // Top pipe placement
    topPipe.position = CGPointMake(xPos,bottomPosY + HEIGHT(bottomPipe) + VERTICAL_GAP_SIZE);
    topPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(topPipe), HEIGHT(topPipe))];
    
    topPipe.physicsBody.categoryBitMask = blockBitMask;
    topPipe.physicsBody.contactTestBitMask = birdBitMask;
}


- (void) updateScore:(NSTimeInterval) currentTime
{
    for(int i=0;i<nbObstacles;i++){
        
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        
        // Score, adapt font size
        if(X(topPipe) + WIDTH(topPipe)/2 > bird.position.x &&
           X(topPipe) + WIDTH(topPipe)/2 < bird.position.x + FLOOR_SCROLLING_SPEED){
            self.score +=1;
            scoreLabel.text = [NSString stringWithFormat:@"%lu",self.score];
            if(self.score>=10){
                scoreLabel.fontSize = 340;
                scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 120);
            }
        }
    }
}

#pragma mark - Physic

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if(wasted){ return; }

    wasted = true;
    [Score registerScore:self.score];
    
    if([self.delegate respondsToSelector:@selector(eventWasted)]){
        [self.delegate eventWasted];
    }
}
@end
