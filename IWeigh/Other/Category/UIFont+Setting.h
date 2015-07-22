//
//  UIFont+Setting.h
//  Adicon
//
//  Created by WuBingru on 13-9-5.
//
//

#import <UIKit/UIKit.h>

@interface UIFont (Setting)

+ (UIFont *)currentSystemFontBasedOn:(CGFloat)fontsize;
+ (NSInteger)currentSystemFontSizeBasedOn:(CGFloat)fontsize;

+ (BOOL)currentSystemFontStyleIsLarge;
+ (BOOL)currentSystemFontStyleIsMiddle;
+ (BOOL)currentSystemFontStyleIsSmall;

@end
