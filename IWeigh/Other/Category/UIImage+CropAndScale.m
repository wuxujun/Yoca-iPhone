//
//  UIImage+CropAndScale.m
//
//
//  Created by wuxujun on 11-2-27.
//  Copyright 2011 ___xujun___. All rights reserved.
//

#import "UIImage+CropAndScale.h"


@implementation UIImage (CropAndScale)

- (float)getScreenScale {
    static float sysver = 0;
    if (sysver == 0) {
        sysver = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    static float screenScale = 0;
    if (screenScale == 0) {
        if (sysver >= 4.0) {
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                screenScale = [[UIScreen mainScreen] scale];
            }else{
                screenScale = 1.0;
            }
        }
        else {
            screenScale = 1.0;
        }
    }
    
    return screenScale;
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize screenScale:(float)screenScale {
    UIImage *sourceImage = self;  
    UIImage *newImage = nil;          
    CGSize imageSize = sourceImage.size;  
    CGFloat width = imageSize.width;  
    CGFloat height = imageSize.height;  
    CGFloat targetWidth = targetSize.width;  
    CGFloat targetHeight = targetSize.height;  
    CGFloat scaleFactor = 0.0;  
    CGFloat scaledWidth = targetWidth;  
    CGFloat scaledHeight = targetHeight;  
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);  
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)  {  
        CGFloat widthFactor = targetWidth / width;  
        CGFloat heightFactor = targetHeight / height;  
        if (widthFactor > heightFactor)   
            scaleFactor = widthFactor; // scale to fit height  
        else  
            scaleFactor = heightFactor; // scale to fit width  
        scaledWidth  = width * scaleFactor;  
        scaledHeight = height * scaleFactor;  
        // center the image  
        if (widthFactor > heightFactor)  {  
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;   
        }  
        else   
            if (widthFactor < heightFactor)  {  
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;  
            }  
    } 
    
    if (screenScale != 1.0) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, screenScale);
    } else {
        UIGraphicsBeginImageContext(targetSize);
    }
    
    //UIGraphicsBeginImageContext(targetSize); // this will crop  
    CGRect thumbnailRect = CGRectZero;  
    thumbnailRect.origin = thumbnailPoint;  
    thumbnailRect.size.width  = scaledWidth;  
    thumbnailRect.size.height = scaledHeight;  
    [sourceImage drawInRect:thumbnailRect];  
    newImage = UIGraphicsGetImageFromCurrentImageContext();  
    if(newImage == nil)   
        DLog(@"could not scale image");
    //pop the context to get back to the default  
    UIGraphicsEndImageContext();
    return newImage; 
}


- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize  {   
    return [self imageByScalingAndCroppingForSize:targetSize screenScale:[self getScreenScale]];
}
- (UIImage *)scallToFullScreen{
    CGSize mySize = self.size;
    CGSize screenSize = CGSizeMake(320, 480);
    float myRatio = mySize.width/mySize.height;
    float screenRatio = screenSize.width/screenSize.height;
    float actualHeight = mySize.height;
    float actualWidth = mySize.width;


        if(myRatio < screenRatio){
            myRatio = screenSize.height / actualHeight;
            actualWidth = myRatio * actualWidth;
            actualHeight = screenSize.height;
        }
        else
        {
            myRatio = screenSize.width / actualWidth;
            actualHeight = myRatio * actualHeight;
            actualWidth = screenSize.width;
        }

    return [self imageByScalingAndCroppingForSize:CGSizeMake(actualWidth, actualHeight)];
}

- (UIImage *) scaleToSize:(CGSize)size scaleMode:(ImageScaleMode)scaleMode
{
    UIImage *thumbnail;
    int originalImageHeight = self.size.height;
    
    int originalImageWidth = self.size.width;
    
    if(originalImageHeight <= size.height && originalImageWidth <= size.width && scaleMode != ISMUpscaleFadeIn && scaleMode != ISMUpscaleFadeOut)
    {
        return self;
    }
    else 
    {
        int originalX = 0;
        int originalY = 0;
        if (scaleMode == ISMFadeOut || scaleMode == ISMUpscaleFadeOut) {
            if ((float)originalImageWidth / originalImageHeight > (float)size.width / size.height)
            {
                originalImageWidth = ((float)originalImageWidth / originalImageHeight) * size.height;
                originalImageHeight = size.height;
                originalX = (originalImageWidth - size.width) / 2;
            }
            else
            {
                originalImageHeight = ((float)originalImageHeight / originalImageWidth) * size.width;
                originalImageWidth = size.width;
                originalY = (originalImageHeight - size.height) / 2;
            }
        }
        else if (scaleMode == ISMUpscaleFadeIn) {
            if ((float)originalImageWidth / originalImageHeight > (float)size.width / size.height) {
                originalImageHeight = ((float)originalImageHeight / originalImageWidth) * size.width;
                originalImageWidth = size.width;
                originalY = -(size.height - originalImageHeight) / 2;
            }
            else if ((float)originalImageWidth / originalImageHeight < (float)size.width / size.height) {
                originalImageWidth = ((float)originalImageWidth / originalImageHeight) *size.height;
                originalImageHeight = size.height;
                originalX = -(size.width - originalImageWidth) / 2;
            }
            else {
                originalImageWidth = size.width;
                originalImageHeight = size.height;
            }
        }
        else {
            if ((float)originalImageWidth / originalImageHeight > (float)size.width / size.height) {
                originalImageHeight = ((float)originalImageHeight / originalImageWidth) * size.width;
                originalImageWidth = size.width;
            }
            else if ((float)originalImageWidth / originalImageHeight < (float)size.width / size.height) {
                originalImageWidth = ((float)originalImageWidth / originalImageHeight) *size.height;
                originalImageHeight = size.height;
            }
            else {
                originalImageWidth = size.width;
                originalImageHeight = size.height;
            }
        }
        
        CGSize itemSize;
        if (scaleMode == ISMFadeOut || scaleMode == ISMUpscaleFadeOut) {
            itemSize = CGSizeMake(size.width, size.height);
        }
        else if (scaleMode == ISMUpscaleFadeIn){
            itemSize = CGSizeMake(size.width, size.height);
        }
        else {
            itemSize = CGSizeMake(originalImageWidth, originalImageHeight);
        }
        
        float screenScale = [self getScreenScale];
        if (screenScale != 1.0) {
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, screenScale);
        } else {
            UIGraphicsBeginImageContext(itemSize);
        }
        if (scaleMode == ISMUpscaleFadeIn) {
            [[UIColor blackColor] setFill];
            UIRectFill(CGRectMake(0, 0, itemSize.width, itemSize.height));
        }
        
        CGRect imageRect = CGRectMake(-originalX, -originalY, originalImageWidth, originalImageHeight);
        
        [self drawInRect:imageRect];
        
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return thumbnail;
}

@end
