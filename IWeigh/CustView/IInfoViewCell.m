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
        datas=[[NSMutableArray alloc]init];
        [self initializeFields];
    }
    return self;
}

-(void)initializeFields
{
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    timeLabel=[[UILabel alloc]init];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setText:@"2015-07-10"];
    [timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [contentView addSubview:timeLabel];
    
    mTableView=[[UITableView alloc]initWithFrame:CGRectMake(15, 40, self.frame.size.width-30,self.frame.size.height-40) style:UITableViewStylePlain];
    mTableView.delegate = (id<UITableViewDelegate>)self;
    mTableView.dataSource = (id<UITableViewDataSource>)self;
    mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    mTableView.backgroundColor=[UIColor whiteColor];
    mTableView.scrollEnabled=NO;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mTableView.layer setCornerRadius:4.0f];
    [mTableView.layer setMasksToBounds:YES];
    [contentView addSubview:mTableView];

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
    
    [timeLabel setFrame:CGRectMake(5, 10,contentViewArea.width-10, 20)];
    [mTableView setFrame:CGRectMake(15, 40, contentViewArea.width-30, contentViewArea.height-40)];
}


-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"groupName"]) {
        [timeLabel setText:[infoDict objectForKey:@"groupName"]];
    }
    id array=[infoDict objectForKey:@"infos"];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<[array count]; i++) {
            [datas addObject:[array objectAtIndex:i]];
        }
    }
    [mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 120;
    }
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    CGRect bounds=mTableView.frame;
    
    NSDictionary* dic=[datas objectAtIndex:indexPath.row];
    
    if (indexPath.row==0) {
        UIImageView* avatarImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, bounds.size.width-10, 110)];
        avatarImg.image = [UIImage imageNamed:@"userbig.png"];
        if ([dic objectForKey:@"image"]) {
            [avatarImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]]];
        }
        avatarImg.contentMode=UIViewContentModeScaleToFill;
        
        [cell addSubview:avatarImg];
        
        UIImageView * bg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 85, bounds.size.width-10, 30)];
        [bg setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:bg];
        
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, bounds.size.width-20, 20)];
        lb.text=[dic objectForKey:@"title"];
        [lb setTextColor:[UIColor whiteColor]];
        lb.textAlignment=NSTextAlignmentLeft;
        [cell addSubview:lb];
    }else{
        UIImageView* avatarImg=[[UIImageView alloc] initWithFrame:CGRectMake(bounds.size.width-60, 6, 48, 48)];
        avatarImg.image = [UIImage imageNamed:@"userbig.png"];
        if ([dic objectForKey:@"image"]) {
            [avatarImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]]];
        }
        [cell addSubview:avatarImg];
        
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(10, 6, bounds.size.width-80, 52)];
        lb.text=[dic objectForKey:@"title"];
        lb.numberOfLines=2;
        lb.lineBreakMode=NSLineBreakByWordWrapping;
        lb.textAlignment=NSTextAlignmentLeft;
        [cell addSubview:lb];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary* dic=[datas objectAtIndex:indexPath.row];
    if (dic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OPEN_INFO object:dic];
    }
    
}



@end
