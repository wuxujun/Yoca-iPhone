//
//  INavigationController.m
//  EHealth
//
//  Created by xujunwu on 14/10/28.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import "INavigationController.h"
#import "IMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface INavigationController ()

@property(strong,readwrite,nonatomic)IMenuViewController* menuViewController;

@end

@implementation INavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)]];
    
}
- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    CGPoint curPoint = [sender locationInView:self.view];
    CGRect bounds=self.view.frame;
    if (curPoint.x<45)
    {
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
    
        // Present the view controller
        //
        [self.frostedViewController panGestureRecognized:sender];
    }
}

@end
