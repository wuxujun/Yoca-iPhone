//
//  UIHelper.m
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "UIHelper.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation UIHelper

+(void)showAlertMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+(void)showAlertViewWithMessage:(NSString *)message{
    [self showAlertViewWithMessage:message callback:NULL];
}

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message{
    [self showAlertViewWithTitle:title essage:message callback:NULL];
}

+(void)showAlertViewWithMessage:(NSString *)message callback:(void(^)(void))callback{
    [self showAlertViewWithTitle:nil essage:message callback:callback];
}

+(void)showAlertViewWithTitle:(NSString *)title essage:(NSString *)message callback:(void(^)(void))callback{
    [UIAlertView alertViewWithTitle:nil message:message cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
        ;
    } onCancel:^{
        if (callback) {
            callback();
        }
    }];
}

+(UIView *)logoTitleViewWithText:(NSString *)text{
    UIImage *logoImage = [UIImage imageNamed:@"BoneIcon.png"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:19];
    label.shadowColor = RGBCOLOR(0/255.0, 60/255.0, 86/255.0);
    label.shadowOffset = CGSizeMake(0, -1);
    [label sizeToFit];
    
    CGRect labelFrame = label.bounds;
    labelFrame.origin.x = logoImage.size.width+3;
    labelFrame.size.height = logoImage.size.height;
    label.frame = labelFrame;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, labelFrame.origin.x+labelFrame.size.width, labelFrame.size.height)];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.image = logoImage;
    
    [imageView addSubview:label];
    
    return imageView;
}
+(UIImage *)loadingImageWithSize:(CGSize)size useSmallLog:(BOOL)useSmall{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = LoadingImageBackgroundColor;
    
    UIImage *image = [UIImage imageNamed:@"LoadImgSmall.png"];
    CGSize imageSize = image.size;
    if (!useSmall) {
        image = [UIImage imageNamed:@"LoadImgBig.png"];
        imageSize = image.size;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect imageViewFrame = CGRectMake((size.width-imageSize.width)/2, (size.height-imageSize.height)/2, imageSize.width, imageSize.width);
    imageView.frame = imageViewFrame;
    
    [view addSubview:imageView];
    
    UIGraphicsBeginImageContext(size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *loadingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return loadingImage;
}


//+(DXImageViewer *)imageViewer{
//    static DXImageViewer *viewer = nil;
//    if(viewer==nil){
//        viewer = [[DXImageViewer alloc] init];
//    }
//    return viewer;
//}



@end
