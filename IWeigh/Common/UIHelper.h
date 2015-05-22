//
//  UIHelper.h
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

+(void)showAlertMessage:(NSString *)message;

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+(void)showAlertViewWithMessage:(NSString *)message;
+(void)showAlertViewWithMessage:(NSString *)message callback:(void(^)(void))callback;

+(UIView *)logoTitleViewWithText:(NSString *)text;
+(UIImage *)loadingImageWithSize:(CGSize)size useSmallLog:(BOOL)useSmall;

@end
