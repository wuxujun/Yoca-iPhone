//
//  HealthEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/5/19.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString* sql,NSArray* arguments);

@interface HealthEntity : NSObject

@property (nonatomic, assign) NSInteger wid;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, strong) NSString * pickTime;
@property (nonatomic, assign) NSInteger targetType;
@property (nonatomic, strong) NSString * targetValue;
@property (nonatomic, assign) NSInteger isSync;
@property (nonatomic, assign) NSInteger createTime;

+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;



@end
