//
//  ViewController.m
//  Matchismo
//
//  Created by tcz on 8/10/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "GameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "TheMatchingGame.h"
#import "GameResult.h"

@interface GameViewController ()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mode;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@property (strong, nonatomic)NSMutableArray *history;
@property (nonatomic) int flipsCount;
@property (strong,nonatomic) TheMatchingGame *game;
@property (strong,nonatomic) Deck* deck;
@property (strong,nonatomic) GameResult *gameResult;

@end



@implementation GameViewController

#pragma mark - abstract
-(NSInteger)startingCardCount{
    return 0;
}
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card{
    //abstract
}
-(Deck *)createDeck{
    return [[Deck alloc]init];    
}

#pragma mark - Implement UICollectionViewDataSource protocal

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self startingCardCount];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}


#pragma mark - lazy instantiation
-(GameResult *)gameResult{
    if(!_gameResult) _gameResult = [[GameResult alloc]init];
    return _gameResult;
}

-(Deck *)deck{
    if(!_deck) _deck = [self createDeck];
    return _deck;
}
-(TheMatchingGame *)game{
    if(!_game) _game = [[TheMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                        usingDeck:(Deck *)self.deck];
    return _game;
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


#pragma mark - the rest
-(void)updateUI{
    //update cards
    for(UICollectionViewCell *cell in [self.cardCollectionView visibleCells]){
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    //update statistics
    self.matchLabel.alpha=1;
    self.historySlider.enabled = YES;
    self.mode.enabled = NO;
    self.game.mode = self.mode.selectedSegmentIndex+2;
    
    // update history
    NSString *message = self.game.message;
    if(message){
        self.matchLabel.text = message;
        [self.history addObject:message];
        self.historySlider.minimumValue=0;
        self.historySlider.maximumValue=self.history.count-1;
    }
    //update score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    [self.gameResult setScore: self.game.score];
    
}

-(void)viewDidLoad{
    [self reset];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if(indexPath){
        [self.game flipCardAtIndex:indexPath.item];
        self.flipsCount++;
        [self updateUI];
    }
}


- (IBAction)reset {
    self.matchLabel.text = @"";
    self.flipsCount = 0;
    self.deck = nil;
    self.game = nil;
    self.scoreLabel.text = @"Score: 0";
    [self updateUI];
    self.mode.enabled = YES;
    self.history = nil;
    self.historySlider.minimumValue=0;
    self.historySlider.maximumValue=0;
    self.historySlider.enabled = NO;
}
- (IBAction)slide:(UISlider *)sender {
    NSString *message = self.history[(int)sender.value];
    self.matchLabel.text = message;
    self.matchLabel.alpha = 0.5;
}


@end
