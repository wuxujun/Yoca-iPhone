//
//  DBHelper.m
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "DBHelper.h"
#import "PathHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "blocktypedef.h"

#define DB_FILE_IN_MAIN_BUNDLE [PathHelper filePathInMainBundle:DB_FILE_NAME]
#define DB_FILE_IN_DOCUMENT    [PathHelper filePathInDocument:DB_FILE_NAME]

static FMDatabase *db;

@implementation DBHelper

+ (void)initDatabase
{
    BOOL isDataBaseInDocument = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:DB_FILE_IN_DOCUMENT]) {
        isDataBaseInDocument = NO;
    }
    
    if (!isDataBaseInDocument) {
        NSError *error;
        isDataBaseInDocument = [[NSFileManager defaultManager] copyItemAtPath:DB_FILE_IN_MAIN_BUNDLE
                                                                       toPath:DB_FILE_IN_DOCUMENT
                                                                        error:&error];
        if (isDataBaseInDocument) {
            [DBHelper openDB:DB_FILE_IN_DOCUMENT];
        }
    }else{
        [DBHelper openDB:DB_FILE_IN_DOCUMENT];
    }
}

+ (void)initDatabaseWithCompletion:(HBOOLBlock)completionBlock
{
    BOOL isDataBaseInDocument = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:DB_FILE_IN_DOCUMENT]) {
        isDataBaseInDocument = NO;
    }
    
    //    if (![DBHelper openDB:DB_FILE_IN_DOCUMENT]) {
    //        isDataBaseInDocument = NO;
    //    }
    
    if (!isDataBaseInDocument) {
        NSError *error;
        isDataBaseInDocument = [[NSFileManager defaultManager] copyItemAtPath:DB_FILE_IN_MAIN_BUNDLE
                                                                       toPath:DB_FILE_IN_DOCUMENT
                                                                        error:&error];
        if (isDataBaseInDocument) {
            [DBHelper openDB:DB_FILE_IN_DOCUMENT];
        }
    }else{
        [DBHelper openDB:DB_FILE_IN_DOCUMENT];
    }
    
    if (completionBlock) {
        completionBlock(isDataBaseInDocument);
    }
}

+ (BOOL)openDB:(NSString *)dbPath
{
    if (db) {
        [db close];
        db = nil;
    }
    sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    db = [[FMDatabase alloc] initWithPath:dbPath];
    BOOL ret = [db open];
    DLog(@"Open database [%@] %@", dbPath, ret ? @"success" : @"failed");
    DLog(@"Sqlite version %@", [FMDatabase sqliteLibVersion]);
    return ret;
}

+ (FMDatabase *)db
{
    return db;
}

+(void)addColumnToTable:(NSString *)tableName ColumnName:(NSString *)column
{
    
    if ((tableName == nil) || (column == nil))
    {
        return;
    }
    BOOL bExist = [db columnExists:column inTableWithName:tableName];
    
    if (!bExist) {
        
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",tableName,column];
        
        [db executeUpdate:sql]; 
        
    }
}

+ (NSArray *)queryAll:(Class)type sql:(NSString *)sql params:(NSArray *)params
{
//    DLog(@"DB query: %@", sql);
//    DLog(@"Params: %@", params);
#ifdef DEBUG_MODE
    [db setLogsErrors:YES];
#endif
    
    // 创建，最好放在一个单例的类中
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DB_FILE_IN_DOCUMENT];
    
    // 使用
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:params];
        while ([rs next]) {
            NSObject *obj = [[type alloc] init];
            [rs kvcMagic:obj];
            [ret addObject:obj];
        }
        [rs close];
    }];
    
    return ret;
}

+ (NSArray *)queryAll:(Class)type conditions:(NSString *)conditions params:(NSArray *)params {
    NSArray *fields = [type performSelector:@selector(fields)];
    NSArray *ret = [self queryAll:type fields:[fields componentsJoinedByString:@", "] conditions:conditions params:params];
    return ret;
}


+ (NSArray *)queryAll:(Class)type fields:(NSString *)fields conditions:(NSString *)conditions params:(NSArray *)params {
    NSString *tableName = [type performSelector:@selector(tableName)];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@", fields, tableName, conditions ?: @""];
    NSArray *ret = [self queryAll:type sql:sql params:params];
    return ret;
}


+ (id)queryOne:(Class)type sql:(NSString *)sql params:(NSArray *)params {
    NSArray *ret = [self queryAll:type sql:sql params:params];
    return [ret count] > 0 ? [ret objectAtIndex:0] : nil;
}


+ (id)queryOne:(Class)type conditions:(NSString *)conditions params:(NSArray *)params {
    NSArray *ret = [self queryAll:type conditions:conditions params:params];
    return [ret count] > 0 ? [ret objectAtIndex:0] : nil;
}


+ (id)queryOne:(Class)type fields:(NSString *)fields conditions:(NSString *)conditions params:(NSArray *)params {
    NSArray *ret = [self queryAll:type fields:fields conditions:conditions params:params];
    return [ret count] > 0 ? [ret objectAtIndex:0] : nil;
}

+ (BOOL)excuteSql:(NSString *)sql withArguments:(NSArray *)args{
    __block BOOL isSuccess = NO;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DB_FILE_IN_DOCUMENT];
    [queue inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    
    return isSuccess;
}

+ (void)queryCountWithSql:(NSString *)sql params:(NSArray *)params completion:(HIndexBlock)completion{
    __block NSInteger count = 0;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DB_FILE_IN_DOCUMENT];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, params];
        if ([rs next]) {
            count = [rs intForColumnIndex:0];
        }
        [rs close];
        if (completion) {
            completion(count);
        }
    }];
}

@end
