//
//  AppDelegate.m
//  IWeigh
//
//  Created by xujunwu on 14-8-30.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "INavigationController.h"
#import "IMenuViewController.h"
#import "IHomeViewController.h"
#import "IIntruduceViewController.h"
#import "IStartViewController.h"
#import "AccountEntity.h"
#import "IAccountDViewController.h"
#import "MobClick.h"
#import "DBHelper.h"
#import "AppConfig.h"
#import "DBManager.h"
#import "PathHelper.h"
#import "UserDefaultHelper.h"
#import "HCurrentUserContext.h"

#import "IInfoPagesViewController.h"
#import "CRNavigationController.h"

#import <UMSocial.h>
#import <UMSocialSnsService.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaHandler.h>

#import <GoogleAnalytics/GAIFields.h>
#import <GoogleAnalytics/GAITracker.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

#define PUSHTYPE @"type"
#define PUSHTYPENEWS @"1"
#define PUSHTYPEPRIVNOTICE @"2"
#define PUSHTYPEDATAUPDATE @"3"
#define PUSHOBJECTID @"id"
#define PUSHOBJECTIITLE @"title"
#define PUSHOBJECTIIME @"sendtime"

#define PUSHPRIVNOTICEFROMID @"formuid"
#define PUSHPRIVNOTICEFNICKNAME @"nickname"

static NSString *const kTrackingId=@"UA-30968675-6";
static NSString *const kAllowTracking=@"allowTracking";


@implementation AppDelegate

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    AppDelegate *myDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (ScreenHeight>480) {
        myDelegate.autoSizeScaleX=ScreenWidth/320;
        myDelegate.autoSizeScaleY=ScreenHeight/568;
    }else{
        myDelegate.autoSizeScaleX=1.0;
        myDelegate.autoSizeScaleY=1.0;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *appDefault=@{kAllowTracking:@(YES)};
    [[NSUserDefaults standardUserDefaults]registerDefaults:appDefault];
    [GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [GAI sharedInstance].dispatchInterval=20;
    //    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].trackUncaughtExceptions=YES;
    self.tracker=[[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Yoca"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createScreenView]build]];
    
#if TARGET_IPHONE_SIMULATOR
    DLog(@" TARGET_IPHONE_SIMULATOR is not support Notification ");
#else

    if (IOS_VERSION_8_OR_ABOVE) {
        DLog(@"registerForPushNotification: For iOS >= 8.0");
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeBadge|UIUserNotificationTypeAlert) categories:nil]];
            [application registerForRemoteNotifications];
        }
    }else{
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
#endif
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [DBHelper initDatabase];
    {
        [DBHelper addColumnToTable:@"t_home_target" ColumnName:@"isShow"];
    }
    
    [SMS_SDK registerApp:@"6de96e7d9e78" withSecret:@"ee6510b139aa06a0a403dd4410646bef"];
    [UMSocialData setAppKey:@"52649a7e56240b87b6169d13"];
    
    [self initializePlat];
    
    [NSThread sleepForTimeInterval:2.0];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ic_nav"] forBarMetrics:UIBarMetricsDefault];
    UIColor* navigationTextColor=APP_FONT_COLOR_SEL;
    self.window.tintColor=navigationTextColor;
    
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    IStartViewController* homeView=[[IStartViewController alloc]init];
//    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:homeView];
    [self.window setRootViewController:homeView];
    [self.window makeKeyAndVisible];
    
    return YES;
}

+(void)storyBoradAutoLay:(UIView*)allView
{
    for (UIView* temp in allView.subviews) {
        temp.frame=CGRectMake1(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        for (UIView* temp1 in temp.subviews) {
            temp1.frame=CGRectMake1(temp1.frame.origin.x, temp1.frame.origin.y, temp1.frame.size.width, temp1.frame.size.height);
        }
    }
}

//修改CGRectMake
CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX; rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX; rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}


