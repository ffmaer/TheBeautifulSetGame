//
//  CardView.m
//  DrawCard
//
//  Created by tcz on 8/26/13.
//  Copyright (c) 2013 Maer Studios Inc. All rights reserved.
//

#import "PlayingCardView.h"

#define CORNER_RADIUS 12.0
#define WIDTH_RATIO 0.2
#define DISTANCE_FROM_BORDER 2
#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.9
@implementation PlayingCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

-(CGFloat)faceCardScaleFactor{
    if(!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

-(void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)drawRect:(CGRect)rect
{
    //draw card
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    [roundRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundRect stroke];
    
    if(self.faceUp){
        
        //draw center image
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg",[self rankToString],self.suit]];
        
        if(faceImage){
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0-self.faceCardScaleFactor), self.bounds.size.height * (1.0-self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        }
        else{
            [self drawPips];
        }
        
        //draw corner texts
        [self drawCorners];
    }
    else{
        //fill background with patterns
        UIImage *bg = [UIImage imageNamed:@"dimension.png"];
        [[UIColor colorWithPatternImage:bg ]setFill];
        UIRectFill([self bounds]);
    }
}

+ (NSArray *) rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

-(NSString *)rankToString{
    NSArray *rankStrings = [PlayingCardView rankStrings];
    return rankStrings[self.rank];
}
-(void)drawCorners{
    //paragraph center
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.alignment = NSTextAlignmentCenter;
    //font system font and size 1/5 of the width
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * WIDTH_RATIO];
    //attributed text
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankToString], self.suit] attributes:@{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:font}];
    //draw the text in appropriate text box
    CGRect textBounds;
    textBounds.origin = CGPointMake(DISTANCE_FROM_BORDER, DISTANCE_FROM_BORDER);
    textBounds.size = [text size];
    [text drawInRect:textBounds];
    [self saveGStateTranslateAndRotate];
    [text drawInRect:textBounds];
    [self restoreGState];
}

-(void)saveGStateTranslateAndRotate{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM( context ,self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}
-(void)restoreGState{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(void) setRank:(NSUInteger)rank{
    _rank = rank;
    [self setNeedsDisplay];
}
-(void) setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

#pragma mark - Draw Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270
#define PIP_FONT_SCALE_FACTOR 0.20


- (void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self saveGStateTranslateAndRotate];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self restoreGState];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

@end
