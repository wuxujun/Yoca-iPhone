//
//  TargetHeadView.m
//  IWeigh
//
//  Created by xujunwu on 15/3/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "TargetHeadView.h"

@implementation TargetHeadView
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        [self initializeFields];
    }
    return self;
}

-(void)initializeFields
{
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:APP_FONT_COLOR_SEL];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    recomLabel=[[UILabel alloc]init];
    [recomLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [recomLabel setText:@"推荐体重"];
    [recomLabel setTextAlignment:NSTextAlignmentCenter];
    [recomLabel setTextColor:[UIColor whiteColor]];
    [contentView addSubview:recomLabel];
    
    recomVLabel=[[UILabel alloc]init];
    [recomVLabel setFont:[UIFont boldSystemFontOfSize:40.0f]];
    [recomVLabel setTextAlignment:NSTextAlignmentCenter];
    [recomVLabel setText:@"11.0"];
    [recomVLabel setTextColor:[UIColor whiteColor]];
    [contentView addSubview:recomVLabel];
    
    
    recomULabel=[[UILabel alloc]init];
    [recomULabel setTextAlignment:NSTextAlignmentRight];
    [recomULabel setText:@"Kg"];
    [recomULabel setTextColor:[UIColor whiteColor]];
    [contentView addSubview:recomULabel];
    
    currentLabel=[[UILabel alloc]init];
    [currentLabel setText:@"当前体重   60Kg"];
    [currentLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:currentLabel];
    
    favButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:contentView];
    [self reAdjustLayout];
    
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
    
    [recomLabel setFrame:CGRectMake(40, 10,100, 40)];
    [recomVLabel setFrame:CGRectMake(40, 50, contentViewArea.width/2, 80)];
    [recomULabel setFrame:CGRectMake(60, 120, 100, 30)];
    
    [currentLabel setFrame:CGRectMake(20, contentViewArea.height-40, contentViewArea.width-40, 40)];
}


-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"weight"]) {
        [currentLabel setText:[NSString stringWithFormat:@"当前体重: %@ Kg",[infoDict objectForKey:@"weight"]]];
    }
    
    if ([infoDict objectForKey:@"height"]&&[infoDict objectForKey:@"sex"]) {
        if ([[infoDict objectForKey:@"sex"] intValue]==0) {
            [recomVLabel setText:[NSString stringWithFormat:@"%d",[[infoDict objectForKey:@"height"] intValue]-100]];
        }else{
            [recomVLabel setText:[NSString stringWithFormat:@"%d",[[infoDict objectForKey:@"height"] intValue]-105]];
        }
        
    }
    
}
@end
