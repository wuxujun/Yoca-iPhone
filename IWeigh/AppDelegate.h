//
//  AppDelegate.h
//  IWeigh
//
//  Created by xujunwu on 14-8-30.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothLEManager.h"
#import "BluetoothLEService.h"
#import "REFrostedViewController.h"
#import "CustomTabBarViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import "HNetworkEngine.h"
#import <SMS_SDK/SMS_SDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,REFrostedViewControllerDelegate,BluetoothLEManagerDelegateProtocol,BluetoothLEServiceProtocol,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) CustomTabBarViewController*    viewController;

@property (nonatomic,assign)CBPeripheral    *peripheral;
@property (nonatomic,strong)BluetoothLEService  *bleService;

@property (nonatomic)UIBackgroundTaskIdentifier     bgTask;
@property (strong, nonatomic) HNetworkEngine*       networkEngine;
@property(nonatomic,strong)id<GAITracker>       tracker;

@property (nonatomic,strong)NSTimer             *bleReadTimer;

@property float  autoSizeScaleX;
@property float  autoSizeScaleY;

-(void)openBLEView;
-(void)openMainView;
-(void)openTabMainView;
-(void)openHomeView;
-(void)writeBLEData:(NSData*)aData resp:(bool)bResp;
+(AppDelegate*)getAppelegate;

@end
