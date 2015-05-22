//
//  PathHelper.h
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathHelper : NSObject

+ (NSString *)filePathInMainBundle:(NSString *)fileName;
+ (NSString *)filePathInCacheDirectory:(NSString *)filename;
+ (NSString *)filePathInDocument:(NSString *)filename;
+ (NSString *)documentDirectory;

+ (NSString *)filePathForHotWords;

+(BOOL)fileExistsAtPath:(NSString*)fileName;

@end
