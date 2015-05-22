//
//  HCurrentUserContext.m
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HCurrentUserContext.h"
#import "UserDefaultHelper.h"

#define UserNameUserDefaultKey          @"user_username"
#define PasswordUserDefaultKey          @"user_password"
#define UserIDUserDefaultKey            @"user_usid"
#define EmailUserDefaultKey             @"user_email"
#define PhoneUserDefaultKey             @"user_phone"
#define RemarkUserDefaultKey            @"user_remark"
#define IconUrlIDUserDefaultKey         @"user_iconUrl"
#define ReportUsableIDUserDefaultKey    @"user_isReport"
#define ReportAreaUserDefaultKey        @"user_reportArea"

@interface HCurrentUserContext ()

@end

@implementation HCurrentUserContext

@synthesize username=_username;
@synthesize password=_password;
@synthesize uid=_uid;
@synthesize email=_email;
@synthesize phone=_phone;
@synthesize remark=_remark;
@synthesize imageUrl=_imageUrl;
@synthesize isReport=_isReport;
@synthesize reportArea=_reportArea;

static HCurrentUserContext *sharedHCurrentUserContext = nil;

+(HCurrentUserContext *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHCurrentUserContext = [[self alloc] init];
    });
    return sharedHCurrentUserContext;
}

- (void)instanceDidCreated{
    self.favoriteIds = [@[] mutableCopy];
}

-(HNetworkEngine *)networkEngine{
    if (_networkEngine == nil) {
        _networkEngine = [[HNetworkEngine alloc] initWithHostName:nil customHeaderFields:nil];
    }
    return _networkEngine;
}

-(BOOL)hadLogin{
    return self.uid.length > 0 && self.username.length > 0;
}

