//
//  IChartViewCell.h
//  IWeigh
//
//  Created by xujunwu on 15/7/21.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "UIViewExtention.h"
#import "BEMSimpleLineGraphView.h"

@protocol IChartViewCellDelegate;


@interface IChartViewCell : UIViewExtention<BEMSimpleLineGraphDelegate,BEMSimpleLineGraphDataSource>
{
    UIView                  *contentView;
    
    UILabel                 *titleLabel;
    UILabel                 *descLabel;
    BEMSimpleLineGraphView  *chartView;
    
    NSMutableArray          *datas;
    NSMutableArray          *titles;
    
    id<IChartViewCellDelegate>  delegate;
}
@property (nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)initializeFields;


@end


@protocol IChartViewCellDelegate <NSObject>

@optional
-(void)onIChartViewCellClicked:(IChartViewCell*)view;
@end