//
//  PipeNode.h
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM (NSUInteger,PipeNodeType){
    PipeNodeTypeTop,
    PipeNodeTypeBottom
};

@interface PipeNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

@property (nonatomic) PipeNodeType type;

+ (PipeNode*) pipeOfType:(PipeNodeType) type;

@end
