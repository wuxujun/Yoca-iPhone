//
//  ILoginViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^CompletionBlock)(void);

@interface ILoginViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITextField*         userField;
@property(nonatomic,strong)UITextField*         passField;
@property(nonatomic,strong)UIButton*            forgotButton;
@property(nonatomic,strong)UIButton*            loginButton;

@property(nonatomic,strong)UILabel*             userLabel;
@property(nonatomic,strong)UILabel*             passLabel;
@property(nonatomic,strong)UIView*              userInputBG;
@property(nonatomic,strong)UIView*              passInputBG;


@property(nonatomic,strong)CompletionBlock      completionBlock;

@end
