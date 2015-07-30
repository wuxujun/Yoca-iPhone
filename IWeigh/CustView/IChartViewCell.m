//
//  IChartViewCell.m
//  IWeigh
//
//  Created by xujunwu on 15/7/21.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IChartViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "WeightUtils.h"
#import "WeightEntity.h"

@implementation IChartViewCell
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        datas=[[NSMutableArray alloc] init];
        titles=[[NSMutableArray alloc]init];
        [self initializeFields];
        
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handelSingleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

-(void)initializeFields
{
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:APP_FONT_COLOR_SEL];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [contentView.layer setCornerRadius:8.0f];
    [contentView.layer setMasksToBounds:YES];
    
    titleLabel=[[UILabel alloc]init];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [titleLabel setText:@"体重"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [contentView addSubview:titleLabel];
    
    descLabel=[[UILabel alloc]init];
    [descLabel setText:@"日平均值:"];
    [descLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [descLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [descLabel setNumberOfLines:0];
    [descLabel setTextColor:[UIColor whiteColor]];
    [contentView addSubview:descLabel];
    
    chartView=[[BEMSimpleLineGraphView alloc]initWithFrame:CGRectMake(5, 40, self.frame.size.width-10,140)];
    chartView.dataSource=self;
    chartView.delegate=self;
    chartView.enableBezierCurve=YES;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    chartView.gradientBottom=CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    chartView.colorTop=APP_FONT_COLOR_SEL;
    chartView.colorBottom=APP_FONT_COLOR_SEL;
    chartView.colorLine=[UIColor whiteColor];
    chartView.colorXaxisLabel=[UIColor whiteColor];
    chartView.colorYaxisLabel=[UIColor whiteColor];
    chartView.widthLine=2.0;
    chartView.colorPoint=[UIColor grayColor];
    chartView.enableTouchReport = YES;
    chartView.enablePopUpReport = YES;
    chartView.enableBezierCurve = YES;
    chartView.enableYAxisLabel = NO;
    chartView.autoScaleYAxis=YES;
    chartView.alwaysDisplayDots=NO;
    chartView.enableReferenceXAxisLines=YES;
    chartView.enableReferenceYAxisLines=YES;
    chartView.enableReferenceAxisFrame=YES;
    chartView.animationGraphStyle=BEMLineAnimationDraw;

//    [chartView.layer setMasksToBounds:YES];
//    [chartView.layer setCornerRadius:5.0f];

    [contentView addSubview:chartView];
    
    [self addSubview:contentView];
    [self reAdjustLayout];
    
}


-(void)handelSingleTap:(UITapGestureRecognizer*)recognizer
{
    [self performSelector:@selector(singleTap:) withObject:nil afterDelay:0.2];
}

-(void)singleTap:(id)sender
{
    if ([delegate respondsToSelector:@selector(onIChartViewCellClicked:)]) {
        [delegate onIChartViewCellClicked:self];
    }
}

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)reAdjustLayout
{
    [contentView setFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
    
    CGSize contentViewArea=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    
    [titleLabel setFrame:CGRectMake(10, 5,contentViewArea.width-10, 20)];
    [descLabel setFrame:CGRectMake(10, 20, contentViewArea.width-10,20)];
    
}


-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"title"]) {
        [titleLabel setText:[infoDict objectForKey:@"title"]];
    }
    
    if ([infoDict objectForKey:@"note"]) {
        [descLabel setText:[infoDict objectForKey:@"note"]];
    }
    [self loadData:[[infoDict objectForKey:@"aid"] intValue] targetType:[[infoDict objectForKey:@"type"] intValue] days:[[infoDict objectForKey:@"dayCounts"] intValue]];
    [self setNeedsDisplay];
}

-(void)loadData:(NSInteger)aid targetType:(NSInteger)type days:(NSInteger)day
{
    NSArray* array=[[DBManager getInstance] queryWeightWithAccount:aid days:day];
    if ([array count]>0) {
        NSArray* sortedArray=[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result=[((WeightEntity*)obj1).pickTime compare:((WeightEntity*)obj2).pickTime];
            return result;
        }];
        float total=0.0;
        for (int i=0; i<[array count]; i++) {
            WeightEntity* entity=[array objectAtIndex:i];
            if (entity) {
                [titles addObject:entity.pickTime];
                switch (type) {
                    case 0:
                        total+=[entity.bmi floatValue];
                        [datas addObject:entity.bmi];
                        break;
                    case 1:
                        total+=[entity.weight floatValue];
                        [datas addObject:entity.weight];
                        break;
                    case 2:
                        total+=[entity.fat floatValue];
                        [datas addObject:entity.fat];
                        break;
                    case 3:
                        total+=[entity.subFat floatValue];
                        [datas addObject:entity.subFat];
                        break;
                    case 4:
                        total+=[entity.visFat floatValue];
                        [datas addObject:entity.visFat];
                        break;
                    case 5:
                        total+=[entity.water floatValue];
                        [datas addObject:entity.water];
                        break;
                    case 6:
                        total+=[entity.BMR floatValue];
                        [datas addObject:entity.bodyAge];
                        break;
                    case 7:
                        total+=[entity.bodyAge floatValue];
                        [datas addObject:entity.bodyAge];
                        break;
                    case 8:
                        total+=[entity.muscle floatValue];
                        [datas addObject:entity.muscle];
                        break;
                    case 9:
                        total+=[entity.bone floatValue];
                        [datas addObject:entity.bone];
                        break;
                    default:
                        total+=[entity.protein floatValue];
                        [datas addObject:entity.protein];
                        break;
                }
            }
        }
        
        if ([datas count]>0) {
            int c=(int)[datas count];
            [descLabel setText:[NSString stringWithFormat:@"日平均值:%.1f%@",total/c,[[DBManager getInstance] queryTargetUnitForType:type]]];
            [chartView reloadGraph];
        }
    }
}

#pragma mark - 
-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return [datas count];
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[datas objectAtIndex:index] floatValue];
}

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 1;
}

-(NSString*)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    DLog(@"%ld %@",index,[titles objectAtIndex:index]);
    switch (index) {
        case 1:
            return @"周一";
        case 3:
            return @"周三";
        case 5:
            return @"周五";
        default:
            break;
    }
    return @"周日";
}

-(void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index
{
    
}

-(void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index
{
    
}

-(void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph
{
    
}

- (NSInteger)getRandomInteger
{
    NSInteger i1 = (int)(arc4random() % 10000);
    return i1;
}

@end
