//
//  HNetworkOperation.m
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HNetworkOperation.h"
#import "HCurrentUserContext.h"
#import "NSString+MD5Addition.h"
#import "JSONKit.h"

@implementation HNetworkOperation
- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params
             httpMethod:(NSString *)method{
    
    
    if (params==nil) {
        params = [NSMutableDictionary dictionary];
    }
    [params setValue:DEVICE_UDID forKey:@"imei"];
    [params setValue:@"ios" forKey:@"platform"];
    HCurrentUserContext *currentUser = [HCurrentUserContext sharedInstance];
    if ([currentUser hadLogin]) {
        params[@"uid"] = currentUser.uid;
        params[@"username"] = [currentUser.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        params[@"uid"] = @(0);
    }
    
    
    
    NSMutableDictionary *jsonParams = [NSMutableDictionary dictionary];
#if TARGET_IPHONE_SIMULATOR
    NSError* error;
    NSData* jsonData=[NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString* str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonParams[@"content"]=str;
#else
//    jsonParams[@"content"] = [params JSONString];
    NSError* error;
    NSData* jsonData=[NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString* str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonParams[@"content"]=str;
#endif
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSString *key = [[NSString stringWithFormat:@"%@^QQACon!aid*$",time] stringFromMD5];
    
    NSRange range;
    range.location = 8;
    range.length = 16;
    key = [key substringWithRange:range];
    jsonParams[@"time"] = time;
    jsonParams[@"key"] = key;
    
    DLog(@"%@ -- %@",aURLString,jsonParams);
    return [super initWithURLString:aURLString params:jsonParams httpMethod:method];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkOperationFinishedNotification object:self];
    [super connection:connection didFailWithError:error];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkOperationFinishedNotification object:self];
    
    [super connectionDidFinishLoading:connection];
    
}
-(id) responseJSON{
    id json = [super responseJSON];
    if ([NSJSONSerialization class]) {
        return json;
    }else {
        return [((NSString *)json) objectFromJSONString];
    }
}

@end
