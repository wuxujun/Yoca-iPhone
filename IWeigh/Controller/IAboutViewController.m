//
//  IAboutViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/8/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IAboutViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "INavigationController.h"

@interface IAboutViewController ()

@end

@implementation IAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"关于我们"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
