//
//  HCurrentUserContext.h
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetworkEngine.h"

#define kSaveMyInfoSuccess @"kSaveMyInfoSuccess"

typedef enum {
    HFavoriteTypeCategory = 1,
    HFavoriteTypePost = 2
} HFavoriteType;

@interface HCurrentUserContext : NSObject

@property(nonatomic, strong) NSString   *uid;
@property(nonatomic, strong) NSString   *username;
@property(nonatomic, strong) NSString   *password;
@property(nonatomic, assign) BOOL       isReport;
@property(nonatomic, strong) NSString   *reportArea;
@property(nonatomic, strong) NSString   *imageUrl;
@property(nonatomic, strong) NSString   *email;
@property(nonatomic, strong) NSString   *phone;
@property(nonatomic, strong) NSString   *remark;
@property(nonatomic, strong) HNetworkEngine *networkEngine;

@property(nonatomic, strong) NSMutableArray *favoriteIds;

+(HCurrentUserContext *)sharedInstance;

-(BOOL)hadLogin;

//登录
-(void)loginWithUserName:(NSString *)username password:(NSString *)password success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock;

//注册
-(void)registerWithUserName:(NSString *)username password:(NSString *)password email:(NSString *)email success:(HBOOLBlock)successBlock error:(MKNKErrorBlock)errorBlock;

//找回密码
-(void)getPassworkWithUsername:(NSString *)username email:(NSString *)email success:(HBOOLBlock)successBlock error:(MKNKErrorBlock)errorBlock;

//信息编辑
-(void)editUserDetailWithImage:(NSString *)imagePath email:(NSString *)email phone:(NSString *)phone remark:(NSString *)remark password:(NSString *)password success:(HBOOLBlock)successBlock error:(MKNKErrorBlock)errorBlock;

//同步第三方登录
-(void)sysUserWithUserType:(NSUInteger)userType userId:(NSString *)userId nickname:(NSString *)nickname iconUrl:(NSString *)iconUrl success:(HDictionaryBlock)successBlock error:(MKNKErrorBlock)errorBlock;

//获取收藏
-(void)syncFavoriteWithObjectType:(HFavoriteType)objectType pageIndex:(NSUInteger)pageIndex success:(void(^)(NSArray *array,NSUInteger count))successBlock error:(MKNKErrorBlock)errorBlock;

//收藏、取消收藏帖子
-(void)syncFavoriteBBSCategoryWithPostId:(NSString *)postId state:(NSUInteger)state success:(void(^)(NSString *favid,BOOL success))successBlock error:(MKNKErrorBlock)errorBlock;

-(void)clearUserInfo;


@end
