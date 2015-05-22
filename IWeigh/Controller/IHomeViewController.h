//
//  IHomeViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface IHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView*         tableView;

@property(nonatomic,strong)UIButton             *loginBtn;
@property(nonatomic,strong)UIButton             *registerBtn;

@end
