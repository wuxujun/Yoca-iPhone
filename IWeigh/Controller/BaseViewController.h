//
//  BaseViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNetworkEngine.h"

@interface BaseViewController : UIViewController

@property(nonatomic,strong)UILabel              *titleLabel;
@property(nonatomic,strong)UITableView*         mTableView;
@property(nonatomic,strong)NSMutableArray       *mDatas;
@property(nonatomic,strong)HNetworkEngine       *networkEngine;



-(void)alertRequestResult:(NSString*)msg isPop:(BOOL)flag;
-(void)alertRequestResult:(NSString *)msg isDisses:(BOOL)flag;
@end
