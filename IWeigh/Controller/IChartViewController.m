//
//  IChartViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/15.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IChartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+NavigationBarButton.h"
#import "WeightHisEntity.h"
#import "IChartFView.h"

@interface IChartViewController()

@property (nonatomic,strong)NSMutableArray*         datas;

@end


@implementation IChartViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
 
    self.datas=[[NSMutableArray alloc]init];
    for (int i=0; i<7;i++) {
        [self.datas addObject:@([self getRandomInteger])];
    }
    
    [self setCenterTitle:[self.infoDict objectForKey:@"title"]];
    
    DLog(@"%@",self.infoDict);
    
    float height=[[self.infoDict objectForKey:@"height"] floatValue];
    
    self.myGraph=[[BEMSimpleLineGraphView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10,200)];
    self.myGraph.dataSource=self;
    self.myGraph.delegate=self;
    self.myGraph.enableBezierCurve=YES;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    self.myGraph.gradientBottom=CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.myGraph.colorTop=RGBCOLOR(31, 187, 166);
    self.myGraph.colorBottom=RGBCOLOR(31, 187, 166);
    self.myGraph.colorLine=[UIColor whiteColor];
    self.myGraph.colorXaxisLabel=[UIColor whiteColor];
    self.myGraph.colorYaxisLabel=[UIColor whiteColor];
    self.myGraph.widthLine=3.0;
    self.myGraph.colorPoint=[UIColor grayColor];
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableBezierCurve = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis=YES;
    self.myGraph.alwaysDisplayDots=NO;
    self.myGraph.enableReferenceXAxisLines=YES;
    self.myGraph.enableReferenceYAxisLines=YES;
    self.myGraph.enableReferenceAxisFrame=YES;
    self.myGraph.animationGraphStyle=BEMLineAnimationDraw;
    [self.myGraph.layer setMasksToBounds:YES];
    [self.myGraph.layer setCornerRadius:5.0f];
    
    [self.view addSubview:self.myGraph];
//    NSArray* array=[WeightHisEntity MR_findAll];
//    DLog(@"%d",[array count]);
    
//    for (WeightHisEntity* entity in array) {
//        if (entity) {
//            DLog(@"%@   %@  %@  %@",entity.weight,entity.bmr,entity.fat,entity.subFat);
//        }
//    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSArray* array=[WeightHisEntity MR_findAll];
//    DLog(@"%d",[array count]);
    
//    for (WeightHisEntity* entity in array) {
//        if (entity) {
//            DLog(@"%@   %@  %@  %@",entity.weight,entity.bmr,entity.fat,entity.subFat);
//        }
//    }

}

- (NSInteger)getRandomInteger
{
    NSInteger i1 = (int)(arc4random() % 10000);
    return i1;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return (int)[self.datas count];
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[self.datas objectAtIndex:index] floatValue];
}

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 1;
}

-(NSString*)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    DLog(@"%d",index);
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




@end
