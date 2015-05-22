//
//  HomeTargetEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/5/12.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SqlBlock)(NSString* sql,NSArray* arguments);

@interface HomeTargetEntity : NSObject

@property (nonatomic,assign) NSInteger  tid;
@property (nonatomic,assign) NSInteger  aid;
@property (nonatomic,assign) NSInteger  type;
@property (nonatomic,strong) NSString*  title;
@property (nonatomic,assign) NSInteger  state;
@property (nonatomic,strong) NSString*  unit;
@property (nonatomic,assign) NSInteger  sex;
@property (nonatomic,assign) NSInteger  height;
@property (nonatomic,strong) NSString   *value;
@property (nonatomic,strong) NSString   *valueTitle;
@property (nonatomic,strong) NSString*  progres;


+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end

