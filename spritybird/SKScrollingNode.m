//
//  SKScrollingNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "SKScrollingNode.h"

@implementation SKScrollingNode

+ (id) spriteNodeWithImageNamed:(NSString *)name
{
    UIImage * image = [UIImage imageNamed:name];
    
    SKScrollingNode * realNode = [SKScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(320, image.size.height)];
    realNode.scrollingSpeed = 1;
    
   
    float total = 0;
    while(total<(320+image.size.width)){
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name ];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}

+ (id) spriteNodeWithArrayOfImagesNames:(NSArray *) imagesNames
{
    return nil;
}

- (void) update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock:^(SKSpriteNode * child, NSUInteger idx, BOOL *stop) {
        child.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
        if (child.position.x <= -child.size.width){
            float delta = child.position.x+child.size.width;
            child.position = CGPointMake(child.size.width*(self.children.count-1)+delta, child.position.y);
        }
    }];
  
}

@end
