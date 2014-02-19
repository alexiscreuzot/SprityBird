//
//  Score.h
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#define kBestScoreKey @"BestScore"

@interface Score : NSObject

+ (void) registerScore:(NSInteger) score;
+ (void) setBestScore:(NSInteger) bestScore;
+ (NSInteger) bestScore;

@end
