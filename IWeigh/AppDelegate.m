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
#import "AccountEntity.h"
#import "IAccountDViewController.h"
#import "MobClick.h"
#import "BLEViewController.h"
#import "DBHelper.h"
#import "DBManager.h"
#import "BLEViewController.h"
#import "UserDefaultHelper.h"
#import "HCurrentUserContext.h"

#import <UMSocial.h>
#import <UMSocialSnsService.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaHandler.h>

#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAITracker.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSDictionary *appDefault=@{kAllowTracking:@(YES)};
    [[NSUserDefaults standardUserDefaults]registerDefaults:appDefault];
    [GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [GAI sharedInstance].dispatchInterval=20;
    //    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].trackUncaughtExceptions=YES;
    self.tracker=[[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Yoca"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView]build]];
    
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
    
    [SMS_SDK registerApp:@"12a614ceb40a" withSecret:@"bc5c19f196ac4e9c52e96d3a4fbfda63"];
    [UMSocialData setAppKey:@"52649a7e56240b87b6169d13"];
    
    [self initializePlat];
    
    [NSThread sleepForTimeInterval:2.0];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ic_nav"] forBarMetrics:UIBarMetricsDefault];
    UIColor* navigationTextColor=APP_FONT_COLOR;
    self.window.tintColor=navigationTextColor;
    
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    IHomeViewController* homeView=[[IHomeViewController alloc]init];
//    BLEViewController* homeView=[[BLEViewController alloc]init];
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:homeView];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)initializePlat
{
//    [UMSocialWechatHandler setWXAppId:@"" appSecret:@"" url:@""];
//    [UMSocialQQHandler setQQWithAppId:@"" appKey:@"" url:@""];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    int buildVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey] intValue];
    DLog(@"%d",buildVersion);
    NSInteger   isInit=[[UserDefaultHelper objectForKey:CONFIG_INIT_FLAG] integerValue];
    
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
                        DLog(@"Config insert or update success %d",i);
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
                        DLog(@"TargetInfo insert or update success %d",i);
                    }
                }
            }
        }
        
//        [ApplicationDelegate openBLEView];
        
        if ([[HCurrentUserContext sharedInstance] uid]) {
            DLog(@"%@",[[HCurrentUserContext sharedInstance] uid]);
            [ApplicationDelegate openMainView];
        }else{
            [ApplicationDelegate openHomeView];
        }
        
    } error:^(NSError *error) {
        
    }];
}

-(void)openBLEView
{
    for (UIView* view in self.window.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    BLEViewController* homeView=[[BLEViewController alloc]init];
    
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:homeView];
    
    [self.window setRootViewController:navController];
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

-(void)syncWeight
{
    NSString *url = [NSString stringWithFormat:@"%@getWeights",kHttpUrl];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"syncid", nil]];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        DLog(@"%@",rs);
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
    
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Yoca" action:@"Close" label:@"Close Yoca" value:[NSNumber numberWithInt:2]] build]];
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
    [MobClick checkUpdate];
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
                    if ([self.peripheral isConnected]) {
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
        [self.bleService setValue:d forServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF1"];
        [self.bleService startNotifyingForServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF2"];
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

-(void)writeBLEData:(NSData *)aData
{
    [self.bleService setValue:aData forServiceUUID:@"FFF0" andCharacteristicUUID:@"FFF1"];
}

@end
