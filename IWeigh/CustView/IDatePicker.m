//
//  IDatePicker.m
//  IWeigh
//
//  Created by xujunwu on 15/5/21.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IDatePicker.h"

@interface IDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger nDays;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (readonly, strong) NSDate *earliestPresentedDate;
@property (nonatomic) BOOL showOnlyValidDates;
@property (nonatomic,assign)NSInteger       showType;
@end

@implementation IDatePicker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    self.minDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly showType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    assert((((minDate) && (maxDate)) && ([minDate compare:maxDate] != NSOrderedDescending)));
    
    self.minDate = minDate;
    self.maxDate = maxDate;
    self.showOnlyValidDates = showValidDatesOnly;
    self.showType=type;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

-(NSDate *)earliestPresentedDate
{
    return self.showOnlyValidDates ? self.minDate : [NSDate dateWithTimeIntervalSince1970:0];
}

- (void)commonInit {
    [self setBackgroundColor:APP_TABLEBG_COLOR];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self initDate];
    
    [self showDateOnPicker:self.date];
    
    [self addSubview:self.picker];
}

-(void)showDateOnPicker:(NSDate *)date
{
    self.date = date;
    
    NSDateComponents *components = [self.calendar
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:self.earliestPresentedDate];
    
    NSDate *fromDate = [self.calendar dateFromComponents:components];
    
    
    components = [self.calendar components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
                                  fromDate:fromDate
                                    toDate:date
                                   options:0];
    
    NSInteger hour = [components hour] + 24 * (INT16_MAX / 120);
    NSInteger minute = [components minute] + 60 * (INT16_MAX / 120);
    NSInteger day = [components day];
    
    switch (self.showType) {
        case 0:
        {
            [self.picker selectRow:day inComponent:0 animated:YES];
        }
            break;
        case 1:
        {
            [self.picker selectRow:hour inComponent:0 animated:YES];
            [self.picker selectRow:minute inComponent:1 animated:YES];
        }
            break;
        default:
        {
            [self.picker selectRow:day inComponent:0 animated:YES];
            [self.picker selectRow:hour inComponent:1 animated:YES];
            [self.picker selectRow:minute inComponent:2 animated:YES];
        }
            break;
    }
}