-(void)initializePlat
{
    [UMSocialWechatHandler setWXAppId:APPKEY_WEIXIN appSecret:APPKEY_WEIXIN_SECRET url:@"https://app.sholai.cn/"];
    [UMSocialQQHandler setQQWithAppId:APPKEY_QQ appKey:APPKEY_QQ_SECRET url:@"http://www.umeng.com/social"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    int buildVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey] intValue];
    DLog(@"%d",buildVersion);
    NSInteger   isInit=[[UserDefaultHelper objectForKey:CONFIG_INIT_FLAG] integerValue];
    if (![UserDefaultHelper objectForKey:CONF_FIRST_START]) {
        [UserDefaultHelper setObject:[NSNumber numberWithBool:true] forKey:CONF_FIRST_START];
    }
    
    BOOL firstStart=[[UserDefaultHelper objectForKey:CONF_FIRST_START] boolValue];
    
    self.networkEngine =  [[HNetworkEngine alloc]initWithHostName:nil customHeaderFields:nil];
    NSString *url = [NSString stringWithFormat:@"%@getConfig",kHttpUrl];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"config",@"type", nil]];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
//        DLog(@"%@",rs);
        id array=[rs objectForKey:@"configs"];
        int sVersion=[[rs objectForKey:@"version"] intValue];
        if ([array isKindOfClass:[NSArray class]]) {
            if ((isInit==1&&sVersion>buildVersion)||isInit==0) {
                for (int i=0; i<[array count]; i++) {
                    if ([[DBManager getInstance] insertOrUpdateConfig:[array objectAtIndex:i]]) {
//                        DLog(@"Config insert or update success %d",i);
                    }
                }
                [UserDefaultHelper setObject:@"1" forKey:CONFIG_INIT_FLAG];
            }
        }
        
        id array1=[rs objectForKey:@"targetList"];
        if ([array1 isKindOfClass:[NSArray class]]) {
            if (sVersion>buildVersion||isInit==0) {
                for (int i=0; i<[array1 count]; i++) {
                    if ([[DBManager getInstance] insertOrUpdateTargetInfo:[array1 objectAtIndex:i]]) {
//                        DLog(@"TargetInfo insert or update success %d",i);
                    }
                }
            }
        }
        
        if (firstStart) {
            [ApplicationDelegate openIntruduceView];
        }else{
            if ([[HCurrentUserContext sharedInstance] uid]) {
                DLog(@"%@",[[HCurrentUserContext sharedInstance] uid]);
//              [ApplicationDelegate openMainView];
                [ApplicationDelegate openTabMainView];
            }else{
                [ApplicationDelegate openHomeView];
            }
        }
        
    } error:^(NSError *error) {
        
    }];
}

-(void)openIntruduceView
{
    for (UIView* view in self.window.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    IIntruduceViewController* homeView=[[IIntruduceViewController alloc]init];
    [self.window setRootViewController:homeView];
    [self.window makeKeyAndVisible];
}

-(void)openHomeView
{
    for (UIView* view in self.window.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    IHomeViewController* homeView=[[IHomeViewController alloc]init];
    
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:homeView];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
//    self.window.tintColor=[UIColor whiteColor];
}

-(void)openMainView
{
    for (UIView* view in self.window.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    [BluetoothLEManager sharedManagerWithDelegate:self];
    [self syncWeight];
    INavigationController* navController;
    HomeViewController* dController=[[HomeViewController alloc]init];
    NSArray* array=[[DBManager getInstance] queryAccountForType:1];
    if ([array count]>0) {
        AccountEntity* entity=[array objectAtIndex:0];
        if (entity!=NULL) {
            [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",entity.aid],@"dataIndex",entity.userNick,@"title", nil]];
        }
    }
    navController=[[INavigationController alloc]initWithRootViewController:dController];
    IMenuViewController* menuController=[[IMenuViewController alloc]initWithStyle:UITableViewStyleGrouped];
    REFrostedViewController* frostedViewController=[[REFrostedViewController alloc]initWithContentViewController:navController menuViewController:menuController];
    frostedViewController.direction=REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle=REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur=YES;
    frostedViewController.delegate=self;
    
    self.window.rootViewController=frostedViewController;
    self.window.backgroundColor=[UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
}

-(void)openTabMainView
{
    for (UIView* view in self.window.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    [BluetoothLEManager sharedManagerWithDelegate:self];
    [self syncWeight];
    self.viewController=[[CustomTabBarViewController alloc] init];
    
    [self.viewController.tabBar setBarStyle:UIBarStyleBlack];
    self.window.rootViewController=self.viewController;
    [self.window makeKeyAndVisible];
    UIColor* navigationTextColor=APP_FONT_COLOR_SEL;
    self.window.tintColor=navigationTextColor;
}

-(void)syncWeight
{
    NSString *url = [NSString stringWithFormat:@"%@getWeights",kHttpUrl];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"syncid", nil]];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateWeight:[array objectAtIndex:i]]) {
                }
            }
            
        }
    } error:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@getWeightHiss",kHttpUrl] params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateWeightHis:[array objectAtIndex:i]]) {
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_DATA_REFRESH object:nil];
        }
    } error:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
}

