//
//  IDatePicker.h
//  IWeigh
//
//  Created by xujunwu on 15/5/21.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDatePickerDelegate <NSObject>

@optional
-(void)dateChanged:(id)sender;

@end

@interface IDatePicker : UIControl

@property (nonatomic,strong)id<IDatePickerDelegate> delegate;
@property (nonatomic,strong)NSDate*     date;

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly showType:(NSInteger)type;

@end
