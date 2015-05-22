//
//  IValuePopupView.h
//  IWeigh
//
//  Created by xujunwu on 15/5/11.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IValuePopUpViewDelegate <NSObject>
- (CGFloat)currentValueOffset; //expects value in the range 0.0 - 1.0
- (void)colorDidUpdate:(UIColor *)opaqueColor;
@end

@interface IValuePopUpView : UIView

@property (weak, nonatomic) id <IValuePopUpViewDelegate> delegate;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat arrowLength;
@property (nonatomic) CGFloat widthPaddingFactor;
@property (nonatomic) CGFloat heightPaddingFactor;

- (UIColor *)color;
- (void)setColor:(UIColor *)color;
- (UIColor *)opaqueColor;

- (void)setTextColor:(UIColor *)textColor;
- (void)setFont:(UIFont *)font;
- (void)setText:(NSString *)text;

- (void)setAnimatedColors:(NSArray *)animatedColors withKeyTimes:(NSArray *)keyTimes;

- (void)setAnimationOffset:(CGFloat)animOffset returnColor:(void (^)(UIColor *opaqueReturnColor))block;

- (void)setFrame:(CGRect)frame arrowOffset:(CGFloat)arrowOffset text:(NSString *)text;

- (void)animateBlock:(void (^)(CFTimeInterval duration))block;

- (CGSize)popUpSizeForString:(NSString *)string;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated completionBlock:(void (^)())block;

@end
