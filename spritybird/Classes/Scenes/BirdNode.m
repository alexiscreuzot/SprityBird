//
//  BirdNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "BirdNode.h"

#define VERTICAL_SPEED 1
#define VERTICAL_DELTA 5.0

@interface BirdNode ()
@property (strong,nonatomic) SKAction * flap;
@property (strong,nonatomic) SKAction * flapForever;
@end

@implementation BirdNode

static CGFloat deltaPosY = 0;
static bool goingUp = false;

- (id)init
{
    if(self = [super init]){
        
        // TODO : use texture atlas
        SKTexture* birdTexture1 = [SKTexture textureWithImageNamed:@"bird_1"];
        birdTexture1.filteringMode = SKTextureFilteringNearest;
        SKTexture* birdTexture2 = [SKTexture textureWithImageNamed:@"bird_2"];
        birdTexture2.filteringMode = SKTextureFilteringNearest;
        SKTexture* birdTexture3 = [SKTexture textureWithImageNamed:@"bird_3"];
        birdTexture2.filteringMode = SKTextureFilteringNearest;

        self = [BirdNode spriteNodeWithTexture:birdTexture1];
        
        self.flap = [SKAction animateWithTextures:@[birdTexture1, birdTexture2,birdTexture3] timePerFrame:0.2];
        self.flapForever = [SKAction repeatActionForever:self.flap];
        
        [self setTexture:birdTexture1];
        [self runAction:self.flapForever withKey:@"flapForever"];
    }
    return self;
}

- (void) update:(NSUInteger) currentTime
{
    if(!self.physicsBody){
        if(deltaPosY > VERTICAL_DELTA){
            goingUp = false;
        }
        if(deltaPosY < -VERTICAL_DELTA){
            goingUp = true;
        }
        
        float displacement = (goingUp)? VERTICAL_SPEED : -VERTICAL_SPEED;
        self.position = CGPointMake(self.position.x, self.position.y + displacement);
        deltaPosY += displacement;
    }
    
    // Rotate body based on Y velocity (front toward direction)
    self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0005;
    
}

- (void) startPlaying
{
    deltaPosY = 0;
    [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(26, 18)]];
    self.physicsBody.categoryBitMask = birdBitMask;
    self.physicsBody.mass = 0.1;
    [self removeActionForKey:@"flapForever"];
}

- (void) bounce
{
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
    [self runAction:self.flap];
}

@end
