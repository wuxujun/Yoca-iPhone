//
//  IHisTableCell.h
//  IWeigh
//
//  Created by xujunwu on 15/8/3.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HSwipeTableCell.h"

@interface IHisIndicatorView : UIView

@property(nonatomic,strong)UIColor  *indicatorColor;
@property(nonatomic,strong)UIColor  *innerColor;

@end

@interface IHisTableCell : HSwipeTableCell

@property (nonatomic, strong) UILabel * pickTime;
@property (nonatomic, strong) UILabel * value;
@property (nonatomic, strong) IHisIndicatorView * indicatorView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
