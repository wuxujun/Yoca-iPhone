//
//  CustomTabBarViewController.m
//  Youhui
//
//  Created by xujunwu on 15/4/12.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "CRNavigationController.h"
#import "HomeViewController.h"
#import "IAnalysisViewController.h"
#import "IInfoViewController.h"
#import "IMyViewController.h"

@implementation CustomTabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"测量" image:[UIImage imageNamed:@"ic_Weight"]],
                            [self viewControllerWithTabTitle:@"分析" image:[UIImage imageNamed:@"ic_Chart"]],
                            [self viewControllerWithTabTitle:@"资讯" image:[UIImage imageNamed:@"ic_Info"]],
                            [self viewControllerWithTabTitle:@"我的" image:[UIImage imageNamed:@"ic_My"]], nil];
    
//    [self initCenterButton];
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
    CRNavigationController* viewController ;
    if ([title isEqualToString:@"测量"]) {
        viewController=[[CRNavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
    }else if([title isEqualToString:@"分析"]){
        viewController=[[CRNavigationController alloc]initWithRootViewController:[[IAnalysisViewController alloc]init]];
    }else if([title isEqualToString:@"资讯"]){
        viewController=[[CRNavigationController alloc]initWithRootViewController:[[IInfoViewController alloc]init]];
    }else if([title isEqualToString:@"我的"]){
        viewController=[[CRNavigationController alloc]initWithRootViewController:[[IMyViewController alloc]init]];
    }
    
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
    return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void)initCenterButton
{
    UIImageView *bgImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_main_bg"]];
    [bgImage setTag:100001];
    UIImage* buttonImage=[UIImage imageNamed:@"tabbar_main"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [button setTag:100001];
    [button addTarget:self action:@selector(find:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0){
        button.center =CGPointMake(self.tabBar.center.x, self.tabBar.frame.size.height/2);
        bgImage.center=CGPointMake(self.tabBar.center.x, self.tabBar.frame.size.height/2);
    }
    else
    {
        CGPoint center =CGPointMake(self.tabBar.center.x, self.tabBar.frame.size.height/2);
        center.y = center.y - heightDifference/2.0;
        button.center = center;
        bgImage.center=center;
    }
    [self.tabBar addSubview:bgImage];
    [self.tabBar addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


-(IBAction)find:(id)sender
{
   
}
@end
