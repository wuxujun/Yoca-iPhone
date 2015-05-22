//
//  WarnEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/5/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString* sql,NSArray* arguments);

@interface WarnEntity : NSObject

@property (nonatomic,assign) NSInteger  wid;
@property (nonatomic,assign) NSInteger  type;
@property (nonatomic,strong) NSString*  title;
@property (nonatomic,assign) NSInteger  repeats;
@property (nonatomic,assign) NSInteger  weekMon;
@property (nonatomic,assign) NSInteger  weekTue;
@property (nonatomic,assign) NSInteger  weekWed;
@property (nonatomic,assign) NSInteger  weekThu;
@property (nonatomic,assign) NSInteger  weekFir;
@property (nonatomic,assign) NSInteger  weekSat;
@property (nonatomic,assign) NSInteger  weekSun;
@property (nonatomic,assign) NSInteger  hours;
@property (nonatomic,assign) NSInteger  minutes;
@property (nonatomic,strong) NSString*  note;
@property (nonatomic,assign) NSInteger  status;
@property (nonatomic,assign) NSInteger  isSync;
@property (nonatomic,assign) NSInteger  addtime;

+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;


@end
