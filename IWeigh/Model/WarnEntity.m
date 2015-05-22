//
//  WarnEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/5/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "WarnEntity.h"

@implementation WarnEntity

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.wid=[value intValue];
    }else if([key isEqualToString:@"type"]){
        self.type=[value intValue];
    }else if([key isEqualToString:@"title"]){
        self.title=value;
    }else if([key isEqualToString:@"status"]){
        self.status=[value intValue];
    }else if([key isEqualToString:@"addtime"]){
        self.addtime=[value intValue];
    }else if([key isEqualToString:@"repeats"]){
        self.repeats=[value intValue];
    }else if([key isEqualToString:@"weekMon"]){
        self.weekMon=[value intValue];
    }else if([key isEqualToString:@"weekTue"]){
        self.weekTue=[value intValue];
    }else if([key isEqualToString:@"weekWed"]){
        self.weekWed=[value intValue];
    }else if([key isEqualToString:@"weekThu"]){
        self.weekThu=[value intValue];
    }else if([key isEqualToString:@"weekFir"]){
        self.weekFir=[value intValue];
    }else if([key isEqualToString:@"weekSat"]){
        self.weekSat=[value intValue];
    }else if([key isEqualToString:@"weekSun"]){
        self.weekSun=[value intValue];
    }else if([key isEqualToString:@"hours"]){
        self.hours=[value intValue];
    }else if([key isEqualToString:@"minutes"]){
        self.minutes=[value intValue];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(NSString*)tableName
{
    return @"t_warn";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"wid",@"type",@"title",@"repeats",@"weekMon",@"weekTue",@"weekWed",@"weekThu",@"weekFir",@"weekSat",@"weekSun",@"hours",@"minutes",@"note",@"status",@"isSync", nil];
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
        NSArray *integerKeyArray = @[@"wid",@"type",@"repeats",@"weekMon",@"weekTue",@"weekWed",@"weekThu",@"weekFir",@"weekSat",@"weekSun",@"hours",@"minutes"];
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
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_warn (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
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
        NSArray *integerKeyArray = @[@"wid",@"type",@"repeats",@"weekMon",@"weekTue",@"weekWed",@"weekThu",@"weekFir",@"weekSat",@"weekSun",@"hours",@"minutes"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"wid"]) {
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
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_warn set %@ WHERE wid=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    DLog(@"%@",sql);
    if (completion) {
        completion(sql, finalValues);
    }
    
}
@end
