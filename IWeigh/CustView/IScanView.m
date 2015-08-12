//
//  IScanView.m
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IScanView.h"

@implementation IScanView

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
    
    bgView=[[UIView alloc]init];
    [bgView setBackgroundColor:APP_FONT_COLOR_SEL];
    [contentView addSubview:bgView];
    
    scanView=[[UIView alloc]init];
    [scanView setBackgroundColor:APP_TABLEBG_COLOR];
    [contentView addSubview:scanView];
    
    footView=[[UIImageView alloc]init];
    [footView setImage:[UIImage imageNamed:@"green_foot.png"]];
    [contentView addSubview:footView];
    
    leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTag:100];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftButton];
    
    dateLabel=[[UILabel alloc]init];
    [dateLabel setText:@"今日"];
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:14.0]];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:dateLabel];
    
    rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTag:200];
    [rightButton setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rightButton];
    
    line=[[UIImageView alloc]init];
    [line setBackgroundColor:APP_LINE_GREEN];
    [contentView addSubview:line];
    
    
    fatLabel=[[UILabel alloc]init];
    [fatLabel setText:@""];
    [fatLabel setTextColor:[UIColor grayColor]];
    [fatLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [fatLabel setTextAlignment:NSTextAlignmentLeft];
    [contentView addSubview:fatLabel];
    
    weighLabel=[[UILabel alloc]init];
    [weighLabel setText:@"0.0"];
    [weighLabel setTextColor:APP_FONT_COLOR_SEL];
    [weighLabel setFont:[UIFont boldSystemFontOfSize:42.0]];
    [weighLabel setTextAlignment:NSTextAlignmentCenter];
    [weighLabel setHidden:YES];
    [contentView addSubview:weighLabel];
    
    infoButton=[[UIButton alloc]init];
    [infoButton setBackgroundColor:[UIColor clearColor]];
    [infoButton addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setHidden:YES];
    [contentView addSubview:infoButton];
    
    infoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info.png"]];
    [infoImage setHidden:YES];
    [contentView addSubview:infoImage];
    
    statusLabel=[[UILabel alloc]init];
    [statusLabel setText:@"未连接"];
    [statusLabel setTextColor:APP_FONT_COLOR_SEL];
    [statusLabel setFont:[UIFont systemFontOfSize:14.0]];
    [statusLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:statusLabel];
    
    sharedButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sharedButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [sharedButton addTarget:self action:@selector(shared:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sharedButton];
    [sharedButton setHidden:YES];
    
    [self addSubview:contentView];
    
    bStartScan=false;
    upOrDown=NO;
    num=0;
    
    [self reAdjustLayout];
}

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(IBAction)selected:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if ([delegate respondsToSelector:@selector(onScanViewSelected:)]) {
        [delegate onScanViewSelected:btn];
    }
}

-(IBAction)shared:(id)sender
{
    if ([delegate respondsToSelector:@selector(onScanViewShared:)]) {
        [delegate onScanViewShared:self];
    }
}

-(IBAction)onClicked:(id)sender
{
    if ([delegate respondsToSelector:@selector(onScanViewClicked:)]) {
        [delegate onScanViewClicked:self];
    }
}
-(void)setDateTitle:(NSString *)dateTitle
{
    [dateLabel setText:dateTitle];
    [self setNeedsDisplay];
}

-(void)setNum:(NSUInteger)number
{
    [footView setHidden:YES];
    [weighLabel setHidden:YES];
    [infoButton setHidden:YES];
    [infoImage setHidden:YES];
    [self setNeedsDisplay];
}

-(void)setFoot
{
    [footView setHidden:NO];
    [weighLabel setHidden:YES];
    [infoButton setHidden:YES];
    [infoImage setHidden:YES];
    [line setHidden:YES];
    [self setNeedsDisplay];
}

-(void)setWeighValue:(NSString *)weighValue
{
    [weighLabel setText:weighValue];
    [weighLabel setHidden:NO];
    [footView setHidden:YES];
    [infoButton setHidden:NO];
    [infoImage setHidden:NO];
    [line setHidden:YES];
    [timer invalidate];
    bStartScan=false;
    [self setNeedsDisplay];
}

-(void)setStatusValue:(NSString *)statusValue
{
    [statusLabel setText:statusValue];
    if ([statusValue isEqualToString:@"已连接"]) {
        [self startScan];
    }
    if ([statusValue isEqualToString:@"未连接"]) {
        [timer invalidate];
        [line setHidden:YES];
    }
    [self setNeedsDisplay];
}
-(void)setFatValue:(NSString *)fatValue
{
    [fatLabel setText:fatValue];
    [self setNeedsDisplay];
}

-(void)reAdjustLayout
{
    [contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGSize contentViewArea=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    
    [bgView setFrame:CGRectMake((contentViewArea.width-180)/2, (contentViewArea.height-180)/2+10, 180, 180)];
    
    [scanView setFrame:CGRectMake((contentViewArea.width-170)/2, (contentViewArea.height-170)/2+10, 170, 170)];

    [leftButton setFrame:CGRectMake((contentViewArea.width-120)/2-40, 15, 32, 20)];
    [dateLabel setFrame:CGRectMake((contentViewArea.width-120)/2, 8, 120, 40)];
    [rightButton setFrame:CGRectMake((contentViewArea.width-120)/2+120+10, 15, 32, 20)];
    
    [fatLabel setFrame:CGRectMake((contentViewArea.width-120)/2, (contentViewArea.height-120)/2-20, 120, 40)];
    [footView setFrame:CGRectMake((contentViewArea.width-120)/2, (contentViewArea.height-120)/2+10, 120, 120)];

    [weighLabel setFrame:CGRectMake((contentViewArea.width-120)/2, (contentViewArea.height-120)/2+10, 120, 120)];
    [infoButton setFrame:CGRectMake((contentViewArea.width-170)/2, (contentViewArea.height-170)/2+10, 170, 170)];
    [infoImage setFrame:CGRectMake((contentViewArea.width-170)/2+10, contentViewArea.height-70, 26, 26)];

    [statusLabel setFrame:CGRectMake((contentViewArea.width-150)/2, contentViewArea.height-70, 150, 40)];
    [sharedButton setFrame:CGRectMake(contentViewArea.width-60, contentViewArea.height-80, 30, 38)];
    
}

-(void)startScan
{
    if (!bStartScan) {
        timer=[NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animationUpOrDown) userInfo:nil repeats:YES];
        [line setHidden:NO];
        bStartScan=true;
    }
}

-(void)animationUpOrDown
{
    if (upOrDown==NO) {
        num++;
        line.frame=CGRectMake((self.frame.size.width-170)/2, (self.frame.size.height-170)/2+10+2*num, 170, 2);
        if (2*num==170) {
            upOrDown=YES;
        }
    }else{
        num--;
        line.frame=CGRectMake((self.frame.size.width-170)/2, (self.frame.size.height-170)/2+10+2*num, 170, 2);
        if (num==0) {
            upOrDown=NO;
        }
    }
}


@end
