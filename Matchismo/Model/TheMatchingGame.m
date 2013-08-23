//
//  TheMatchingGame.m
//  ;
//
//  Created by tcz on 8/18/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "TheMatchingGame.h"
#import "PlayingCard.h"

@interface TheGame()
@property (strong,nonatomic) NSMutableArray *cards;//of Card
@property (readwrite, nonatomic) NSInteger score;
@end

@implementation TheMatchingGame
-(void)flipCardAtIndex:(NSUInteger)index{
    
    Card *card;
    
    card = self.cards[index];
    if(!card.isUnplayable){
        card.faceUp = !card.isFaceUp;
        if(card.faceUp){
            self.score -= 2;
        }
    }
    //check two or three faceUp cards
    
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    
    
    for(card in self.cards){
        if(card.isFaceUp && !card.unplayable){
            [cards addObject:card];
        }
    }
    
    NSString *message=@"";
    NSString *content = [[cards valueForKey:@"contents"] componentsJoinedByString:@" & "];
    
    if([cards count] == self.mode){
        NSInteger result = [PlayingCard match:cards];
        if(result>0){
            result = result * self.mode;
            message = [NSString stringWithFormat:@"Matched %@ for %d points",content, result];
            for(card in cards){
                card.unplayable = YES;
            }
            
        }
        else{
            message = [NSString stringWithFormat:@"%@ don't match! %d points penalty!",content, result];
            for(card in cards){
                card.faceUp = NO;
            }
        }
        self.score += result;
    }
    else{
        message = [NSString stringWithFormat:@"Flipped %@",content];
    }
    
    self.message = message;
    
}
@end
