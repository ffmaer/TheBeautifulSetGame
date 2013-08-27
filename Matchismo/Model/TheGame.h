//
//  TheGame.h
//  TheSetGame
//
//  Created by tcz on 8/20/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface TheGame : NSObject
-(id)initWithCardCount: (NSUInteger) count usingDeck:(Deck *)deck;
-(Card* )cardAtIndex: (NSUInteger) index;
@property (readonly, nonatomic) NSInteger score;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSAttributedString *attributedMessage;
@property (strong, nonatomic) NSArray *gameScores;
@end
