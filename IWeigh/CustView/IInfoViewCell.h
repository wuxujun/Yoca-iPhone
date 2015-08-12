//
//  IInfoViewCell.h
//  IWeigh
//
//  Created by xujunwu on 7/11/15.
//  Copyright (c) 2015 ___xujun___. All rights reserved.
//

#import "UIViewExtention.h"

@protocol IInfoViewCellDelegate;

@interface IInfoViewCell : UIViewExtention
{
    UIView                  *contentView;
    
    UILabel                 *timeLabel;
    UITableView*            mTableView;
    
    id<IInfoViewCellDelegate>           delegate;
    
    NSMutableArray          *datas;
    
}

@property (nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)initializeFields;

@end

@protocol IInfoViewCellDelegate <NSObject>

@optional
-(void)onIInfoViewCellClicked:(IInfoViewCell*)view;
@end