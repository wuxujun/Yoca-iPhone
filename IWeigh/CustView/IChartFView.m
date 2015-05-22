//
//  IChartFView.m
//  IWeigh
//
//  Created by xujunwu on 15/5/10.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IChartFView.h"

@implementation IChartFView

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
    
    smallLabel=[[UILabel alloc]init];
    [smallLabel setText:@"最低值"];
    [smallLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [smallLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:smallLabel];
    
    averageLabel=[[UILabel alloc]init];
    [averageLabel setText:@"平均值"];
    [averageLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [averageLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:averageLabel];
    
    
    bigLabel=[[UILabel alloc]init];
    [bigLabel setText:@"最高值"];
    [bigLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [bigLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:bigLabel];
    
    sValueLabel=[[UILabel alloc]init];
    [sValueLabel setText:@"55"];
    [sValueLabel setTextColor:[UIColor greenColor]];
    [sValueLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [sValueLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:sValueLabel];
    
    aValueLabel=[[UILabel alloc]init];
    [aValueLabel setText:@"-0.2"];
    [aValueLabel setTextColor:[UIColor greenColor]];
    [aValueLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [aValueLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:aValueLabel];
    
    
    bValueLabel=[[UILabel alloc]init];
    [bValueLabel setText:@"15"];
    [bValueLabel setTextColor:[UIColor greenColor]];
    [bValueLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [bValueLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:bValueLabel];
    
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
    
    
    [smallLabel setFrame:CGRectMake(0, 4, contentViewArea.width/3, 30)];
    [averageLabel setFrame:CGRectMake(contentViewArea.width/3, 4, contentViewArea.width/3, 30)];
    [bigLabel setFrame:CGRectMake(contentViewArea.width/3*2, 4, contentViewArea.width/3, 30)];
    
    [sValueLabel setFrame:CGRectMake(0, 30, (contentViewArea.width/3)/2+10, 40)];
    [aValueLabel setFrame:CGRectMake(contentViewArea.width/3, 30, (contentViewArea.width/3)/2+10, 40)];
    [bValueLabel setFrame:CGRectMake(contentViewArea.width/3*2, 30, (contentViewArea.width/3)/2+10, 40)];
   
}

@end
