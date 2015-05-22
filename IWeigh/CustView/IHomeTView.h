//
//  IHomeTView.h
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExtention.h"

@interface IHomeTView : UIViewExtention
{
    
    UIView      *contentView;
    
    UILabel*    totalLabel;
    UILabel*    weekLabel;
    UILabel*    timeLabel;
    
    UILabel*    tValueLabel;
    UILabel*    wValueLabel;
    UILabel*    dValueLabel;
    
    UILabel*    tUnitLabel;
    UILabel*    wUnitLabel;
    UILabel*    dUnitLabel;
    
}

@property (nonatomic,strong)NSDictionary* infoDict;


@end
