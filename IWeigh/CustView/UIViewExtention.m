//
//  UIViewExtention.m
//  DeviceTest
//
//  Created by  on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewExtention.h"

@implementation UIViewExtention

@synthesize currrentInterfaceOrientation,isFullScreen,originalRect,isMediaAntTextCapable;

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)reAdjustLayout
{
}

-(void)showFullScreen
{
}

-(void)closeFullScreen
{
}

@end
