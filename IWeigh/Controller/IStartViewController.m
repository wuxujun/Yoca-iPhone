//
//  IStartViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/8/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IStartViewController.h"
@interface IStartViewController ()

@end

@implementation IStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage"]];
    bg.frame=self.view.frame;
    [self.view addSubview:bg];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
