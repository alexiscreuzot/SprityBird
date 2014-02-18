//
//  BouncingScene.h
//  Bouncing
//
//  Created by Seung Kyun Nam on 13. 7. 24..
//  Copyright (c) 2013년 Seung Kyun Nam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



@protocol BoucingSceneDelegate <NSObject>

- (void) eventStart;
- (void) eventPlay;
- (void) eventWasted;

@end

@interface Scene : SKScene<SKPhysicsContactDelegate>

@property (unsafe_unretained,nonatomic) id<BoucingSceneDelegate> delegate;
@property (nonatomic) NSUInteger score;

- (void) startGame;

@end
