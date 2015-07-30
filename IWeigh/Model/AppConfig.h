//
//  AppConfig.h
//  Electrical
//
//  Created by xujun wu on 13-7-7.
//  Copyright (c) 2013年 xujun wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

@property BOOL  isLogin;

@property BOOL  isNetworkRunning;

-(NSString*)getTrafficUser;

-(NSString*)getDataVersion;
-(void)setDataVersion:(NSString*)date;
-(NSString*)getIMEI;
-(NSString*)getServiceName;
-(NSString*)getServiceRoot;
-(NSString*)getWeiboShareUrl;

-(NSString*)getShareContent;
-(NSString*)getShareTitle;
-(NSString*)getShareUrl;

-(NSString*)getDownPath;
-(void)setPrefValue:(NSString*)aValue key:(NSString*)aKey;
-(NSString*)getPrefValue:(NSString*)aKey;
-(BOOL)getPrefNotify:(NSString*)aKey;

-(NSString*)getMessageCount;
-(void)setMessageCount:(int)count;

-(void)saveUserInfo:(NSString*)userName pwd:(NSString*)password;
-(NSString*)getUserName;

-(NSString*)getPassword;

-(void)saveMemberInfo:(NSDictionary*)infoDict;

-(NSDictionary*)getMemberInfo;

-(void)saveUserID:(int)uid;
-(int)getUID;

-(void)saveCookie:(BOOL)login;
-(BOOL)isCookie;
-(void)removePrefValue:(NSString*)aKey;

+(AppConfig*)getInstance;
+(id)allocWithZone:(NSZone *)zone;

@end
