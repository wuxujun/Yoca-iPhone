//
//  UIImage+Setting.m
//
//
//  Created by wuxujun on 13-9-12.
//
//

#import "UIImage+Setting.h"
#import "UserDefaultHelper.h"

@implementation UIImage (Setting)

+ (BOOL)currentSystemImageModeIsLarge
{
    NSString *imageMode = [UserDefaultHelper objectForKey:SYSTEM_IMAGE_KEY];
    return [imageMode isEqualToString:SYSTEM_LARGE_IMAGE];
}

+ (BOOL)currentSystemImageModeIsSmall
{
    NSString *imageMode = [UserDefaultHelper objectForKey:SYSTEM_IMAGE_KEY];
    return [imageMode isEqualToString:SYSTEM_SMALL_IMAGE];
}

@end
