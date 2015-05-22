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

-(NSArray*)queryAccountForID:(NSInteger)aId
{
    return [DBHelper queryAll:[AccountEntity class] conditions:@"WHERE id=?" params:@[@(aId)]];
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
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_account WHERE type=%ld",type];
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
    NSString* sql=@"SELECT * FROM t_target_info ORDER BY type desc";
    return [DBHelper queryAll:[TargetInfoEntity class] sql:sql params:@[]];
}

-(NSArray*)queryWeights:(NSInteger)aid
{
    NSString* sql=[NSString stringWithFormat:@"SELECT * FROM t_weight WHERE aid=%ld ORDER BY picktime desc",aid];
    return [DBHelper queryAll:[WeightEntity class] sql:sql params:@[]];
}

-(NSInteger)queryWeightCountWithPicktime:(NSString*)pickTime account:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_weight WHERE aid=%ld and picktime='%@'",aid,pickTime];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryWeightWithPicktime:(NSString *)pickTime account:(NSInteger)aid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_weight WHERE aid=%ld and picktime='%@'",aid,pickTime];
    return [DBHelper queryAll:[WeightEntity class] sql:sql params:@[]];
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
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from t_home_target WHERE aid=%ld",aid];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryHomeTargetWithAId:(NSInteger)aid status:(NSInteger)state
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_home_target WHERE aid=%ld ORDER BY TYPE ASC",aid];
    if (state==1) {
        sql=[NSString stringWithFormat:@"SELECT * FROM t_home_target WHERE aid=%ld and state=1 ORDER BY TYPE ASC",aid];
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

@end
