//
//  IYocaViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"

@interface IYocaViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSDictionary*        infoDict;

@end
