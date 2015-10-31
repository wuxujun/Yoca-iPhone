//
//  IHomeIView.m
//  IWeigh
//
//  Created by xujunwu on 15/5/11.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHomeIView.h"

@implementation IHomeIView
@synthesize infoDict,isShow;

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
    isShow=NO;
    
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    titleLabel=[[UILabel alloc]init];
    [titleLabel setTextColor:APP_FONT_COLOR];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [contentView addSubview:titleLabel];

    
    statusLabel=[[UILabel alloc]init];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [statusLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:statusLabel];
    
    valueLabel=[[UILabel alloc]init];
    [valueLabel setTextAlignment:NSTextAlignmentRight];
    [valueLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [valueLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:valueLabel];
    
    unitLabel=[[UILabel alloc]init];
    [unitLabel setTextAlignment:NSTextAlignmentLeft];
    [unitLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [unitLabel setTextColor:APP_FONT_COLOR];
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
    [chartBtn setImage:[UIImage imageNamed:@"number"] forState:UIControlStateNormal];
    [chartBtn addTarget:self action:@selector(chart:) forControlEvents:UIControlEventTouchUpInside];
    [chartBtn setHidden:YES];
    
    [contentView addSubview:chartBtn];
    
    
    editBtn=[[UIButton alloc]init];
    [editBtn setTag:0];
    [editBtn setImage:[UIImage imageNamed:@"delet_red"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setHidden:YES];
    [contentView addSubview:editBtn];
    
    [self addSubview:contentView];
    [self reAdjustLayout];
}

-(IBAction)chart:(id)sender
{
    [delegate onChartClicked:self];
}

-(IBAction)edit:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if (btn.tag==0) {
        [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [btn setTag:1];
        isShow=YES;
        [delegate onEditClicked:self];
    }else{
        [btn setImage:[UIImage imageNamed:@"delet_red"] forState:UIControlStateNormal];
        [btn setTag:0];
        isShow=NO;
        [delegate onEditClicked:self];
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
    
    
    [titleLabel setFrame:CGRectMake(5, 10, contentViewArea.width/7*2+10, 30)];
    [statusLabel setFrame:CGRectMake(5, 36, contentViewArea.width/7*2+10, 30)];
    
    [yLine setFrame:CGRectMake(contentViewArea.width/7*2+30, contentViewArea.height-25, contentViewArea.width/7, 2)];
    [gLine setFrame:CGRectMake(contentViewArea.width/7*3+30, contentViewArea.height-25, contentViewArea.width/7, 2)];
    [rLine setFrame:CGRectMake(contentViewArea.width/7*4+30, contentViewArea.height-25, contentViewArea.width/7, 2)];
    
    [sliderView setFrame:CGRectMake(contentViewArea.width/7*2+30, contentViewArea.height-24, contentViewArea.width/7*3, 1)];
    
    [chartBtn setFrame:CGRectMake(contentViewArea.width-50, (contentViewArea.height-32)/2, 32, 32)];
    [editBtn setFrame:CGRectMake(contentViewArea.width-50, (contentViewArea.height-32)/2, 32, 32)];
    
    
    [valueLabel setFrame:CGRectMake(contentViewArea.width/7*3+30, 15, contentViewArea.width/7*2, 30)];
    [unitLabel setFrame:CGRectMake(contentViewArea.width/7*5+30, 30, contentViewArea.width/7, 30)];
}

-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"title"]) {
        [titleLabel setText:[infoDict objectForKey:@"title"]];
    }
    
    if ([infoDict objectForKey:@"value"]) {
        [valueLabel setText:[NSString stringWithFormat:@"%.1f",[[infoDict objectForKey:@"value"] floatValue]]];
    }
    
    if ([infoDict objectForKey:@"unit"]&&![[infoDict objectForKey:@"unit"] isEqual:@"0"]) {
        [unitLabel setText:[infoDict objectForKey:@"unit"]];
    }
    if ([infoDict objectForKey:@"valueTitle"]) {
        [statusLabel setText:[infoDict objectForKey:@"valueTitle"]];
    }
    if ([infoDict objectForKey:@"isChart"]) {
        [chartBtn setHidden:NO];
        [editBtn setHidden:YES];
    }
    if ([infoDict objectForKey:@"progres"]) {
        [sliderView setValue:[[infoDict objectForKey:@"progres"] floatValue]];
    }
    if ([infoDict objectForKey:@"state"]) {
        int state=[[infoDict objectForKey:@"state"] intValue];
        if (state==0) {
            [valueLabel setTextColor:APP_LINE_YELLOW];
            [statusLabel setTextColor:APP_LINE_YELLOW];
            [unitLabel setTextColor:APP_LINE_YELLOW];
        }else if(state==1){
            [valueLabel setTextColor:APP_LINE_GREEN];
            [statusLabel setTextColor:APP_LINE_GREEN];
            [unitLabel setTextColor:APP_LINE_GREEN];
        }else{
            [valueLabel setTextColor:APP_LINE_RED];
            [statusLabel setTextColor:APP_LINE_RED];
            [unitLabel setTextColor:APP_LINE_RED];
        }
    }
    
    if ([infoDict objectForKey:@"isEdit"]) {
        [editBtn setHidden:NO];
        [chartBtn setHidden:YES];
    }
    if ([infoDict objectForKey:@"isShow"]) {
        int state=[[infoDict objectForKey:@"isShow"] intValue];
        [editBtn setTag:state];
        if (state==0) {
            [editBtn setImage:[UIImage imageNamed:@"delet_red"] forState:UIControlStateNormal];
        }else{
            [editBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        }
    }
    
    [self setNeedsDisplay];
}

@end
