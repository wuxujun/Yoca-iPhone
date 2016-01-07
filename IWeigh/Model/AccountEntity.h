//
//  AccountEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SqlBlock)(NSString *sql, NSArray *arguments);

@interface AccountEntity : NSObject

@property (nonatomic, assign) long aid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * userNick;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, assign) NSInteger targetType;
@property (nonatomic, strong) NSString * targetWeight;
@property (nonatomic, strong) NSString * targetFat;
@property (nonatomic, strong) NSString * doneTime;

@property (nonatomic, strong) NSString * weight;
@property (nonatomic, strong) NSString * fat;
@property (nonatomic, strong) NSString * subFat;
@property (nonatomic, strong) NSString * visFat;
@property (nonatomic, strong) NSString * water;
@property (nonatomic, strong) NSString * bmr;
@property (nonatomic, strong) NSString * bodyAge;
@property (nonatomic, strong) NSString * muscle;
@property (nonatomic, strong) NSString * bone;
@property (nonatomic, strong) NSString * bmi;
@property (nonatomic, strong) NSString * protein;

@property (nonatomic, assign) NSInteger isSync;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger addtime;


+ (void)generateInsertSql:(NSDictionary *)aInfo completion:(SqlBlock)completion;
+ (void)generateUpdateSql:(NSDictionary *)aInfo completion:(SqlBlock)completion;
@end