-(void)onSyncAccount:(NSNotification*)notification
{
    NSDictionary* dict=(NSDictionary*)notification.object;
    if ([dict objectForKey:@"id"]) {
        NSArray* array=[[DBManager getInstance] queryAccountForID:[[dict objectForKey:@"id"] longLongValue]];
        if ([array count]>0) {
            AccountEntity *account=[array objectAtIndex:0];
            NSString *url = [NSString stringWithFormat:@"%@syncaccount",kHttpUrl];
            NSMutableDictionary* params=[[NSMutableDictionary alloc]init ];
            [params setObject:[NSString stringWithFormat:@"%ld",account.aid] forKey:@"id"];
            [params setObject:[NSString stringWithFormat:@"%ld",account.type] forKey:@"type"];
            [params setObject:account.userNick forKey:@"userNick"];
            [params setObject:[NSString stringWithFormat:@"%ld",account.sex] forKey:@"sex"];
            [params setObject:account.birthday forKey:@"birthday"];
            [params setObject:[NSString stringWithFormat:@"%ld",account.height] forKey:@"height"];
            [params setObject:[NSString stringWithFormat:@"%ld",account.age] forKey:@"age"];
            if (account.avatar) {
                [params setObject:account.avatar forKey:@"avatar"];
            }else{
                [params setObject:@"" forKey:@"avatar"];
            }
            if(account.targetType>0){
                [params setObject:[NSString stringWithFormat:@"%ld",account.targetType] forKey:@"targetType"];
            }else{
                [params setObject:@"0" forKey:@"targetType"];
            }
            if (account.targetWeight) {
                [params setObject:account.targetWeight forKey:@"targetWeight"];
            }else{
                [params setObject:@"0" forKey:@"targetWeight"];
            }
            [params setObject:@"0" forKey:@"targetFat"];
            if (account.doneTime) {
                [params setObject:account.doneTime forKey:@"doneTime"];
            }else{
                [params setObject:@"20151231" forKey:@"doneTime"];
            }
            
            NSMutableDictionary* root=[[NSMutableDictionary alloc]init];
            [root setObject:[NSArray arrayWithObjects:params, nil] forKey:@"root"];
            
           [self.networkEngine postOperationWithURLString:url params:root success:^(MKNetworkOperation *completedOperation, id result) {
//               DLog(@"%@",result);
            } error:^(NSError *error) {
                DLog(@"%@",error);
            }];
            
            [[DBManager getInstance] updateAccountStatus:account.aid];
        }
    }
}

-(void)onSyncWeight:(NSNotification*)notification
{
    NSDictionary* dict=(NSDictionary*)notification.object;
    if ([dict objectForKey:@"wid"]) {
        NSString *url = [NSString stringWithFormat:@"%@%@",kHttpUrl,[dict objectForKey:@"requestUrl"]];
        NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:dict];
        NSMutableDictionary* root=[[NSMutableDictionary alloc]init];
            [root setObject:[NSArray arrayWithObjects:params, nil] forKey:@"root"];
            
        [self.networkEngine postOperationWithURLString:url params:root success:^(MKNetworkOperation *completedOperation, id result) {
//            DLog(@"%@",result);
        } error:^(NSError *error) {
            DLog(@"%@",error);
        }];
        if ([[dict objectForKey:@"requestUrl"] isEqualToString:@"syncweighthis"]) {
            [[DBManager getInstance] updateWeightHisStatus:[[dict objectForKey:@"wid"] integerValue]];
        }else{
            [[DBManager getInstance] updateWeightStatus:[[dict objectForKey:@"wid"] integerValue]];
        }
    }
}

