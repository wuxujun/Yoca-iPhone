//
//  BaseViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"
#import "SIAlertView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.mDatas=[[NSMutableArray alloc]init];
    
    UIBarButtonItem* backBtn=[[UIBarButtonItem alloc]init];
    [backBtn setTitle:@"返回"];
    self.navigationItem.backBarButtonItem=backBtn;
    
    self.networkEngine =  [[HNetworkEngine alloc]initWithHostName:nil customHeaderFields:nil];
    
    _tabBarHeight=self.tabBarController.tabBar.frame.size.height;
    _navHeight=self.navigationController.navigationBar.frame.size.height;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertRequestResult:(NSString *)msg isPop:(BOOL)flag
{
    SIAlertView * aView=[[SIAlertView alloc]initWithTitle:nil andMessage:msg];
    [aView addButtonWithTitle:@"2秒后自动关闭" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        if (flag) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [aView show];
    double delayInSeconds=2.0;
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(),^(void){
        [aView dismissAnimated:YES];
        if (flag) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

-(void)alertRequestResult:(NSString *)msg isDisses:(BOOL)flag
{
    SIAlertView * aView=[[SIAlertView alloc]initWithTitle:nil andMessage:msg];
    [aView addButtonWithTitle:@"2秒后自动关闭" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        if (flag) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
    [aView show];
    double delayInSeconds=2.0;
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(),^(void){
        [aView dismissAnimated:YES];
        if (flag) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    });
}

@end
