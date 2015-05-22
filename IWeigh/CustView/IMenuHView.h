//
//  IMenuHView.h
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExtention.h"

@protocol IMenuHViewDelegate;

@interface IMenuHView : UIViewExtention
{
    UIView      *contentView;
    
    UIImageView*    avatarImg;
    UILabel*        userNickLabel;
    
    id<IMenuHViewDelegate>      delegate;
}

@property (nonatomic,strong)NSDictionary* infoDict;
-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)initializeFields;

@end


@protocol IMenuHViewDelegate <NSObject>

-(void)onMenuHViewClicked:(IMenuHView*)view;

@end