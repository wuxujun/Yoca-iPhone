//
//  TargetInfoEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/5/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString* sql,NSArray* arguments);

@interface TargetInfoEntity : NSObject

@property (nonatomic,assign) NSInteger  tid;
@property (nonatomic,assign) NSInteger  type;
@property (nonatomic,strong) NSString*  title;
@property (nonatomic,strong) NSString*  content;
@property (nonatomic,assign) NSInteger  status;
@property (nonatomic,strong) NSString*  addtime;
@property (nonatomic,strong) NSString*  unit;
@property (nonatomic,strong) NSString*  unitTitle;

+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
