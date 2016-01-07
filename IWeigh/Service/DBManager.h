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
-(NSArray*)queryAccountForID:(long)aId;
-(BOOL)updateAccountStatus:(long)aId;

-(NSInteger)queryAccountCountWithType:(NSInteger)type;

- (BOOL)insertOrUpdateAccount:(NSDictionary *)info;
- (BOOL)insertOrUpdateWeight:(NSDictionary *)info;
- (BOOL)insertOrUpdateWeightHis:(NSDictionary *)info;
- (BOOL)insertOrUpdateConfig:(NSDictionary *)info;
- (BOOL)insertOrUpdateTargetInfo:(NSDictionary *)info;
-(NSArray*)queryTargetInfo;
-(NSString*)queryTargetInfoForType:(NSInteger)type;
-(NSString*)queryTargetUnitForType:(NSInteger)type;

-(NSInteger)queryWeightCount:(NSInteger)aid;
-(NSArray*)queryWeights:(NSInteger)aid;
-(NSInteger)queryWeightCountWithPicktime:(NSString*)pickTime account:(NSInteger)aid;
-(NSArray*)queryWeightWithPicktime:(NSString*)pickTime account:(NSInteger)aid;
-(NSArray*)queryWeightWithAccount:(NSInteger)aid days:(NSInteger)day;
-(NSInteger)queryWeightHisCountWithPicktime:(NSString*)pickTime account:(NSInteger)aid;
-(NSArray*)queryWeightHisWithPicktime:(NSString*)pickTime account:(NSInteger)aid;
-(NSArray*)queryWeightHisWithAccountId:(NSInteger)aid;
-(BOOL)deleteWeightHisEntity:(NSInteger)wid;
-(BOOL)updateWeightHisStatus:(NSInteger)wid;
-(BOOL)updateWeightStatus:(NSInteger)wid;
-(NSArray*)queryWeightHisWithWeight:(NSString *)pickTime account:(NSInteger)aid;

-(BOOL)insertOrUpdateHomeTarget:(NSDictionary*)info;
-(NSInteger)queryHomeTargetCountWithAId:(NSInteger)aid;
-(NSArray*)queryHomeTargetWithAId:(NSInteger)aid status:(NSInteger)state;

-(BOOL)insertOrUpdateWarn:(NSDictionary*)info;
-(NSInteger)queryWarnCountWithId:(NSString*)wid;
-(NSArray*)queryWarns;

-(BOOL)insertOrUpdateHealth:(NSDictionary*)info;
-(NSInteger)queryHealthCountWithId:(NSString*)wid;
-(NSArray*)queryHealthWithAId:(NSInteger)aid targetType:(NSInteger)nType start:(NSString*)startTime end:(NSString*)endTime;


@end
