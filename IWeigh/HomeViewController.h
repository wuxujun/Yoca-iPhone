//
//  HomeViewController.h
//  IWeigh
//
//  Created by xujunwu on 14-8-30.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UMSocial.h>

@interface HomeViewController : UIViewController<CLLocationManagerDelegate,UMSocialUIDelegate>

@property (nonatomic,strong)UITableView*    mTableView;

@property (nonatomic,strong)NSDictionary*   infoDict;
@end
