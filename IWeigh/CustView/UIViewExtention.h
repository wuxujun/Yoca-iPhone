//
//  UIViewExtention.h
//  DeviceTest
//
//  Created by  on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewExtention : UIView{
    UIInterfaceOrientation      currrentInterfaceOrientation;
    
    BOOL                        isFullScreen;
    CGRect                      originalRect;
    BOOL                        isMediaAndTextCapable;

}
@property (nonatomic,readonly)UIInterfaceOrientation currrentInterfaceOrientation;
@property (nonatomic,assign)BOOL        isFullScreen;
@property (nonatomic,assign)BOOL        isMediaAntTextCapable;
@property (nonatomic,assign)CGRect      originalRect;

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation;
-(void)reAdjustLayout;

-(void)showFullScreen;
-(void)closeFullScreen;


@end
