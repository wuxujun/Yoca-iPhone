//
//  ITargetViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"

@interface ITargetViewController : BaseViewController

@property (nonatomic,strong)UILabel*        setValueLabel;
@property (nonatomic,strong)UITextField*    doneDateField;
@property (nonatomic,strong)UIView*         doneDateBG;

@property (nonatomic,strong)NSDictionary*   infoDict;

@end
