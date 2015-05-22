//
//  IScanView.h
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExtention.h"
#import "IScrollNumView.h"

@protocol IScanViewDelegate;

@interface IScanView : UIViewExtention
{
    
    UIView          *contentView;
    UIView          *bgView;
    UIView          *scanView;
    
    id<IScanViewDelegate>       delegate;
    
    UIImageView         *footView;
    IScrollNumView*     numView;
    UILabel*        pointLabel;
    
    
    UILabel         *fatLabel;
    UILabel         *weighLabel;
    UILabel         *statusLabel;
    UIButton        *infoButton;
    
    UILabel         *dateLabel;
    UIButton*       leftButton;
    UIButton*       rightButton;

    UIButton        *sharedButton;
}
-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

@property (nonatomic,strong)NSString*       fatValue;
@property (nonatomic,strong)NSString*       dateTitle;
@property (nonatomic,strong)NSString*        weighValue;
@property (nonatomic,strong)NSString*        statusValue;


-(void)setNum:(NSUInteger)number;
-(void)setFoot;

@end


@protocol IScanViewDelegate <NSObject>

@optional
-(void)onScanViewShared:(IScanView*)view;
-(void)onScanViewSelected:(UIButton*)btn;
-(void)onScanViewClicked:(IScanView*)view;

@end