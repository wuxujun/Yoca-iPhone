//
//  IContentEViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/5/12.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"


@interface IContentEViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSDictionary*   infoDict;

@end
