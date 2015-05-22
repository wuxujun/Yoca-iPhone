//
//  UserDefaultHelper.h
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultHelper : NSObject
+(void)setObject:(id)_object forKey:(NSString *)_key;
+(id)objectForKey:(NSString *)_key;
@end
