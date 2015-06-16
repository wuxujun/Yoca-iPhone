//
//  IHisViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/5/25.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"

@interface IHisViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSDictionary*        infoDict;
@property(nonatomic,assign)NSInteger            targetType;
@property(nonatomic,assign)BOOL                 isEdit;


-(void)reloadData:(BOOL)isEdit;
@end
