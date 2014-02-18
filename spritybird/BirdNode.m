//
//  BirdNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "BirdNode.h"

#define VERTICAL_SPEED 1
#define VERTICAL_DELTA 5

@implementation BirdNode

static CGFloat lastVelocity = 0;
static NSInteger deltaPosY = 0;
static bool goingUp = false;

- (id)init
{
    if(self = [super init]){
        SKTexture* birdTexture1 = [SKTexture textureWithImageNamed:@"bird_1"];
        birdTexture1.filteringMode = SKTextureFilteringNearest;
        SKTexture* birdTexture2 = [SKTexture textureWithImageNamed:@"bird_2"];
        birdTexture2.filteringMode = SKTextureFilteringNearest;
        SKTexture* birdTexture3 = [SKTexture textureWithImageNamed:@"bird_3"];
        birdTexture2.filteringMode = SKTextureFilteringNearest;
        
        SKAction* flap = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTexture1, birdTexture2,birdTexture3] timePerFrame:0.2]];
        
        self = [BirdNode spriteNodeWithTexture:birdTexture1];
        [self setTexture:birdTexture1];
        [self runAction:flap];
    }
    return self;
}



- (void) update:(NSUInteger) currentTime
{
    if(!self.physicsBody){
        if(deltaPosY>VERTICAL_DELTA){
            goingUp = false;
        }
        if(deltaPosY<-VERTICAL_DELTA){
            goingUp = true;
        }
        NSInteger displacement = (goingUp)? VERTICAL_SPEED : -VERTICAL_SPEED;
        self.position = CGPointMake(self.position.x, self.position.y + displacement);
        deltaPosY += displacement;
    }
    
    if(self.physicsBody.velocity.dy != lastVelocity){
        self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0005;
        lastVelocity = self.physicsBody.velocity.dy;
    }
}

- (void) startPlaying
{
    deltaPosY = 0;
    [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(32, 20)]];
    self.physicsBody.categoryBitMask = birdBitMask;
    self.physicsBody.restitution = 0.01;
    self.physicsBody.mass = 0.1;
}

- (void) bounce
{
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
}

@end
