//
//  IInfoViewCell.m
//  IWeigh
//
//  Created by xujunwu on 7/11/15.
//  Copyright (c) 2015 ___xujun___. All rights reserved.
//

#import "IInfoViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@implementation IInfoViewCell
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        [self initializeFields];
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handelSingleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

-(void)initializeFields
{
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [contentView.layer setCornerRadius:8.0f];
    [contentView.layer setMasksToBounds:YES];
    
    titleLabel=[[UILabel alloc]init];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [titleLabel setText:@"资讯标题"];
    [titleLabel setTextColor:[UIColor blackColor]];
    [contentView addSubview:titleLabel];
    
    iconView=[[UIImageView alloc]init];
    iconView.contentMode=UIViewContentModeScaleToFill;
    [contentView addSubview:iconView];
    
    
    descLabel=[[UILabel alloc]init];
    [descLabel setText:@"....."];
    [descLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [descLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [descLabel setNumberOfLines:0];
    [descLabel setTextColor:[UIColor blackColor]];
    [contentView addSubview:descLabel];
    
    timeLabel=[[UILabel alloc]init];
    [timeLabel setText:@"2015-07-10"];
    [timeLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:timeLabel];
    
    [self addSubview:contentView];
    [self reAdjustLayout];
    
}


-(void)handelSingleTap:(UITapGestureRecognizer*)recognizer
{
    [contentView setBackgroundColor:[UIColor grayColor]];
    [self performSelector:@selector(singleTap:) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(clearViewColor:) withObject:nil afterDelay:0.6];
}

-(void)singleTap:(id)sender
{
    if ([delegate respondsToSelector:@selector(onIInfoViewCellClicked:)]) {
        [delegate onIInfoViewCellClicked:self];
    }
}

-(void)clearViewColor:(id)sender
{
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self setNeedsDisplay];
}


-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)reAdjustLayout
{
    [contentView setFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
    
    CGSize contentViewArea=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    
    [titleLabel setFrame:CGRectMake(5, 5,contentViewArea.width-10, 30)];
    [iconView setFrame:CGRectMake(5, 35, contentViewArea.width-10, 120)];
    [descLabel setFrame:CGRectMake(5, 140, contentViewArea.width-10,50)];
    
}


-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"title"]) {
        [titleLabel setText:[infoDict objectForKey:@"title"]];
    }
    
    if ([infoDict objectForKey:@"note"]) {
        [descLabel setText:[infoDict objectForKey:@"note"]];
    }
    
    if ([infoDict objectForKey:@"image"]) {
        [iconView setImageWithURL:[NSURL URLWithString:[infoDict objectForKey:@"image"]] ];
    }
}
@end