-(void)loginWithUserName:(NSString *)username password:(NSString *)password success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    NSMutableDictionary *params = [@{@"username":username,@"password":[password md5]} mutableCopy];
    __unsafe_unretained HCurrentUserContext *myself = self;
    NSString *url = [NSString stringWithFormat:@"%@login",kHttpUrl];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            NSDictionary *userDict = resultDict[@"data"];
            myself.uid = userDict[@"id"];
            myself.username = userDict[@"mobile"];
            myself.isReport = [userDict[@"isReport"] boolValue];
            myself.reportArea = userDict[@"reportArea"];
            myself.imageUrl = userDict[@"image"];
            successBlock(completedOperation,result);
        } else {
            NSString *message = [result objectForKey:@"errorMsg"] ? : @"登录发生错误";
            NSError *error = [NSError errorWithDomain:message code:-1 userInfo:nil];
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void)registerWithUserName:(NSString *)username password:(NSString *)password  email:(NSString *)email success:(HBOOLBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    NSMutableDictionary *params = [@{@"username":username,@"password":[password md5],@"email":email} mutableCopy];
    NSString *url = [NSString stringWithFormat:@"%@register",kHttpUrl];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            successBlock(isSuccess);
        } else {
            NSString *message = [result objectForKey:@"errorMsg"] ? : @"注册发生错误";
            NSError *error = [NSError errorWithDomain:message code:-1 userInfo:nil];
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void)getPassworkWithUsername:(NSString *)username email:(NSString *)email success:(HBOOLBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    NSMutableDictionary *params = [@{@"username":username,@"email":email} mutableCopy];
    NSString *url = [NSString stringWithFormat:@"%@getPassword",kHttpUrl];
    [self.networkEngine postOperationWithURLString:url params:params  success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            //获取密码
            successBlock(isSuccess);
        } else {
            NSString *message = [result objectForKey:@"errorMsg"] ? : @"获取密码错误";
            NSError *error = [NSError errorWithDomain:message code:-1 userInfo:nil];
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void)editUserDetailWithImage:(NSString *)imagePath email:(NSString *)email phone:(NSString *)phone remark:(NSString *)remark password:(NSString *)password success:(HBOOLBlock)successBlock error:(MKNKErrorBlock)errorBlock
{
    
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"email"] = email.length > 0 ? email : @"";
    params[@"phone"] = phone.length > 0 ? phone : @"";
    params[@"remark"] = remark.length > 0 ? remark : @"";
    params[@"password"] = password.length > 0 ? [password md5] : [@"" md5];
    params[@"imagecount"] = imagePath.length > 0 ? @"1" : @"0";
    params[@"address"] =  @"杭州市";
    
    NSString *url = [NSString stringWithFormat:@"%@userEdit",kHttpUrl];
    MKNetworkOperation *operation = [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            successBlock(YES);
        } else {
            NSString *message = [result objectForKey:@"errorMsg"] ? : @"保存信息发生错误";
            NSError *error = [NSError errorWithDomain:message code:-1 userInfo:nil];
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
    if (imagePath.length > 0) {
        [operation addFile:imagePath forKey:@"image_0" mimeType:@"image/jpeg"];
    }
}

-(void)sysUserWithUserType:(NSUInteger)userType userId:(NSString *)userId nickname:(NSString *)nickname iconUrl:(NSString *)iconUrl success:(HDictionaryBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    NSMutableDictionary *params = [@{@"userType":[NSString stringWithFormat:@"%d",userType],@"userId":userId,@"nickname":nickname,@"image":iconUrl} mutableCopy];
    NSString *url = [NSString stringWithFormat:@"%@userSync",kHttpUrl];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            successBlock(resultDict[@"root"]);
        } else {
            NSString *message = [result objectForKey:@"errorMsg"] ? : @"发生错误";
            NSError *error = [NSError errorWithDomain:message code:-1 userInfo:nil];
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void)syncFavoriteWithObjectType:(HFavoriteType)objectType pageIndex:(NSUInteger)pageIndex success:(void(^)(NSArray *array,NSUInteger count))successBlock error:(MKNKErrorBlock)errorBlock{
    NSMutableDictionary *params = [@{@"objectType":[NSString stringWithFormat:@"%d",objectType],@"pageIndex":[NSString stringWithFormat:@"%lu",(unsigned long)pageIndex],@"pageSize": @"20"} mutableCopy];
    NSString *url = [NSString stringWithFormat:@"%@favorites",kHttpUrl];
    __weak HCurrentUserContext *myself = self;
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            NSUInteger totalCount = [resultDict[@"total"] integerValue];
            NSArray *favorites = resultDict[@"root"];
            NSMutableArray *favoriteList = [@[] mutableCopy];
//            if (![favorites isKindOfClass:[NSNull class]]) {
//                [favorites enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                    if (objectType == DXYFavoriteTypeCategory) {
//                        DXYBBSCategory *bbsCategory = [[DXYBBSCategory alloc] init];
//                        [bbsCategory setValuesForKeysWithDictionary:obj];
//                        [favoriteList addObject:bbsCategory];
//                    } else {
//                        DXYBBSPost *bbsPost = [[DXYBBSPost alloc] init];
//                        [bbsPost setValuesForKeysWithDictionary:obj];
//                        [favoriteList addObject:bbsPost];
//                        [myself.favoriteIds addObject:bbsPost.postId];
//                    }
//                }];
//                successBlock(favoriteList,totalCount);
//            } else {
//                successBlock(nil,0);
//            }
        } else {
            NSError *error = [NSError errorWithDomain:@"获取资讯发生错误。" code:-1 userInfo:nil];
            errorBlock(error);
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
    
}

-(void)syncFavoriteBBSCategoryWithPostId:(NSString *)postId state:(NSUInteger)state success:(void(^)(NSString *favid,BOOL success))successBlock error:(MKNKErrorBlock)errorBlock{
    NSMutableDictionary *params = [@{@"favid":postId,@"state":[NSString stringWithFormat:@"%d",state],@"objectType":@"2",@"pageSize":@"10000"} mutableCopy];
    NSString *url = [NSString stringWithFormat:@"%@addFavorite",kHttpUrl];
    __weak HCurrentUserContext *myself = self;
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary *resultDict = result;
        BOOL isSuccess = [resultDict[@"success"] boolValue];
        if (isSuccess) {
            if (state == 3) {
                [myself.favoriteIds removeObject:postId];
                successBlock(nil,isSuccess);
            } else {
                [myself.favoriteIds addObject:postId];
                NSDictionary *dataDict = resultDict[@"data"];
                NSString *favoriteId = postId;
                if (![dataDict isKindOfClass:[NSNull class]]) {
                    favoriteId = dataDict[@"favid"];
                }
                successBlock(favoriteId,isSuccess);
            }
        } else {
            NSError *error = [NSError errorWithDomain:resultDict[@"errorMsg"]?resultDict[@"errorMsg"]:@"同步收藏帖子失败！" code:-1 userInfo:nil];
            errorBlock(error);
        }
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void)setUsername:(NSString *)username{
    _username = username;
    [UserDefaultHelper setObject:_username forKey:UserNameUserDefaultKey];
}
-(NSString *)username{
    return _username? : [UserDefaultHelper objectForKey:UserNameUserDefaultKey];
}

-(void)setPassword:(NSString *)password{
    _password = password;
    [UserDefaultHelper setObject:_password forKey:PasswordUserDefaultKey];
}
-(NSString *)password{
    return _password? : [UserDefaultHelper objectForKey:PasswordUserDefaultKey];
}

-(void)setUid:(NSString *)uid{
    _uid = uid;
    [UserDefaultHelper setObject:_uid forKey:UserIDUserDefaultKey];
}
-(NSString *)uid{
    return _uid? : [UserDefaultHelper objectForKey:UserIDUserDefaultKey];
}

-(void)setEmail:(NSString *)email{
    _email = email;
    [UserDefaultHelper setObject:_email forKey:EmailUserDefaultKey];
}

-(NSString *)email{
    return _email ? : [UserDefaultHelper objectForKey:EmailUserDefaultKey];
}

-(void)setPhone:(NSString *)phone{
    _phone = phone;
    [UserDefaultHelper setObject:_phone forKey:PhoneUserDefaultKey];
}

-(NSString *)phone{
    return _phone ? : [UserDefaultHelper objectForKey:PhoneUserDefaultKey];
}

-(void)setRemark:(NSString *)remark{
    _remark = remark;
    [UserDefaultHelper setObject:_remark forKey:RemarkUserDefaultKey];
}

-(NSString *)remark{
    return _remark? :[UserDefaultHelper objectForKey:RemarkUserDefaultKey];
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [UserDefaultHelper setObject:_imageUrl forKey:IconUrlIDUserDefaultKey];
}

-(NSString *)imageUrl{
    return _imageUrl ? : [UserDefaultHelper objectForKey:IconUrlIDUserDefaultKey];
}

-(void)setIsReport:(BOOL)isReport{
    _isReport = isReport;
    [UserDefaultHelper setObject:@(isReport) forKey:ReportUsableIDUserDefaultKey];
}

-(BOOL)isReport{
    return _isReport ?:[[UserDefaultHelper objectForKey:ReportUsableIDUserDefaultKey] boolValue];
}

-(void)setReportArea:(NSString *)reportArea{
    _reportArea = reportArea;
    [UserDefaultHelper setObject:_reportArea forKey:ReportAreaUserDefaultKey];
}

-(NSString *)reportArea{
    return _reportArea ?:[UserDefaultHelper objectForKey:ReportAreaUserDefaultKey];
}

-(void)clearUserInfo{
    self.uid = nil;
    self.username = nil;
    self.password = nil;
    self.email = nil;
    self.phone = nil;
    self.remark = nil;
    self.imageUrl = nil;
    self.isReport = NO;
    self.reportArea = nil;
}

@end
