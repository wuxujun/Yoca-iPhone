//
//  IHisTableCell.m
//  IWeigh
//
//  Created by xujunwu on 15/8/3.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHisTableCell.h"

@implementation IHisIndicatorView

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents(_indicatorColor.CGColor));
    CGContextFillPath(ctx);
    
    if (_innerColor) {
        CGFloat innerSize = rect.size.width * 0.5;
        CGRect innerRect = CGRectMake(rect.origin.x + rect.size.width * 0.5 - innerSize * 0.5,
                                      rect.origin.y + rect.size.height * 0.5 - innerSize * 0.5,
                                      innerSize, innerSize);
        CGContextAddEllipseInRect(ctx, innerRect);
        CGContextSetFillColor(ctx, CGColorGetComponents(_innerColor.CGColor));
        CGContextFillPath(ctx);
    }
}

-(void) setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    [self setNeedsDisplay];
}

-(void) setInnerColor:(UIColor *)innerColor
{
    _innerColor = innerColor;
    [self setNeedsDisplay];
}

@end

@implementation IHisTableCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _pickTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _value = [[UILabel alloc] initWithFrame:CGRectZero];
        [_pickTime setTextColor:[UIColor whiteColor]];
        [_value setTextColor:[UIColor whiteColor]];
        [_value setTextAlignment:NSTextAlignmentRight];
        
        _indicatorView = [[IHisIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _indicatorView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_pickTime];
        [self.contentView addSubview:_value];
//        [self.contentView addSubview:_indicatorView];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftPadding = 20.0;
    CGFloat topPadding = (64-20)/2.0;
    CGFloat textWidth = self.contentView.bounds.size.width - leftPadding * 2;
    CGFloat dateWidth = textWidth/2;
    
    _pickTime.frame = CGRectMake(leftPadding, topPadding, dateWidth, 20);
    
    CGRect frame = _pickTime.frame;
    frame.origin.x = self.contentView.frame.size.width - leftPadding - dateWidth;
    frame.size.width = dateWidth;
    _value.frame = frame;
//    _indicatorView.center = CGPointMake(leftPadding * 0.5, _pickTime.frame.origin.y + _pickTime.frame.size.height * 0.5);
}
@end
