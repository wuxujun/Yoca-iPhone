//
//  IScrollNumView.h
//
//  Created by zangcw on 12-9-6.
//  Copyright (c) 2012年 ZCW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IScrollNumAnimationTypeNone,
    IScrollNumAnimationTypeNormal,
    IScrollNumAnimationTypeFromLast,
    IScrollNumAnimationTypeRand,
    IScrollNumAnimationTypeFast
} IScrollNumAnimationType;

@interface IScrollDigitView : UIView {
    CGFloat _oneDigitHeight;
}

@property (retain, nonatomic) UIView *backgroundView;
@property (retain, nonatomic) UILabel *label;
@property (readonly, nonatomic) NSUInteger digit;
@property (retain, nonatomic) UIFont *digitFont;

- (void)setDigitAndCommit:(NSUInteger)aDigit;
- (void)setDigitFromLast:(NSUInteger)aDigit;
- (void)setDigit:(NSUInteger)aDigit from:(NSUInteger)last;
- (void)setDigitFast:(NSUInteger)aDigit;
- (void)setRandomScrollDigit:(NSUInteger)aDigit length:(NSUInteger)length;

- (void)commitChange;

- (void)didConfigFinish;

@end

@interface IScrollNumView : UIView {
    NSMutableArray *_numberViews;
}

@property (nonatomic) NSUInteger numberSize;
@property (nonatomic) CGFloat splitSpaceWidth;
@property (nonatomic) CGFloat topAndBottomPadding;
@property (readonly, nonatomic) NSUInteger numberValue;
@property (retain, nonatomic) UIView *backgroundView;
@property (retain, nonatomic) UIView *digitBackgroundView;
@property (retain, nonatomic) UIFont *digitFont;
@property (readonly, nonatomic) NSArray *numberViews;
@property (retain, nonatomic) UIColor *digitColor;
@property (nonatomic) NSUInteger randomLength;
- (void)setNumber:(NSUInteger)number withAnimationType:(IScrollNumAnimationType)type animationTime:(NSTimeInterval)timeSpan;

- (void)didConfigFinish;
@end
