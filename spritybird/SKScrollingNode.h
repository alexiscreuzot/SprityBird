//
//  SKScrollingNode.h
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScrollingNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

+ (id) spriteNodeWithArrayOfImagesNames:(NSArray *) imagesNames;

- (void) update:(NSTimeInterval)currentTime;

@end
