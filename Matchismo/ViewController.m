//
//  ViewController.m
//  Matchismo
//
//  Created by tcz on 8/10/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "TheMatchingGame.h"
#import "GameResult.h"

@interface ViewController ()
@property (nonatomic) int flipsCount;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mode;
@property (strong, nonatomic)NSMutableArray *history;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;//a collection of buttons
@property (strong,nonatomic) TheMatchingGame *game;
@property (strong,nonatomic) Deck* deck;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong,nonatomic) GameResult *gameResult;
@end

@implementation ViewController

-(GameResult *)gameResult{
    if(!_gameResult) _gameResult = [[GameResult alloc]init];
    return _gameResult;
}

-(Deck *)deck{
    if(!_deck) _deck = [[PlayingCardDeck alloc ]init];
    return _deck;
}

-(TheMatchingGame *)game{
    if(!_game) _game = [[TheMatchingGame alloc] initWithCardCount:self.buttons.count
                                                        usingDeck:(Deck *)self.deck];
    return _game;
}

-(void)updateCards{
    for(int i=0;i<[self.buttons count];i++){
        Card *card = [self.game cardAtIndex:i];
        UIButton *button = self.buttons[i];
        button.enabled = YES;
        button.selected = NO;
        if(card.unplayable){
            button.enabled = NO;
            [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
            [button setTitle:card.contents forState:UIControlStateDisabled];
            button.alpha = 0.7;
        }else{
            button.selected = card.faceUp;
            [button setTitle:card.contents forState:UIControlStateSelected];
        }
    }
}

-(void)updateUI{
    
    self.matchLabel.alpha=1;
    self.historySlider.enabled = YES;
    self.mode.enabled = NO;
    self.flipsCount++;
    self.game.mode = self.mode.selectedSegmentIndex+2;
    
    NSString *message = self.game.message;
    self.matchLabel.text = message;
    
    // update history
    [self.history addObject:message];
    self.historySlider.minimumValue=0;
    self.historySlider.maximumValue=self.history.count-1;
    
    [self updateCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    [self.gameResult setScore: self.game.score];
    
}

-(NSMutableArray *)history{
    if(!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

-(void) setFlipsCount:(int)flipsCount
{
    _flipsCount = flipsCount;   
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipsCount];
}

- (IBAction)flipCard:(UIButton *)sender {

    //the line below is important
    [self.game flipCardAtIndex:[self.buttons indexOfObject:sender]];
    [self updateUI];

}

- (void)resetHistory{
    self.history = nil;
    self.historySlider.minimumValue=0;
    self.historySlider.maximumValue=0;
    self.historySlider.enabled = NO;

}

- (IBAction)reset:(id)sender {
    
    [self resetHistory];
    
    self.matchLabel.text = @"";
    self.mode.enabled = YES;
    
    self.flipsCount = 0;
    
    self.deck = [[PlayingCardDeck alloc ]init];
    self.game = [[TheMatchingGame alloc] initWithCardCount:self.buttons.count
                                             usingDeck:(Deck *)self.deck];
    
    [self updateCards];
    self.scoreLabel.text = @"Score: 0";
    
}
- (IBAction)slide:(UISlider *)sender {
    
    NSString *message = self.history[(int)sender.value];
    self.matchLabel.text = message;
    self.matchLabel.alpha = 0.5;
}


@end
