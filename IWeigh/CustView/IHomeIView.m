//
//  IHomeIView.m
//  IWeigh
//
//  Created by xujunwu on 15/5/11.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHomeIView.h"

@implementation IHomeIView
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        [self initializedFields];
    }
    return self;
}

-(void)initializedFields
{
    
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    titleLabel=[[UILabel alloc]init];
    [titleLabel setTextColor:APP_FONT_COLOR];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contentView addSubview:titleLabel];

    
    statusLabel=[[UILabel alloc]init];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [statusLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:statusLabel];
    
    valueLabel=[[UILabel alloc]init];
    [valueLabel setTextAlignment:NSTextAlignmentRight];
    [valueLabel setFont:[UIFont systemFontOfSize:14.0]];
    [valueLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:valueLabel];
    
    unitLabel=[[UILabel alloc]init];
    [unitLabel setTextAlignment:NSTextAlignmentLeft];
    [unitLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contentView addSubview:unitLabel];
    
    sliderView=[[UISlider alloc]init];
    [sliderView setBackgroundColor:[UIColor whiteColor]];
    sliderView.value=0.5;
    sliderView.minimumValue=0.0;
    sliderView.maximumValue=1.0;
    [sliderView setThumbImage:[UIImage imageNamed:@"ic_indicator"] forState:UIControlStateNormal];
    [contentView addSubview:sliderView];
    
    yLine=[[UIView alloc]init];
    [yLine setBackgroundColor:APP_LINE_YELLOW];
    [contentView addSubview:yLine];
    
    gLine=[[UIView alloc]init];
    [gLine setBackgroundColor:APP_LINE_GREEN];
    [contentView addSubview:gLine];
    
    rLine=[[UIView alloc]init];
    [rLine setBackgroundColor:APP_LINE_RED];
    [contentView addSubview:rLine];
    
    chartBtn=[[UIButton alloc]init];
    [chartBtn setBackgroundImage:[UIImage imageNamed:@"number"] forState:UIControlStateNormal];
    [chartBtn addTarget:self action:@selector(chart:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:chartBtn];
    
    
    editBtn=[[UIButton alloc]init];
    [editBtn setTag:0];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setHidden:YES];
    [contentView addSubview:editBtn];
    
    [self addSubview:contentView];
    [self reAdjustLayout];
}

-(IBAction)chart:(id)sender
{
    
}

-(IBAction)edit:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if (btn.tag==0) {
        [btn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [btn setTag:1];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"delet_red"] forState:UIControlStateNormal];
        [btn setTag:0];
    }
}

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)reAdjustLayout
{
    [contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGSize contentViewArea=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    
    
    [titleLabel setFrame:CGRectMake(5, 10, contentViewArea.width/5+20, 30)];
    [statusLabel setFrame:CGRectMake(0, 40, contentViewArea.width/5+20, 30)];
    
    [yLine setFrame:CGRectMake(contentViewArea.width/5+20, contentViewArea.height-25, contentViewArea.width/5, 2)];
    [gLine setFrame:CGRectMake(contentViewArea.width/5*2+20, contentViewArea.height-25, contentViewArea.width/5, 2)];
    [rLine setFrame:CGRectMake(contentViewArea.width/5*3+20, contentViewArea.height-25, contentViewArea.width/5, 2)];
    
    [sliderView setFrame:CGRectMake(contentViewArea.width/5+20, contentViewArea.height-24, contentViewArea.width/5*3, 1)];
    
    [chartBtn setFrame:CGRectMake(contentViewArea.width-50, (contentViewArea.height-32)/2, 32, 32)];
    [editBtn setFrame:CGRectMake(contentViewArea.width-50, (contentViewArea.height-32)/2, 32, 32)];
    
    
    [valueLabel setFrame:CGRectMake(contentViewArea.width/5*3+20, 15, contentViewArea.width/5, 30)];
    [unitLabel setFrame:CGRectMake(contentViewArea.width/5*4+20, 30, contentViewArea.width/5, 30)];
}

-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    NSLog(@"%@",aInfoDict);
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"title"]) {
        [titleLabel setText:[infoDict objectForKey:@"title"]];
    }
    
    if ([infoDict objectForKey:@"value"]) {
        [valueLabel setText:[infoDict objectForKey:@"value"]];
    }
    
    if ([infoDict objectForKey:@"unit"]) {
        [unitLabel setText:[infoDict objectForKey:@"unit"]];
    }
    if ([infoDict objectForKey:@"status"]) {
        [statusLabel setText:[infoDict objectForKey:@"status"]];
    }
    
    if ([infoDict objectForKey:@"isEdit"]) {
        [editBtn setHidden:NO];
        [chartBtn setHidden:YES];
    }
    [self setNeedsDisplay];
}

@end
