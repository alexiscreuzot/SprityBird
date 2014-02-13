//
//  PipeNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "PipeNode.h"


@interface PipeNode ()
@property (strong,nonatomic) SKSpriteNode * cap;
@property (strong,nonatomic) SKSpriteNode * tube;
@end

@implementation PipeNode


+ (PipeNode*) pipeOfType:(PipeNodeType) type{
    
    PipeNode * node = [PipeNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(55, 1)];
    node.name = @"Pipe";
    [node setAnchorPoint:CGPointZero];
    node.type = type;
    
    node.tube = [SKSpriteNode spriteNodeWithImageNamed:@"pipeTube"];
    node.tube.name = @"Tube";
    [node.tube setAnchorPoint:CGPointZero];
    [node addChild:node.tube];
    
    if(PipeNodeTypeTop == type){
        node.cap = [SKSpriteNode spriteNodeWithImageNamed:@"pipeTubeCapTop"];
    }else{
        node.cap = [SKSpriteNode spriteNodeWithImageNamed:@"pipeTubeCapBottom"];
    }
    node.cap.name = @"cap";
    [node.cap setAnchorPoint:CGPointZero];
    
    [node addChild:node.cap];
    
    return node;
}

+ (void) placePipesAtX:(CGFloat) posX
{
    
}

- (void)setSize:(CGSize)size
{
    [super setSize:size];
    self.cap.size = CGSizeMake(55, 30);
    self.tube.size = size;
    
    switch (self.type) {
        case PipeNodeTypeBottom:
            self.cap.position = CGPointMake(0, self.size.height - self.cap.size.height);
            break;
            
        case PipeNodeTypeTop:
            self.cap.position = CGPointZero;
            break;
    }
}



@end
