//
//  GameScore.h
//  TheSetGame
//
//  Created by tcz on 8/23/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (nonatomic) int score;
-(NSTimeInterval)duration;
+(NSArray *)getResultsArray;
@end
