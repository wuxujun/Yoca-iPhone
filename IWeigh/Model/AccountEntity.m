//
//  AccountEntity.m
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "AccountEntity.h"


@implementation AccountEntity

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.aid=[value longLongValue];
    }else if([key isEqualToString:@"type"]){
        self.type=[value intValue];
    }else if([key isEqualToString:@"userNick"]){
        self.userNick=value;
    }else if([key isEqualToString:@"sex"]){
        self.sex=[value intValue];
    }else if([key isEqualToString:@"birthday"]){
        self.birthday=value;
    }else if([key isEqualToString:@"height"]){
        self.height=[value intValue];
    }else if([key isEqualToString:@"age"]){
        self.age=[value intValue];
    }else if([key isEqualToString:@"avatar"]){
        self.avatar=value;
    }else if([key isEqualToString:@"targetType"]){
        self.targetType=[value intValue];
    }else if([key isEqualToString:@"targetWeight"]){
        self.targetWeight=value;
    }else if([key isEqualToString:@"targetFat"]){
        self.targetFat=value;
    }else if([key isEqualToString:@"doneTime"]){
        self.doneTime=value;
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
    }else if([key isEqualToString:@"bmr"]){
        self.bmr=value;
    }else if([key isEqualToString:@"bodyAge"]){
        self.bodyAge=value;
    }else if([key isEqualToString:@"muscle"]){
        self.muscle=value;
    }else if([key isEqualToString:@"bone"]){
        self.bone=value;
    }else if([key isEqualToString:@"bmi"]){
        self.bmi=value;
    }else if([key isEqualToString:@"protein"]){
        self.protein=value;
    }
    else if([key isEqualToString:@"isSync"]){
        self.isSync=[value intValue];
    }
    else if([key isEqualToString:@"status"]){
        self.status=[value intValue];
    }
    else if([key isEqualToString:@"addtime"]){
        self.addtime=[value intValue];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"undefined Key: %@",key);
}

+(NSString*)tableName
{
    return @"t_account";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"type",@"userNick",@"sex",@"birthday",@"height",@"age",@"avatar",@"targetType",@"targetWeight",@"targetFat",@"doneTime",@"isSync",@"status",@"addtime", nil];
}

+ (void)generateInsertSql:(NSDictionary *)aInfo completion:(SqlBlock)completion
{
    NSMutableArray *finalKeys = [NSMutableArray array];
    NSMutableArray *finalValues = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];
    
    NSArray *keys = [aInfo allKeys];
    NSArray *values = [aInfo allValues];
    for (int i=0; i<values.count; i++) {
        NSString *value = values[i];
        NSString *key = keys[i];
//        DLog(@"%@:%@",key,value);
        if ([key isEqualToString:@"id"]) {
            [finalKeys addObject:key];
            [finalValues addObject:@([value longLongValue])];
            [placeholder addObject:@"?"];
        }else{
            NSArray *integerKeyArray = @[@"type", @"sex",@"height",@"age",@"targetType",@"isSync",@"status"];
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
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_account (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
//    DLog(@"%@",sql);
    if (completion) {
        completion(sql, finalValues);
    }
}

+ (void)generateUpdateSql:(NSDictionary *)aInfo completion:(SqlBlock)completion
{
    NSArray *keys = [aInfo allKeys];
    NSArray *values = [aInfo allValues];
    
    NSMutableArray *kvPairs = [NSMutableArray array];
    NSMutableArray *finalValues = [NSMutableArray array];
    
    NSNumber *mID = nil;
    for (int i=0; i<values.count; i++) {
        NSString *value = values[i];
        NSString *key = keys[i];
        if ([key isEqualToString:@"id"]) {
            mID=@([value longLongValue]);
        }else{
            NSArray *integerKeyArray = @[@"type", @"sex",@"height",@"age",@"targetType",@"isSync",@"status"];
            if ([integerKeyArray containsObject:key]) {
                [finalValues addObject:@([value integerValue])];
                [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
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
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_account set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
//    DLog(@"%@",sql);
    if (completion) {
        completion(sql, finalValues);
    }
}

@end