-(void)initDate
{
    NSInteger startDayIndex = 0;
    NSInteger startHourIndex = 0;
    NSInteger startMinuteIndex = 0;
    
    if ((self.minDate) && (self.maxDate) && self.showOnlyValidDates) {
        NSDateComponents *components = [self.calendar components:NSDayCalendarUnit
                                                        fromDate:self.minDate
                                                          toDate:self.maxDate
                                                         options:0];
        
        nDays = components.day + 1;
    } else {
        nDays = INT16_MAX;
    }
    NSDate *dateToPresent;
    
    if ([self.minDate compare:[NSDate date]] == NSOrderedDescending) {
        dateToPresent = self.minDate;
    } else if ([self.maxDate compare:[NSDate date]] == NSOrderedAscending) {
        dateToPresent = self.maxDate;
    } else {
        dateToPresent = [NSDate date];
    }
    
    NSDateComponents *todaysComponents = [self.calendar components:NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                                          fromDate:self.earliestPresentedDate
                                                            toDate:dateToPresent
                                                           options:0];
    
    startDayIndex = todaysComponents.day;
    startHourIndex = todaysComponents.hour;
    startMinuteIndex = todaysComponents.minute;
    
    self.date = [NSDate dateWithTimeInterval:startDayIndex*24*60*60+startHourIndex*60*60+startMinuteIndex*60 sinceDate:self.earliestPresentedDate];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.showType) {
        case 0:
            return 1;
        case 1:
            return 2;
        default:
            return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.showType) {
        case 0:
            return nDays;
        case 1:
        {
            if (component == 0)
            {
                return INT16_MAX;
            }
            else
            {
                return INT16_MAX;
            }
        }
        default:
        {
            if (component == 0)
            {
                return nDays;
            }
            else if (component == 1)
            {
                return INT16_MAX;
            }
            else
            {
                return INT16_MAX;
            }
        }
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (self.showType) {
        case 0:
            return 150;
        case 1:
            return 100;
        default:
        {
            switch (component) {
            case 0:
                return 150;
            case 1:
                return 60;
            case 2:
                return 60;
            default:
                return 0;
            }
        }
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 48.0f;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:48.0]];
    [lblDate setTextColor:APP_FONT_COLOR_SEL];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    switch (self.showType) {
        case 0:
        {
            NSDate *aDate = [NSDate dateWithTimeInterval:row*24*60*60 sinceDate:self.earliestPresentedDate];
            
            NSDateComponents *components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
            NSDate *today = [self.calendar dateFromComponents:components];
            components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
            NSDate *otherDate = [self.calendar dateFromComponents:components];
            
            if ([today isEqualToDate:otherDate]) {
                [lblDate setText:@"Today"];
            } else {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.locale = [NSLocale currentLocale];
                formatter.dateFormat = @"yyyy-MM-dd";
                [lblDate setText:[formatter stringFromDate:aDate]];
            }
            lblDate.textAlignment = NSTextAlignmentRight;
        }
            break;
        case 1:
        {
            if (component == 0) // Hour
            {
                int max = (int)[self.calendar maximumRangeOfUnit:NSHourCalendarUnit].length;
                [lblDate setText:[NSString stringWithFormat:@"%02d : ",(row % max)]]; // 02d = pad with leading zeros to 2 digits
                lblDate.textAlignment = NSTextAlignmentCenter;
            }
            else if (component == 1) // Minutes
            {
                int max = (int)[self.calendar maximumRangeOfUnit:NSMinuteCalendarUnit].length;
                [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]];
                lblDate.textAlignment = NSTextAlignmentLeft;
            }
        }
            break;
        default:
        {
            if (component == 0) // Date
            {
                NSDate *aDate = [NSDate dateWithTimeInterval:row*24*60*60 sinceDate:self.earliestPresentedDate];
                
                NSDateComponents *components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
                NSDate *today = [self.calendar dateFromComponents:components];
                components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
                NSDate *otherDate = [self.calendar dateFromComponents:components];
                
                if ([today isEqualToDate:otherDate]) {
                    [lblDate setText:@"Today"];
                } else {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.locale = [NSLocale currentLocale];
                    formatter.dateFormat = @"EEE, MMM d";
                    
                    [lblDate setText:[formatter stringFromDate:aDate]];
                }
                lblDate.textAlignment = NSTextAlignmentRight;
            }
            else if (component == 1) // Hour
            {
                int max = (int)[self.calendar maximumRangeOfUnit:NSHourCalendarUnit].length;
                [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]]; // 02d = pad with leading zeros to 2 digits
                lblDate.textAlignment = NSTextAlignmentCenter;
            }
            else if (component == 2) // Minutes
            {
                int max = (int)[self.calendar maximumRangeOfUnit:NSMinuteCalendarUnit].length;
                [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]];
                lblDate.textAlignment = NSTextAlignmentLeft;
            }

        }
            break;
    }
    
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger daysFromStart;
    NSDate *chosenDate;
    
    NSDateComponents *components;
    switch (self.showType) {
        case 0:
        {
            daysFromStart = [pickerView selectedRowInComponent:0];
            chosenDate = [NSDate dateWithTimeInterval:daysFromStart*24*60*60 sinceDate:self.earliestPresentedDate];
            components=[self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:chosenDate];
            components.hour = 0;
            components.minute = 0;
        }
            break;
        case 1:
        {
            daysFromStart=1;
            chosenDate = [NSDate dateWithTimeInterval:daysFromStart*24*60*60 sinceDate:self.earliestPresentedDate];
            NSInteger hour = [pickerView selectedRowInComponent:0];
            NSInteger minute = [pickerView selectedRowInComponent:1];
            components = [self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:chosenDate];
            components.hour = hour%24;
            components.minute = minute%60;
        }
            break;
        default:
        {
            daysFromStart = [pickerView selectedRowInComponent:0];
            chosenDate = [NSDate dateWithTimeInterval:daysFromStart*24*60*60 sinceDate:self.earliestPresentedDate];
            
            NSInteger hour = [pickerView selectedRowInComponent:1];
            NSInteger minute = [pickerView selectedRowInComponent:2];
            // Build date out of the components we got
            components= [self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:chosenDate];
            
            components.hour = hour % 24;
            components.minute = minute % 60;
        }
            break;
    }
    
    self.date = [self.calendar dateFromComponents:components];
    
    if ([self.date compare:self.minDate] == NSOrderedAscending) {
        [self showDateOnPicker:self.minDate];
    } else if ([self.date compare:self.maxDate] == NSOrderedDescending) {
        [self showDateOnPicker:self.maxDate];
    }
    
    
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(dateChanged:)])) {
        [self.delegate dateChanged:self];
    }
}
@end