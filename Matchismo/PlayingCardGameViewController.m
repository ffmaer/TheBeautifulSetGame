//
//  PlayingCardGameViewController.m
//  TheBeautifulSetGame
//
//  Created by tcz on 8/27/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCell.h"


@implementation PlayingCardGameViewController


-(NSInteger)startingCardCount{
    return 20;
}
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card{
    if([cell isKindOfClass:[PlayingCardCell class]]){
        PlayingCardView *playingCardView = ((PlayingCardCell *)cell).playingCardView;
        if([card isKindOfClass:[PlayingCard class]]){
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable?0.3:1.0;
        }
    }
    
}
-(Deck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}

@end
