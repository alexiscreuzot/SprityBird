//
//  Math.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "Math.h"

static unsigned int _seed = 0;

@implementation Math

+ (void)setRandomSeed:(unsigned int)seed
{
    _seed = seed;
    srand(_seed);
}

+ (float) randomFloatBetween:(float) min and:(float) max{
    
    float random =  ((rand()%RAND_MAX)/(RAND_MAX*1.0))*(max-min)+min;
    return random;
}

@end
