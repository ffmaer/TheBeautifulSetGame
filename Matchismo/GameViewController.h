//
//  ViewController.h
//  Matchismo
//
//  Created by tcz on 8/10/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface GameViewController : UIViewController
-(NSInteger)startingCardCount; //abstract
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card;//abstract
-(Deck *)createDeck;//abstract
@end
