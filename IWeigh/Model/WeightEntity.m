//
//  WeightEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "WeightEntity.h"

@implementation WeightEntity

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"wid"]) {
        self.wid=[value intValue];
    }else if ([key isEqualToString:@"aid"]) {
        self.aid=[value intValue];
    }else if([key isEqualToString:@"picktime"]){
        self.picktime=value;
    }else if([key isEqualToString:@"weight"]){
        self.weight=value;
    }else if([key isEqualToString:@"fat"]){
        self.fat=value;
    }else if([key isEqualToString:@"subFat"]){
        self.subFat=value;
    }else if([key isEqualToString:@"visFat"]){
        self.visFat=value;
    }else if([key isEqualToString:@"water"]){
        self.water=value;
    }else if([key isEqualToString:@"BMR"]){
        self.BMR=value;
    }else if([key isEqualToString:@"bodyAge"]){
        self.bodyAge=value;
    }else if([key isEqualToString:@"muscle"]){
        self.muscle=value;
    }
    else if([key isEqualToString:@"bone"]){
        self.bone=value;
    }
    else if([key isEqualToString:@"bmi"]){
        self.bmi=value;
    }
    else if([key isEqualToString:@"isSync"]){
        self.isSync=[value intValue];
    }
    else if([key isEqualToString:@"addtime"]){
        self.addtime=[value intValue];
    }else if([key isEqualToString:@"syncid"]){
        self.syncid=[value intValue];
    }
    else if([key isEqualToString:@"protein"]){
        self.protein=value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"undefined Key: %@",key);
}

+(NSString*)tableName
{
    return @"t_weight";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"wid",@"aid",@"picktime",@"weight",@"fat",@"subFat",@"visFat",@"water",@"BMR",@"bodyAge",@"muscle",@"bone",@"bmi",@"isSync",@"addtime",@"protein", nil];
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
         NSArray *integerKeyArray = @[@"wid",@"aid",@"syncid",@"isSync",@"weightTime"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"weightTime"]) {
                [finalKeys addObject:@"addtime"];
            }else{
                [finalKeys addObject:key];
            }
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
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_weight (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
    
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
         NSArray *integerKeyArray = @[@"wid",@"aid",@"syncid",@"isSync",@"weightTime"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"syncid"]) {
                mID = @([value integerValue]);
            }else{
                [finalValues addObject:@([value integerValue])];
                if ([key isEqualToString:@"weightTime"]) {
                    [kvPairs addObject:[NSString stringWithFormat:@"addtime=?"]];
                }else{
                    [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
                }
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
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_weight set %@ WHERE syncid=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    
    if (completion) {
        completion(sql, finalValues);
    }
    
}

@end