-(void)onUploadFile:(NSNotification*)notification
{
    NSDictionary* dict=(NSDictionary*)notification.object;
    if ([dict objectForKey:@"type"]) {
        DLog(@"%@",[dict objectForKey:@"fileName"]);
    
    }else{
        NSString *url = [NSString stringWithFormat:@"%@upImage",kHttpUrl];
        NSMutableDictionary* params=[[NSMutableDictionary alloc]init ];
        NSMutableDictionary* dic=[[NSMutableDictionary alloc ]init ];
        [dic setObject:@"0" forKey:@"type"];
        [dic setObject:[dict objectForKey:@"id"] forKey:@"aid"];
        [dic setObject:@"0" forKey:@"wid"];
        NSMutableDictionary* imgs=[[NSMutableDictionary alloc]init];
        [imgs setObject:[PathHelper filePathInDocument:[dict objectForKey:@"avatar"]] forKey:@"image"];
        [params setObject:[dict objectForKey:@"avatar"] forKey:@"image"];
        [dic setObject:imgs forKey:@"images"];
        [params setObject:dic forKey:@"content"];
        
//        DLog(@"%@",params);
        
        [self.networkEngine postDatasWithURLString:url datas:params process:^(double progress) {
        } success:^(MKNetworkOperation *completedOperation, id result) {
            DLog(@"%@",result);
        } error:^(NSError *error) {
            DLog(@"%@",error);
        }];
    }
    
}


-(void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
//    DLog(@"didRecognize");
}

-(void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
//    DLog(@"willShow");
}

-(void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
//    DLog(@"didShowMenu..")
}

-(void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
//    DLog(@"willHide");
}

-(void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
//    DLog(@"didHide...");
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    _bgTask=[application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [application endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    });
    
    application.applicationIconBadgeNumber=0;
    if (_bleReadTimer) {
        [_bleReadTimer invalidate];
        _bleReadTimer=nil;
    }
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Yoca" action:@"Close" label:@"Close Yoca" value:[NSNumber numberWithInt:2]] build]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOAD_AVATAR_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYNC_ACCOUNT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYNC_WEIGHT_NOTIFICATION object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber=0;
    
    if (_bgTask!=UIBackgroundTaskInvalid) {
        [application endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults]boolForKey:kAllowTracking];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Yoca" action:@"Open" label:@"Open Yoca" value:[NSNumber numberWithInt:1]] build]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadFile:) name:UPLOAD_AVATAR_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSyncAccount:) name:SYNC_ACCOUNT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSyncWeight:) name:SYNC_WEIGHT_NOTIFICATION object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    application.applicationIconBadgeNumber=0;
}

#ifdef __IPHONE_8_0
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]) {
        DLog(@"declineAction ..");
    }else if([identifier isEqualToString:@"answerAction"]){
        DLog(@"answerAction  ..");
    }
}
#endif

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //每次打开程序都会发送deviceToken,将device token转换为字符串
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@uuid",kHttpUrl];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:deviceTokenStr,@"uuid",@"0",@"status", nil]];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {

    } error:^(NSError *error) {
        DLog(@"post deviceToken fail");
    }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"%@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSString * type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:PUSHTYPE]];//非字符串类型 转成NSString
    if (application.applicationState != UIApplicationStateActive) {
        if([type isEqualToString:PUSHTYPENEWS]) {//判断是否是 资讯 类型
            NSDictionary *data = [userInfo objectForKey:@"data"];
            NSString * newsId = [NSString stringWithFormat:@"%@",[data objectForKey:PUSHOBJECTID]];
            NSString * title = [NSString stringWithFormat:@"%@",[data objectForKey:PUSHOBJECTIITLE]];
            NSString * time = [NSString stringWithFormat:@"%@",[data objectForKey:PUSHOBJECTIIME]];
            if(newsId.length>0 && title.length > 0)
            {
                //设置程序图标上的数字。当为0时 通知中心将会自动清空该程序的所有消息
                //                [self pushNewsDetailWithNewsId:newsId withTitle:title withTime:time];
            }
        } else if ([type isEqualToString:PUSHTYPEPRIVNOTICE]) {
            //私信
            NSDictionary *data = [userInfo objectForKey:@"data"];
            NSString * fromId = [NSString stringWithFormat:@"%@",[data objectForKey:PUSHPRIVNOTICEFROMID]];
            NSString * nickname = [NSString stringWithFormat:@"%@",[data objectForKey:PUSHPRIVNOTICEFNICKNAME]];
            if(fromId.length>0 && nickname.length > 0)
            {
                //设置程序图标上的数字。当为0时 通知中心将会自动清空该程序的所有消息
                //                [self pushPrivChatViewWithUid:fromId withNickname:nickname];
            }
        }else if([type isEqualToString:PUSHTYPEDATAUPDATE]) {
            //            [self updateData];
        }
    }else{
        if ([type isEqualToString:PUSHTYPEDATAUPDATE]) {
            //            [UIHelper showAlertViewWithMessage:@"有新的数据包，是否更新?" callback:^{
            //                [self updateData];
            //            }];
        }
    }
}



