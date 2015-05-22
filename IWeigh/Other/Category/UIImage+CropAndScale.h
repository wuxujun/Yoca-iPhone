//
//  UIImage+CropAndScale.h
//  
//
//  Created by wuxujun on 11-3-4.
//  Copyright 2011 ___xujun___. All rights reserved.
//

typedef enum {
    ISMFadeIn,
    ISMUpscaleFadeIn,
    ISMFadeOut,
    ISMUpscaleFadeOut
}ImageScaleMode;

@interface UIImage (CropAndScale)
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize screenScale:(float)screenScale ;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)scallToFullScreen;

- (UIImage *)scaleToSize:(CGSize)size scaleMode:(ImageScaleMode)scaleMode;

@end
