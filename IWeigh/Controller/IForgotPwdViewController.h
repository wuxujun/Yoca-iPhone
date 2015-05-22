//
//  IForgotPwdViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface IForgotPwdViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITextField*         userField;
@property(nonatomic,strong)UITextField*         codeField;
@property(nonatomic,strong)UIButton*            codeButton;

@end
