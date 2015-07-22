//
//  IUserViewController.h
//  IWeigh
//
//  Created by xujunwu on 7/11/15.
//  Copyright (c) 2015 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"

@interface IUserViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton*    scranButton;
@property(nonatomic,copy) VoidBlock backBlock;
@property(nonatomic,copy) VoidBlock_int     selectBlock;
@end
