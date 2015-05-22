//
//  TargetHeadView.h
//  IWeigh
//
//  Created by xujunwu on 15/3/5.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "UIViewExtention.h"

@protocol TargetHeadViewDelegate;

@interface TargetHeadView : UIViewExtention
{
    UIView                  *contentView;
    
    UILabel                 *recomLabel;
    UILabel                 *recomVLabel;
    UILabel                 *recomULabel;
    
    UILabel                 *currentLabel;
    
    
    UIButton                *favButton;
    
    id<TargetHeadViewDelegate>      delegate;
}

@property (nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)initializeFields;


@end


@protocol TargetHeadViewDelegate <NSObject>

-(void)onTargetHeadViewFavClicked;

@end