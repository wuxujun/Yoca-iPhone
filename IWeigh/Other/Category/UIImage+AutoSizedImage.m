//
//  UIImage+AutoSizedImage.m
//
//
//  Created by wuxujun on 12-11-7.
//  Copyright (c) 2012年 ___xujun___. All rights reserved.
//

#import "UIImage+AutoSizedImage.h"

@implementation UIImage (AutoSizedImage)

+ (UIImage *)autoSizedImageNamed:(NSString *)imageName{
    NSInteger location = [imageName rangeOfString:@".png"].location;
    if(location != NSNotFound){
        imageName = [imageName substringToIndex:location];
    }
    
    [UIDevice currentDevice];

    if (IS_IPHONE_5) {
        imageName = [imageName stringByAppendingString:@"-568h"]; //must without @2x
    }
    
    imageName = [imageName stringByAppendingString:@".png"];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
#ifdef DEBUG
    NSAssert(image, @"没有加载到图片");
#endif
    return image;
}

@end
