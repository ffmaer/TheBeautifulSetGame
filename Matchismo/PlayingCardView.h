//
//  CardView.h
//  DrawCard
//
//  Created by tcz on 8/26/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) BOOL faceUp;
@end
