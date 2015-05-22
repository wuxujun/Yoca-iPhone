//
//  IMenuViewController.h
//  IWeigh
//
//  Created by xujunwu on 14/10/30.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface IMenuViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray      *mDatas;

@end

