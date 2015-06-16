//
//  IChartViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/2/15.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BEMSimpleLineGraphView.h"

@interface IChartViewController : BaseViewController<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (nonatomic,strong) IBOutlet  BEMSimpleLineGraphView *myGraph;

@property (nonatomic,strong)NSDictionary*       infoDict;
@property (nonatomic,assign)NSInteger           targetType;
@end
