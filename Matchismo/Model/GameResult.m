//
//  GameScore.m
//  TheSetGame
//
//  Created by tcz on 8/23/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "GameResult.h"

#define ALL_RESULTS_KEY @"GameResults_all"
#define SCORE_KEY @"score"
#define START_KEY @"start"
#define END_KEY @"end"

@interface GameResult()
    @property (readwrite, nonatomic) NSDate *start;
    @property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult
-(NSTimeInterval)duration{
    return  [self.end timeIntervalSinceDate:self.start];
}

-(id)init{
    self = [super init];
    if(self){
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}



+(NSMutableDictionary *)getResultsDictionary{
     return [[[NSUserDefaults standardUserDefaults]dictionaryForKey:ALL_RESULTS_KEY ]mutableCopy];
}

+(NSArray *)getResultsArray{
    NSMutableDictionary *results = [GameResult getResultsDictionary];
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    for(NSDictionary *result in [results allValues]){
        [resultsArray addObject:[[GameResult alloc] initWithResult:result]];
    }
    return [resultsArray copy];
}

-(id)initWithResult:(NSDictionary *)result{
    self = [self init];
    if(self) {
        _start = result[START_KEY];
        _end = result[END_KEY];
        _score = [(NSNumber *)result[SCORE_KEY] intValue];
    }
    return self;
}

-(void)synchronize{
    NSMutableDictionary *results = [GameResult getResultsDictionary];
    if(!results) results = [[NSMutableDictionary alloc]init];
    results[[self.start description]]= [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:results forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary *)asPropertyList{
    return @{SCORE_KEY:@(self.score),END_KEY:self.end,START_KEY:self.start};
}
-(void)setScore:(int)score{
    _score = score;
    self.end = [NSDate date];//date means now
    [self synchronize];
}

- (NSComparisonResult)compareScore:(GameResult *)secondObject
{
    if(self.score < secondObject.score){
        return NSOrderedAscending;
    }else if(self.score == secondObject.score){
        return NSOrderedSame;
    }else{
        return NSOrderedDescending;
    }
}
- (NSComparisonResult)compareDate:(GameResult *)secondObject
{
    return [self.end compare:secondObject.end];
}
- (NSComparisonResult)compareDuration:(GameResult *)secondObject
{
    if(self.duration < secondObject.duration){
        return NSOrderedAscending;
    }else if(self.duration == secondObject.duration){
        return NSOrderedSame;
    }else{
        return NSOrderedDescending;
    }
}
@end
