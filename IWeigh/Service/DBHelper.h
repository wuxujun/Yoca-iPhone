//
//  DBHelper.h
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface DBHelper : NSObject

+ (void)initDatabase;
+ (void)initDatabaseWithCompletion:(HBOOLBlock)completionBlock;

+ (FMDatabase *)db;
+ (BOOL)openDB:(NSString *)dbPath;

+(void)addColumnToTable:(NSString *)tableName ColumnName:(NSString *)column;

+ (NSArray *)queryAll:(Class)type sql:(NSString *)sql params:(NSArray *)params;
+ (NSArray *)queryAll:(Class)type conditions:(NSString *)conditions params:(NSArray *)params;
+ (NSArray *)queryAll:(Class)type fields:(NSString *)fields conditions:(NSString *)conditions params:(NSArray *)params;

+ (id)queryOne:(Class)type sql:(NSString *)sql params:(NSArray *)params;
+ (id)queryOne:(Class)type conditions:(NSString *)conditions params:(NSArray *)params;
+ (id)queryOne:(Class)type fields:(NSString *)fields conditions:(NSString *)conditions params:(NSArray *)params;

+ (BOOL)excuteSql:(NSString *)sql withArguments:(NSArray *)args;

+ (void)queryCountWithSql:(NSString *)sql params:(NSArray *)params completion:(HIndexBlock)completion;
@end
