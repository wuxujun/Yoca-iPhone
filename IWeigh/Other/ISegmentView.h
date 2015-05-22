//
//  ISegmentView.h
//  IWeigh
//
//  Created by xujunwu on 15/2/15.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISegmentViewDelegate <NSObject>
- (void)segmentViewSelectIndex:(NSInteger)index;
@end

@interface ISegmentView : UIView
/**
 *  设置风格颜色 默认蓝色风格
 */
@property(nonatomic ,strong) UIColor *tintColor;
@property(nonatomic) id<ISegmentViewDelegate> delegate;

/**
 *  默认构造函数
 *
 *  @param frame frame
 *  @param items title字符串数组
 *
 *  @return 当前实例
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

-(void)selectForItem:(int)idx;

@end
