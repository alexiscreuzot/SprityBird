//
//  BirdNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "BirdNode.h"

@implementation BirdNode

CGFloat lastVelocity = 0;

- (void) update:(NSUInteger) currentTime
{
    if(self.physicsBody.velocity.dy != lastVelocity){
        self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0005;
        lastVelocity = self.physicsBody.velocity.dy;
    }
}

- (void) startPlaying
{
    [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(34, 20)]];
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
