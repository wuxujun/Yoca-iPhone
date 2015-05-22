//
//  HImageCache.h
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TopicCellImageViewSize CGSizeMake(80,60)
#define NewsCellImageViewSize CGSizeMake(72,54)
#define NewsCommentCellImageViewSize CGSizeMake(36,36)
#define UserInfoImageViewSize CGSizeMake(64,64)

@class HNetworkEngine;

typedef void (^imageFromCacheBlock)(UIImage* fetchedImage,NSString* url);

@interface HImageCache : NSObject

+(HImageCache *)sharedInstance;
- (void)imageWithURL:(NSString *)url withImageSize:(CGSize)imageSize withNetworkEngine:(HNetworkEngine *)engine onCompletion:(imageFromCacheBlock)imageFromCacheBlock;
- (void)releaseCache;

@end
