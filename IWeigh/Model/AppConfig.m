//
//  AppConfig.m
//  Electrical
//
//  Created by xujun wu on 13-7-7.
//  Copyright (c) 2013年 xujun wu. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
@synthesize isLogin;
@synthesize isNetworkRunning;

-(void)setDataVersion:(NSString *)date
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"curDataVersion"];
    [settings setObject:date forKey:@"curDataVersion"];
    [settings synchronize];
}

-(NSString*)getDataVersion
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSString *date=[settings objectForKey:@"curDataVersion"];
    if (date) {
        return date;
    }
    return @"0";
}


-(NSString*)getServiceName
{
    return @"http://app.woicar.cn:8089/nadmin/index.php/ums";
}

-(NSString*)getServiceRoot
{
    return @"http://app.woicar.cn:8089/nadmin/";
}


-(NSString*)getWeiboShareUrl
{
    return @"http://service.weibo.com/share/share.php";
}

-(NSString*)getShareContent
{
    return @"专为用车人打造的《沃爱车》客户端,不仅提供一键救援、放心店打分等功能,更能提供积分奖励计划,电子优惠券等,让沃爱车会员的有车生活更精彩！";
}

-(NSString*)getShareTitle
{
    return @"推荐一款应用--沃爱车";
}

-(NSString*)getShareUrl
{
    return @"http://www.woicar.cn/woicarapp.html";
}

-(NSString*)getDownPath
{
    NSString *downPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return downPath;
}

-(NSString*)getIMEI
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"imei"];
}

-(NSString*)getMessageCount
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"messageCount"];
}

-(void)setMessageCount:(int)count
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"messageCount"];
    [settings setObject:[NSString stringWithFormat:@"%d",count] forKey:@"messageCount"];
    [settings synchronize];
}

-(void)saveUserInfo:(NSString *)userName pwd:(NSString *)password
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"userName"];
    [settings removeObjectForKey:@"password"];
    [settings setObject:userName forKey:@"userName"];
    
    [settings setObject:password forKey:@"password"];
    [settings synchronize];
}

-(NSString*)getUserName
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"userName"];
}

-(NSString*)getPassword
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"password"];
}

-(void)saveUserID:(int)uid
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UID"];
    [settings setObject:[NSString stringWithFormat:@"%d",uid] forKey:@"UID"];
    [settings synchronize];
}

-(void)saveMemberInfo:(NSDictionary *)infoDict
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"MemberInfo"];
    [settings setObject:infoDict forKey:@"MemberInfo"];
    [settings synchronize];
}

-(NSDictionary*)getMemberInfo
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"MemberInfo"];
}

-(int)getUID
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSString   *value=[settings objectForKey:@"UID"];
    if (value&&[value isEqualToString:@""]==NO) {
        return [value intValue];
    }else{
        return 0;
    }
}

-(void)saveCookie:(BOOL)login
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"cookie"];
    [settings setObject:login?@"1":@"0" forKey:@"cookie"];
    [settings synchronize];
}

-(BOOL)isCookie
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSString *value=[settings objectForKey:@"cookie"];
    if (value&&[value isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)setPrefValue:(NSString *)aValue key:(NSString *)aKey
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:aKey];
    [settings setObject:aValue forKey:aKey];
    [settings synchronize];
}

-(NSString*)getPrefValue:(NSString*)aKey
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSString *value=[settings objectForKey:aKey];
    if (value) {
        return value;
    }
    return @"0";
}

-(BOOL)getPrefNotify:(NSString *)aKey
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSString *value=[settings objectForKey:aKey];
    if (value&&[value isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)removePrefValue:(NSString *)aKey
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:aKey];
    [settings synchronize];
}

-(NSString*)getTrafficUser
{
    return @"LTWACJLB20140821";
}

static AppConfig *instance=nil;
+(AppConfig*)getInstance
{
    @synchronized(self){
        if (nil==instance) {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance==nil) {
            instance=[super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

@end
