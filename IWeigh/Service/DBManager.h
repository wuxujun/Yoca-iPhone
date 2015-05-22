//
//  DBManager.h
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(DBManager*)getInstance;

-(NSArray*)queryAccount;
-(NSArray*)queryAccountForType:(NSInteger)type;
-(NSArray*)queryAccountForID:(NSInteger)aId;

-(NSInteger)queryAccountCountWithType:(NSInteger)type;

- (BOOL)insertOrUpdateAccount:(NSDictionary *)info;
- (BOOL)insertOrUpdateWeight:(NSDictionary *)info;
- (BOOL)insertOrUpdateWeightHis:(NSDictionary *)info;
- (BOOL)insertOrUpdateConfig:(NSDictionary *)info;
- (BOOL)insertOrUpdateTargetInfo:(NSDictionary *)info;
-(NSArray*)queryTargetInfo;

-(NSArray*)queryWeights:(NSInteger)aid;
-(NSInteger)queryWeightCountWithPicktime:(NSString*)pickTime account:(NSInteger)aid;
-(NSArray*)queryWeightWithPicktime:(NSString*)pickTime account:(NSInteger)aid;

-(BOOL)insertOrUpdateHomeTarget:(NSDictionary*)info;
-(NSInteger)queryHomeTargetCountWithAId:(NSInteger)aid;
-(NSArray*)queryHomeTargetWithAId:(NSInteger)aid status:(NSInteger)state;

-(BOOL)insertOrUpdateWarn:(NSDictionary*)info;
-(NSInteger)queryWarnCountWithId:(NSString*)wid;
-(NSArray*)queryWarns;

@end
