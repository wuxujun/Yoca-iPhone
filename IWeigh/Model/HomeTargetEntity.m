//
//  HomeTargetEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/5/12.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HomeTargetEntity.h"

@implementation HomeTargetEntity
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.tid=[value intValue];
    }else if([key isEqualToString:@"type"]){
        self.type=[value intValue];
    }else if([key isEqualToString:@"title"]){
        self.title=value;
    }else if([key isEqualToString:@"aid"]){
        self.aid=[value intValue];
    }else if([key isEqualToString:@"state"]){
        self.state=[value intValue];
    }else if([key isEqualToString:@"sex"]){
        self.sex=[value intValue];
    }else if([key isEqualToString:@"height"]){
        self.height=[value intValue];
    }else if([key isEqualToString:@"value"]){
        self.value=value;
    }else if([key isEqualToString:@"valueTitle"]){
        self.valueTitle=value;
    }else if([key isEqualToString:@"progres"]){
        self.progres=value;
    }else if([key isEqualToString:@"unit"]){
        self.unit=value;
    }else if([key isEqualToString:@"isShow"]){
        self.isShow=[value intValue];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(NSString*)tableName
{
    return @"t_home_target";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"type",@"title",@"aid",@"state",@"unit",@"sex",@"height",@"value",@"valutTitle",@"progres,isShow", nil];
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
        NSArray *integerKeyArray = @[@"id",@"type", @"state",@"aid",@"sex",@"height",@"isShow"];
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
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_home_target (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
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
        NSArray *integerKeyArray = @[@"id",@"type",@"state",@"aid",@"sex",@"height",@"isShow"];
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
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_home_target set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    if (completion) {
        completion(sql, finalValues);
    }
    
}
@end
