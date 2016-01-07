//
//  DBManager.m
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "DBManager.h"
#import "DBHelper.h"
#import "WeightEntity.h"
#import "WeightHisEntity.h"
#import "AccountEntity.h"
#import "ConfigEntity.h"
#import "TargetInfoEntity.h"
#import "HomeTargetEntity.h"
#import "WarnEntity.h"
#import "HealthEntity.h"

@implementation DBManager

static DBManager *sharedDBManager=nil;
+(DBManager*)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDBManager=[[DBManager alloc]init];
        
    });
    return sharedDBManager;
}

-(NSArray*)queryAccount
{
    return [DBHelper queryAll:[AccountEntity class] conditions:@"WHERE 1=1" params:@[]];
}

-(NSArray*)queryAccountForType:(NSInteger)type
{
    return [DBHelper queryAll:[AccountEntity class] conditions:@"WHERE type=? order by id " params:@[@(type)]];
}

-(NSArray*)queryAccountForID:(long)aId
{
    return [DBHelper queryAll:[AccountEntity class] conditions:@"WHERE id=?" params:@[@(aId)]];
}

-(BOOL)updateAccountStatus:(long)aId
{
    NSString* sql=[NSString stringWithFormat:@"UPDATE t_account set isSync=1 WHERE id=%ld",(long)aId];
    return [DBHelper excuteSql:sql withArguments:@[]];
}

- (NSInteger)queryWeightHisCountWithId:(NSString *)mId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_weight_his WHERE wid=%@", mId];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}


