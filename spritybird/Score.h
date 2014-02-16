//
//  Score.h
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBestScoreKey @"BestScore"

@interface Score : NSObject

+ (void) registerScore:(NSUInteger) score;
+ (void) setBestScore:(NSUInteger) bestScore;
+ (NSUInteger) bestScore;

@end
