//
//  UserDefaultHelper.m
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "UserDefaultHelper.h"

@implementation UserDefaultHelper
static NSUserDefaults* userDefault;

+(void)initialize{
    userDefault = [NSUserDefaults standardUserDefaults];
}

+(void)setObject:(id)_object forKey:(NSString *)_key{
    [userDefault setObject:_object forKey:_key];
    [userDefault synchronize];
}
+(id)objectForKey:(NSString *)_key{
    return [userDefault objectForKey:_key];
}
@end
