//
//  HImageCache.m
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HImageCache.h"
#import "HNetworkEngine.h"
#import "UIImage+CropAndScale.h"

#define MAX_CACHE_BUFFER_SIZE 20

@interface HImageCache()

@property (nonatomic,strong) NSMutableArray *cacheArray;
@property (nonatomic,strong) NSMutableDictionary*    cacheDictionary;

@end

@implementation HImageCache
@synthesize cacheArray=_cacheArray;
@synthesize cacheDictionary=_cacheDictionary;

static HImageCache *sharedHImageCache = nil;

+(HImageCache *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHImageCache = [[self alloc] init];
    });
    return sharedHImageCache;
}

-(NSMutableArray *)cacheArray {
    if (_cacheArray == nil) {
        _cacheArray = [[NSMutableArray alloc] init];
    }
    
    return _cacheArray;
}

-(NSMutableDictionary *)cacheDictionary {
    if (_cacheDictionary == nil) {
        _cacheDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _cacheDictionary;
}

- (void)imageWithURL:(NSString *)url withImageSize:(CGSize)imageSize withNetworkEngine:(HNetworkEngine *)engine onCompletion:(imageFromCacheBlock)imageFromCacheBlock {
    NSString *cacheID = [NSString stringWithFormat:@"%@%@", url, NSStringFromCGSize(imageSize)];
    UIImage *fetchedImage = [self.cacheDictionary objectForKey:cacheID];
    if (fetchedImage != nil) {
        DLog(@"isInCache");
        imageFromCacheBlock(fetchedImage, url);
        return;
    }
    DLog(@"NotInCache");
    [engine imageAtURL:[NSURL URLWithString:url] onCompletion:^(UIImage *fetchedImage, NSURL *aUrl, BOOL isInCache) {
        if (fetchedImage) {
            UIImage *result = fetchedImage;
            if (imageSize.width != 0 && imageSize.height != 0) {
                result = [fetchedImage imageByScalingAndCroppingForSize:imageSize];
            }
            imageFromCacheBlock(result, url);
            
            if (![self.cacheArray containsObject:cacheID]) {
                [self.cacheArray addObject:cacheID];
            }
            [self.cacheDictionary setObject:result forKey:cacheID];
            if ([self.cacheArray count]>MAX_CACHE_BUFFER_SIZE) {
                //remove
                NSString * str=[self.cacheArray objectAtIndex:0];
                [self.cacheDictionary removeObjectForKey:str];
                [self.cacheArray removeObjectAtIndex:0];
            }
        }
    }];
}

- (void)releaseCache {
    [self.cacheArray removeAllObjects];
    [self.cacheDictionary removeAllObjects];
}

@end
