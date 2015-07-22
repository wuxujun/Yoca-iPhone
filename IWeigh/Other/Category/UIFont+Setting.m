//
//  UIFont+Setting.m
//  Adicon
//
//  Created by WuBingru on 13-9-5.
//
//

#import "UIFont+Setting.h"
#import "UserDefaultHelper.h"

@implementation UIFont (Setting)

+ (UIFont *)currentSystemFontBasedOn:(CGFloat)fontsize
{
    return [UIFont systemFontOfSize:[self currentSystemFontSizeBasedOn:fontsize]];
}

+ (NSInteger)currentSystemFontSizeBasedOn:(CGFloat)fontsize
{
    NSString *fontStyle = [UserDefaultHelper objectForKey:SYSTEM_FONT_KEY];
    if ([fontStyle isEqualToString:SYSTEM_SMALL_FONT]) {
        fontsize -= 2;
    }else if([fontStyle isEqualToString:SYSTEM_LARGE_FONT]){
        fontsize += 3;
    }
    
    return fontsize;
}

+ (BOOL)currentSystemFontStyleIsLarge
{
    NSString *fontStyle = [UserDefaultHelper objectForKey:SYSTEM_FONT_KEY];
    return [fontStyle isEqualToString:SYSTEM_LARGE_FONT];
}

+ (BOOL)currentSystemFontStyleIsMiddle
{
    NSString *fontStyle = [UserDefaultHelper objectForKey:SYSTEM_FONT_KEY];
    return [fontStyle isEqualToString:SYSTEM_MID_FONT];
}

+ (BOOL)currentSystemFontStyleIsSmall
{
    NSString *fontStyle = [UserDefaultHelper objectForKey:SYSTEM_FONT_KEY];
    return [fontStyle isEqualToString:SYSTEM_SMALL_FONT];
}

@end
