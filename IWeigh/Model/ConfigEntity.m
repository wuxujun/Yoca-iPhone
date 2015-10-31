//
//  ConfigEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/5/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "ConfigEntity.h"

@implementation ConfigEntity
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.aid=[value intValue];
    }else if([key isEqualToString:@"type"]){
        self.type=[value intValue];
    }else if([key isEqualToString:@"title"]){
        self.title=value;
    }else if([key isEqualToString:@"week"]){
        self.week=[value intValue];
    }else if([key isEqualToString:@"beginDay"]){
        self.beginDay=value;
    }else if([key isEqualToString:@"endDay"]){
        self.endDay=value;
    }else if([key isEqualToString:@"status"]){
        self.status=[value intValue];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(NSString*)tableName
{
    return @"t_config";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"type",@"title",@"week",@"beginDay",@"endDay",@"status", nil];
}

+(void)generateInsertSql:(NSDictionary *)info completion:(SqlBlock)completion
{
    NSMutableArray *finalKeys = [NSMutableArray array];
    NSMutableArray *finalValues = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];
    
    NSArray *keys = [info allKeys];
    NSArray *values = [info allValues];
    for (int i=0; i<values.count; i++) {
        NSString *value = values[i];
        NSString *key = keys[i];
        NSArray *integerKeyArray = @[@"id",@"type",@"week",@"status"];
        if ([integerKeyArray containsObject:key]) {
            [finalKeys addObject:key];
            [finalValues addObject:@([value integerValue])];
            [placeholder addObject:@"?"];
        }else{
            if (![value isEqual:[NSNull null]] && value.length > 0){
                [finalValues addObject:value];
            }else{
                [finalValues addObject:@""];
            }
            [finalKeys addObject:key];
            [placeholder addObject:@"?"];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_config (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
//    DLog(@"%@",sql);
    if (completion) {
        completion(sql, finalValues);
    }
    
}

+(void)generateUpdateSql:(NSDictionary *)info completion:(SqlBlock)completion
{
    NSArray *keys = [info allKeys];
    NSArray *values = [info allValues];
    
    NSMutableArray *kvPairs = [NSMutableArray array];
    NSMutableArray *finalValues = [NSMutableArray array];
    
    NSNumber *mID = nil;
    for (int i=0; i<values.count; i++) {
        NSString *value = values[i];
        NSString *key = keys[i];
        NSArray *integerKeyArray = @[@"id",@"type",@"week",@"status"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"id"]) {
                mID = @([value integerValue]);
            }else{
                [finalValues addObject:@([value integerValue])];
                [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
            }
        }else{
            if (![value isEqual:[NSNull null]] && value.length > 0) {
                [finalValues addObject:value];
            }else{
                [finalValues addObject:@""];
            }
            [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_config set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
//    DLog(@"%@",sql);
    if (completion) {
        completion(sql, finalValues);
    }
    
}


@end
