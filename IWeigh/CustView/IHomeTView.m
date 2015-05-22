//
//  IHomeTView.m
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHomeTView.h"

@implementation IHomeTView


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initializedFields];
    }
    return self;
}

-(void)initializedFields
{
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    totalLabel=[[UILabel alloc]init];
    [totalLabel setText:@"总体目标"];
    [totalLabel setTextColor:APP_FONT_COLOR];
    [totalLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [totalLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:totalLabel];
    
    weekLabel=[[UILabel alloc]init];
    [weekLabel setText:@"本周目标"];
    [weekLabel setTextColor:APP_FONT_COLOR];
    [weekLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [weekLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:weekLabel];
    
    
    timeLabel=[[UILabel alloc]init];
    [timeLabel setText:@"剩余时间"];
    [timeLabel setTextColor:APP_FONT_COLOR];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:timeLabel];
    
    tValueLabel=[[UILabel alloc]init];
    [tValueLabel setText:@"55"];
    [tValueLabel setTextColor:APP_FONT_COLOR_SEL];
    [tValueLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [tValueLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:tValueLabel];
    
    wValueLabel=[[UILabel alloc]init];
    [wValueLabel setText:@"-0.2"];
    [wValueLabel setTextColor:APP_FONT_COLOR_SEL];
    [wValueLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [wValueLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:wValueLabel];
    
    
    dValueLabel=[[UILabel alloc]init];
    [dValueLabel setText:@"15"];
    [dValueLabel setTextColor:APP_FONT_COLOR_SEL];
    [dValueLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [dValueLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:dValueLabel];
    
    tUnitLabel=[[UILabel alloc]init];
    [tUnitLabel setText:@"kg"];
    [tUnitLabel setTextColor:APP_FONT_COLOR_SEL];
    [tUnitLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tUnitLabel setTextAlignment:NSTextAlignmentLeft];
    [contentView addSubview:tUnitLabel];
    
    wUnitLabel=[[UILabel alloc]init];
    [wUnitLabel setText:@"kg"];
    [wUnitLabel setTextColor:APP_FONT_COLOR_SEL];
    [wUnitLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [wUnitLabel setTextAlignment:NSTextAlignmentLeft];
    [contentView addSubview:wUnitLabel];
    
    dUnitLabel=[[UILabel alloc]init];
    [dUnitLabel setText:@"天"];
    [dUnitLabel setTextColor:APP_FONT_COLOR_SEL];
    [dUnitLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [dUnitLabel setTextAlignment:NSTextAlignmentLeft];
    [contentView addSubview:dUnitLabel];
    
    [self addSubview:contentView];
    
    [self reAdjustLayout];
}

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
}

-(void)reAdjustLayout
{
    [contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGSize contentViewArea=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    
    
    [totalLabel setFrame:CGRectMake(0, 4, contentViewArea.width/3, 30)];
    [weekLabel setFrame:CGRectMake(contentViewArea.width/3, 4, contentViewArea.width/3, 30)];
    [timeLabel setFrame:CGRectMake(contentViewArea.width/3*2, 4, contentViewArea.width/3, 30)];
                                   
    [tValueLabel setFrame:CGRectMake(0, 30, (contentViewArea.width/3)/2+10, 40)];
    [wValueLabel setFrame:CGRectMake(contentViewArea.width/3, 30, (contentViewArea.width/3)/2+10, 40)];
    [dValueLabel setFrame:CGRectMake(contentViewArea.width/3*2, 30, (contentViewArea.width/3)/2+10, 40)];
    
    [tUnitLabel setFrame:CGRectMake((contentViewArea.width/3)/2+10, 40, (contentViewArea.width/3)/2-10, 26)];
    [wUnitLabel setFrame:CGRectMake((contentViewArea.width/3)/2+10+contentViewArea.width/3, 40, (contentViewArea.width/3)/2-10, 26)];
    [dUnitLabel setFrame:CGRectMake((contentViewArea.width/3)/2+10+contentViewArea.width/3*2, 40, (contentViewArea.width/3)/2-10, 26)];
    
}
@end
