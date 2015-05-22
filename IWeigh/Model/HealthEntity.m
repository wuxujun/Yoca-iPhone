//
//  HealthEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/5/19.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HealthEntity.h"

@implementation HealthEntity
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"wid"]) {
        self.wid=[value intValue];
    }else if ([key isEqualToString:@"aid"]) {
        self.aid=[value intValue];
    }else if([key isEqualToString:@"pickTime"]){
        self.pickTime=value;
    }else if([key isEqualToString:@"targetType"]){
        self.targetType=[value integerValue];
    }else if([key isEqualToString:@"targetValue"]){
        self.targetValue=value;
    }else if([key isEqualToString:@"isSync"]){
        self.isSync=[value integerValue];
    }else if([key isEqualToString:@"createTime"]){
        self.createTime=[value integerValue];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"undefined Key: %@",key);
}

+(NSString*)tableName
{
    return @"t_health";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"wid",@"aid",@"pickTime",@"targetType",@"targetValue",@"isSync",@"createTime", nil];
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
        NSArray *integerKeyArray = @[@"wid",@"aid",@"targetType",@"isSync",@"createTime"];
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
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_health (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
    
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
        NSArray *integerKeyArray = @[@"wid",@"aid",@"targetType",@"isSync",@"createTime"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"wid"]) {
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
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_health set %@ WHERE syncid=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    
    if (completion) {
        completion(sql, finalValues);
    }
    
}
@end
