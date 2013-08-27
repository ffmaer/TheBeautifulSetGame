//
//  ScoreViewController.m
//  TheSetGame
//
//  Created by tcz on 8/23/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "ScoreViewController.h"
#import "GameResult.h"

@interface ScoreViewController ()
@property (strong,nonatomic) NSArray *results;
@property (weak, nonatomic) IBOutlet UITextView *display;
@end

@implementation ScoreViewController


-(NSArray *) results{
    if(!_results) _results = [GameResult getResultsArray];
    return _results;
}

-(void)updateDisplay{
    
    NSString *display = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    for(GameResult *result in self.results){
        display = [display stringByAppendingFormat:@"Score: %d (Date:%@, Duration: %1.1f)\n",result.score, [dateFormatter stringFromDate:result.end],result.duration];
    }
    
    self.display.text = display;

}
-(void) viewDidLoad{
    [self updateDisplay];

   }

- (IBAction)sortByScore {
    self.results = [self.results sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateDisplay];

}
- (IBAction)sortByDate {
    self.results = [self.results sortedArrayUsingSelector:@selector(compareDate:)];
    [self updateDisplay];
}

- (IBAction)sortByDuration {
    self.results = [self.results sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateDisplay];
}



@end
