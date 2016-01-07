//
//  IAccoutTableCell.m
//  IWeigh
//
//  Created by xujunwu on 15/8/3.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IAccoutTableCell.h"

@implementation IAccoutTableCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatar setImage:[UIImage imageNamed:@"userbig.png"]];
        _userNick = [[UILabel alloc] initWithFrame:CGRectZero];
        _birthday = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userNick setTextColor:[UIColor whiteColor]];
        [_birthday setTextColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:_avatar];
        [self.contentView addSubview:_userNick];
        [self.contentView addSubview:_birthday];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftPadding = 20.0;
    CGFloat topPadding = (64-40)/2.0;
    CGFloat textWidth = self.contentView.bounds.size.width - leftPadding * 2-80;
    
    _avatar.frame=CGRectMake(leftPadding, 10, 64, 64);
    
    _userNick.frame = CGRectMake(leftPadding+80, topPadding, textWidth, 44);
    _birthday.frame = CGRectMake(leftPadding+80, 40, textWidth, 44);
}
@end
