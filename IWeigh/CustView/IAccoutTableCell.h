//
//  IAccoutTableCell.h
//  IWeigh
//
//  Created by xujunwu on 15/8/3.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HSwipeTableCell.h"

@interface IAccoutTableCell : HSwipeTableCell

@property (nonatomic, strong) UIImageView       *avatar;
@property (nonatomic, strong) UILabel           *userNick;
@property (nonatomic, strong) UILabel           *birthday;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
