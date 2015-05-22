//
//  IHomeIView.h
//  IWeigh
//  首页Item
//  Created by xujunwu on 15/5/11.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "UIViewExtention.h"
#import "IValueTrackingSlider.h"

@protocol IHomeIViewDelegate;

@interface IHomeIView : UIViewExtention
{
    UIView      *contentView;
    
    UILabel*    titleLabel;
    UILabel*    statusLabel;
    UILabel*    valueLabel;
    UILabel*    unitLabel;
    
    
    UIView*    yLine;
    UIView*    gLine;
    UIView*    rLine;
    UISlider      *sliderView;
    
    UIButton        *chartBtn;
    UIButton        *editBtn;
    
    
    id<IHomeIViewDelegate>       delegate;
}

@property (nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;


@end


@protocol IHomeIViewDelegate <NSObject>

-(void)onChartClicked:(IHomeIView*)view;

@end