- (BOOL)insertOrUpdateWeightHis:(NSDictionary *)info
{
    NSInteger count = [self queryWeightHisCountWithId:info[@"wid"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [WeightHisEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [WeightHisEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}


- (NSInteger)queryWeightCountWithId:(NSString *)mId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_weight WHERE wid=%@", mId];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}


- (BOOL)insertOrUpdateWeight:(NSDictionary *)info
{
    NSInteger count = [self queryWeightCountWithId:info[@"wid"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [WeightEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [WeightEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

- (NSInteger)queryAccountCountWithId:(NSString *)mId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_account WHERE id=%@", mId];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}


-(NSInteger)queryAccountCountWithType:(NSInteger)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_account WHERE type=%ld",(long)type];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

- (BOOL)insertOrUpdateAccount:(NSDictionary *)info
{
    NSInteger count = [self queryAccountCountWithId:info[@"id"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [AccountEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [AccountEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

- (NSInteger)queryConfigCountWithId:(NSString *)mId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_config WHERE id=%@", mId];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}



- (BOOL)insertOrUpdateConfig:(NSDictionary *)info
{
    NSInteger count = [self queryConfigCountWithId:info[@"id"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [ConfigEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [ConfigEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

- (NSInteger)queryTargetInfoCountWithId:(NSString *)mId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_target_info WHERE id=%@", mId];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}


- (BOOL)insertOrUpdateTargetInfo:(NSDictionary *)info
{
    NSInteger count = [self queryTargetInfoCountWithId:info[@"id"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [TargetInfoEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [TargetInfoEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSArray*)queryTargetInfo
{
    NSString* sql=@"SELECT * FROM t_target_info where type>0 ORDER BY type asc";
    return [DBHelper queryAll:[TargetInfoEntity class] sql:sql params:@[]];
}
-(NSString*)queryTargetInfoForType:(NSInteger)type
{
    NSString* sql=[NSString stringWithFormat:@"SELECT * FROM t_target_info WHERE  type=%ld",(long)type];
    NSArray* array=[DBHelper queryAll:[TargetInfoEntity class] sql:sql params:@[]];
    if ([array count]>0) {
        TargetInfoEntity* info=[array objectAtIndex:0];
        return info.content;
    }
    return @"";
}

-(NSString*)queryTargetUnitForType:(NSInteger)type
{
    NSString* sql=[NSString stringWithFormat:@"SELECT * FROM t_target_info WHERE  type=%ld",(long)type];
    NSArray* array=[DBHelper queryAll:[TargetInfoEntity class] sql:sql params:@[]];
    if ([array count]>0) {
        TargetInfoEntity* info=[array objectAtIndex:0];
        return info.unit;
    }
    return @"";
}


-(NSInteger)queryWeightCount:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_weight WHERE aid=%ld ",(long)aid];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryWeights:(NSInteger)aid
{
    NSString* sql=[NSString stringWithFormat:@"SELECT * FROM t_weight WHERE aid=%ld ORDER BY pickTime desc",(long)aid];
    return [DBHelper queryAll:[WeightEntity class] sql:sql params:@[]];
}

-(NSInteger)queryWeightCountWithPicktime:(NSString*)pickTime account:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_weight WHERE aid=%ld and pickTime='%@'",(long)aid,pickTime];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryWeightWithPicktime:(NSString *)pickTime account:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_weight WHERE aid=%ld and pickTime='%@'",(long)aid,pickTime];
    return [DBHelper queryAll:[WeightEntity class] sql:sql params:@[]];
}

-(NSArray*)queryWeightWithAccount:(NSInteger)aid days:(NSInteger)day
{
    NSString* sql=[NSString stringWithFormat:@"SELECT * from t_weight WHERE aid=%ld ORDER BY pickTime desc limit %d",(long)aid,day];
    DLog(@"%@",sql);
    return [DBHelper queryAll:[WeightEntity class] sql:sql params:@[]];
}

-(NSInteger)queryWeightHisCountWithPicktime:(NSString*)pickTime account:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_weight_his WHERE aid=%ld and pickTime='%@'",(long)aid,pickTime];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(BOOL)deleteWeightHisEntity:(NSInteger)wid
{
    NSString* sql=[NSString stringWithFormat:@"DELETE FROM t_weight_his WHERE wid=%ld",(long)wid];
    return [DBHelper excuteSql:sql withArguments:@[]];
}

-(BOOL)updateWeightHisStatus:(NSInteger)wid
{
    NSString* sql=[NSString stringWithFormat:@"UPDATE t_weight_his SET isSync=1 WHERE wid=%ld",(long)wid];
    return [DBHelper excuteSql:sql withArguments:@[]];
}

-(BOOL)updateWeightStatus:(NSInteger)wid
{
    NSString* sql=[NSString stringWithFormat:@"UPDATE t_weight SET isSync=1 WHERE wid=%ld",(long)wid];
    return [DBHelper excuteSql:sql withArguments:@[]];
}

-(NSArray*)queryWeightHisWithWeight:(NSString *)pickTime account:(NSInteger)aid
{
    NSString* sql=[NSString stringWithFormat:@"SELECT pickTime,sum(weight)/count(1) as weight,sum(fat)/count(1) as fat,sum(subFat)/count(1) as subFat,sum(visFat)/count(1) as visFat,sum(water)/count(1) as water,sum(bmr)/count(1) as BMR,sum(bodyAge)/count(1) as bodyAge,sum(muscle)/count(1) as muscle,sum(bone)/count(1) as bone,sum(bmi)/count(1) as bmi,sum(protein)/count(1) as protein FROM t_weight_his where pickTime='%@' and aid=%d",pickTime,aid];
//    DLog(@"%@",sql);
    return [DBHelper queryAll:[WeightEntity class] sql:sql params:@[]];
}

-(NSArray*)queryWeightHisWithAccountId:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_weight_his WHERE aid=%ld ORDER BY pickTime DESC ",(long)aid];
    return [DBHelper queryAll:[WeightHisEntity class] sql:sql params:@[]];
}

-(NSArray*)queryWeightHisWithPicktime:(NSString *)pickTime account:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_weight_his WHERE aid=%ld and pickTime='%@'",(long)aid,pickTime];
    return [DBHelper queryAll:[WeightHisEntity class] sql:sql params:@[]];
}

- (NSInteger)queryHomeTargetCountWithId:(NSString *)mId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_home_target WHERE id=%@", mId];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}


- (BOOL)insertOrUpdateHomeTarget:(NSDictionary *)info
{
    NSInteger count = [self queryHomeTargetCountWithId:info[@"id"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [HomeTargetEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [HomeTargetEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}


-(NSInteger)queryHomeTargetCountWithAId:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_home_target WHERE aid=%ld",(long)aid];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryHomeTargetWithAId:(NSInteger)aid status:(NSInteger)state
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_home_target WHERE aid=%ld ORDER BY TYPE ASC",(long)aid];
    if (state==1) {
        sql=[NSString stringWithFormat:@"SELECT * FROM t_home_target WHERE aid=%ld and isShow=1 ORDER BY TYPE ASC",(long)aid];
    }else if (state==2){
        sql=[NSString stringWithFormat:@"SELECT * FROM t_home_target WHERE aid=%ld and type<>0 ORDER BY TYPE ASC",(long)aid];
    }
    return [DBHelper queryAll:[HomeTargetEntity class] sql:sql params:@[]];
}


-(BOOL)insertOrUpdateWarn:(NSDictionary *)info
{
    NSInteger count = [self queryWarnCountWithId:info[@"wid"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [WarnEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [WarnEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSInteger)queryWarnCountWithId:(NSString* )wid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_warn WHERE wid=%@", wid];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryWarns
{
    NSString *sql =@"SELECT * from t_warn WHERE status=0 ORDER BY wid DESC";
    return [DBHelper queryAll:[WarnEntity class] sql:sql params:@[]];
}

-(BOOL)insertOrUpdateHealth:(NSDictionary *)info
{
    NSInteger count = [self queryHealthCountWithId:info[@"wid"]];
    __block BOOL isSuccess;
    if (count == 0) {
        [HealthEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [HealthEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSInteger)queryHealthCountWithId:(NSString *)wid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_health WHERE wid=%@", wid];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryHealthWithAId:(NSInteger)aid targetType:(NSInteger)nType start:(NSString *)startTime end:(NSString *)endTime
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_health WHERE aid=%ld and targetType=%ld",(long)aid,(long)nType];
    return [DBHelper queryAll:[WarnEntity class] sql:sql params:@[]];
}

@end
