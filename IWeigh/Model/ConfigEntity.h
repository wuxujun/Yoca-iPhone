//
//  ConfigEntity.h
//  IWeigh
//
//  Created by xujunwu on 15/5/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString* sql,NSArray* arguments);

@interface ConfigEntity : NSObject
@property(nonatomic,assign)NSInteger aid;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSString*    title;
@property(nonatomic,assign)NSInteger    week;
@property(nonatomic,strong)NSString*    beginDay;
@property(nonatomic,strong)NSString*    endDay;
@property(nonatomic,assign)NSInteger    status;


+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;


@end
