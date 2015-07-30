//
//  TargetInfoEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/5/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "TargetInfoEntity.h"

@implementation TargetInfoEntity

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.tid=[value intValue];
    }else if([key isEqualToString:@"type"]){
        self.type=[value intValue];
    }else if([key isEqualToString:@"title"]){
        self.title=value;
    }else if([key isEqualToString:@"content"]){
        self.content=value;
    }else if([key isEqualToString:@"status"]){
        self.status=[value intValue];
    }else if([key isEqualToString:@"addtime"]){
        self.addtime=value;
    }else if([key isEqualToString:@"unit"]){
        self.unit=value;
    }else if([key isEqualToString:@"unitTitle"]){
        self.unitTitle=value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(NSString*)tableName
{
    return @"t_target_info";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"type",@"title",@"content",@"status",@"unit",@"unitTitle", nil];
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
        NSArray *integerKeyArray = @[@"id",@"type", @"status"];
        if ([integerKeyArray containsObject:key]) {
            [finalKeys addObject:key];
            [finalValues addObject:@([value integerValue])];
            [placeholder addObject:@"?"];
        }
        else{
            if (![value isEqual:[NSNull null]] && value.length > 0){
                [finalValues addObject:value];
            }else{
                [finalValues addObject:@""];
            }
            [finalKeys addObject:key];
            [placeholder addObject:@"?"];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_target_info (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
    DLog(@"%@",sql);
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
        NSArray *integerKeyArray = @[@"id",@"type",@"status"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"id"]) {
                mID = @([value integerValue]);
            }else{
                [finalValues addObject:@([value integerValue])];
                [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
            }
        }
        else{
            if (![value isEqual:[NSNull null]] && value.length > 0) {
                [finalValues addObject:value];
            }else{
                [finalValues addObject:@""];
            }
            [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_target_info set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    DLog(@"%@",sql);
    if (completion) {
        completion(sql, finalValues);
    }
    
}

@end
