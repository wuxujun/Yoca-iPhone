//
//  WeightHisEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString* sql,NSArray* arguments);

@interface WeightHisEntity : NSObject

@property (nonatomic, assign) NSInteger wid;
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, strong) NSString * pickTime;
@property (nonatomic, strong) NSString * weight;
@property (nonatomic, strong) NSString * fat;
@property (nonatomic, strong) NSString * subFat;
@property (nonatomic, strong) NSString * visFat;
@property (nonatomic, strong) NSString * water;
@property (nonatomic, strong) NSString * BMR;
@property (nonatomic, strong) NSString * bodyAge;
@property (nonatomic, strong) NSString * muscle;
@property (nonatomic, strong) NSString * bone;
@property (nonatomic, strong) NSString * bmi;
@property (nonatomic, assign) NSInteger  isSync;
@property (nonatomic, assign) NSInteger addtime;
@property (nonatomic, assign) NSInteger syncid;
@property (nonatomic, strong) NSString* protein;
@property (nonatomic, strong) NSString* sholai;
@property (nonatomic, assign) NSInteger bust;
@property (nonatomic, assign) NSInteger waistline;
@property (nonatomic, assign) NSInteger hips;
@property (nonatomic, strong) NSString* avatar;



+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
