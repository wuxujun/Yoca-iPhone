//
//  IChartFView.h
//  IWeigh
//
//  Created by xujunwu on 15/5/10.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "UIViewExtention.h"

@interface IChartFView : UIViewExtention
{
    UIView      *contentView;
    
    UILabel*    smallLabel;
    UILabel*    averageLabel;
    UILabel*    bigLabel;
    
    UILabel*    sValueLabel;
    UILabel*    aValueLabel;
    UILabel*    bValueLabel;
    
}

@property (nonatomic,strong)NSDictionary* infoDict;


@end
