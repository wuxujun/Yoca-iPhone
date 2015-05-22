//
//  IMenuHView.m
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IMenuHView.h"
#import "PathHelper.h"

@implementation IMenuHView
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
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    
    avatarImg=[[UIImageView alloc] init];
//    avatarImg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    avatarImg.image = [UIImage imageNamed:@"userbig.png"];
    
    [contentView addSubview:avatarImg];
    
    
    userNickLabel=[[UILabel alloc]init];
    
    userNickLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    userNickLabel.backgroundColor = [UIColor clearColor];
    userNickLabel.textAlignment=NSTextAlignmentCenter;
    userNickLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
//    userNickLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [contentView addSubview:userNickLabel];

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

    [avatarImg sizeToFit];
    [avatarImg setFrame:CGRectMake((contentViewArea.width-160)/2, 40,100, 100)];
    
    [userNickLabel setFrame:CGRectMake(0, 150, contentViewArea.width-60, 24)];
}

-(void)handelSingleTap:(UITapGestureRecognizer*)recognizer
{
    if ([delegate respondsToSelector:@selector(onMenuHViewClicked:)]) {
        [delegate onMenuHViewClicked:self];
    }
}


-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    [userNickLabel setText:[NSString stringWithFormat:@"%@",[aInfoDict objectForKey:@"title"]]];
    if ([infoDict objectForKey:@"avatar"]) {
        if ([PathHelper fileExistsAtPath:[infoDict objectForKey:@"avatar"]]) {
            [avatarImg setImage:[UIImage imageNamed:[PathHelper filePathInDocument:[infoDict objectForKey:@"avatar"]]]];
        }
    }
    [self setNeedsDisplay];
}
@end