-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [UMSocialSnsService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}

+(AppDelegate*)getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark - BluetoothLEManagerDelegate
-(void)didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DLog(@"didConnectPeripheral %@ ",peripheral);
    for (CBService *s in peripheral.services) {
        DLog(@"Service found : %@",s.UUID);
    }
    
    self.peripheral=peripheral;
    self.bleService=[[BluetoothLEService alloc]initWithPeripheral:self.peripheral withServiceUUIDs:@[@"FFF0"] delegate:self];
    [self.bleService discoverServices];
}

-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
{
    DLog(@"%@  --->\n%@",peripheral,advertisementData);
    
    CBUUID *hUUID=[CBUUID UUIDWithString:@"FFF0"];
    NSArray *advertisementDatas=[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    for (CBUUID* uuid in advertisementDatas) {
        DLog(@"===>%@   %@",uuid,hUUID);
        if ([uuid isEqual:hUUID]) {
            [[BluetoothLEManager sharedManager] stopScanning];
            if (self.peripheral==nil) {
                self.peripheral=peripheral;
                DLog(@"%ld",(long)self.peripheral.state);
                if (iOS_VERSION_7) {
                    if ([self.peripheral state]==CBPeripheralStateConnected) {
                        DLog(@"Connected.");
                    }else{
                        [[BluetoothLEManager sharedManager] connectPeripheral:peripheral];
                        DLog(@"Connecting");
                    }

                }else{
                    //ios <7
                    if (self.peripheral.state==CBPeripheralStateConnected) {
                        DLog(@"Connected.");
                    }else{
                        [[BluetoothLEManager sharedManager] connectPeripheral:peripheral];
                        DLog(@"Connecting");
                    }
                }
                
            }
            break;
        }
    }
    
}

-(void)didChangeState:(CBCentralManagerState)newState
{
    DLog(@"%ld",(long)newState);
    if (newState==CBCentralManagerStatePoweredOn) {
        if (self.peripheral==nil) {
            [[BluetoothLEManager sharedManager]discoverDevices];
        }
    }else{
        self.peripheral=nil;
        self.bleService=nil;
    }
}

-(void)didUpdateValue:(BluetoothLEService *)service forServiceUUID:(CBUUID *)serviceUUID withCharacteristicUUID:(CBUUID *)characteristicUUID withData:(NSData *)data
{
    DLog(@"%@   %@    %@   %d",serviceUUID,characteristicUUID,data,[data length]);
    NSString* str=@"";
    if ([data length]==20) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BLEDATA_RECVICE object:data];
    }else{
        Byte *testByte = (Byte *)[data bytes];
        for(int i=0;i<[data length];i++){
            NSString* newHexStr=[NSString stringWithFormat:@"%x",testByte[i]&0xff];
            if ([newHexStr length]==0){
                str=[NSString stringWithFormat:@"%@0%@",str,newHexStr];
            }else{
                str=[NSString stringWithFormat:@"%@%@",str,newHexStr];
            }
        }
        DLog(@"%@",str);
    }
}

-(void)didDiscoverCharacterisics:(BluetoothLEService *)service
{
    DLog(@"%@",service);
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDATA_RECVICE_STATUS object:[NSDictionary dictionaryWithObjectsAndKeys:@"已连接",@"status", nil]];
    char data=0x01;
    NSData* d=[[NSData alloc]initWithBytes:&data length:1];
    if (self.bleService) {
//        [self.bleService setValue:d forServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF2" resp:false];
//        if (_bleReadTimer==nil) {
//            _bleReadTimer=[NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(readBLEData) userInfo:nil repeats:YES];
//        }
        [self.bleService startNotifyingForServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF1"];
    }
}

-(void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DLog(@"didDisconnectPeripheral %@  \r\n %@",peripheral,error);
    [[BluetoothLEManager sharedManager] disconnectPeripheral:peripheral];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEDATA_RECVICE_STATUS object:[NSDictionary dictionaryWithObjectsAndKeys:@"未连接",@"status", nil]];
    self.peripheral=nil;
    self.bleService=nil;
    [[BluetoothLEManager sharedManager] discoverDevices];
}

-(void)readBLEData
{
    [self.bleService readValueForServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF2"];
}

-(void)writeBLEData:(NSData *)aData resp:(bool)bResp
{
    [self.bleService setValue:aData forServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF2" resp:bResp];
}

@end
