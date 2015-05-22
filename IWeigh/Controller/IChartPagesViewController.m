//
//  IChartPagesViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/28.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IChartPagesViewController.h"
#import "IChartViewController.h"

@interface IChartPagesViewController ()<PageSwitchViewDelegate>

@property (nonatomic,strong)PageSwitchView  *pageSwitchView;
@property (nonatomic,strong)IChartViewController*   chartController0;
@property (nonatomic,strong)IChartViewController*   chartController1;
@property (nonatomic,strong)IChartViewController*   chartController2;
@property (nonatomic,strong)IChartViewController*   chartController3;
@property (nonatomic,strong)IChartViewController*   chartController4;
@property (nonatomic,strong)IChartViewController*   chartController5;
@property (nonatomic,strong)IChartViewController*   chartController6;
@property (nonatomic,strong)IChartViewController*   chartController7;
@property (nonatomic,strong)IChartViewController*   chartController8;

@end

@implementation IChartPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"指标趋势图";
    
    self.pageSwitchView=[[PageSwitchView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.pageSwitchView.pageSwitchViewDelegate=self;
    self.pageSwitchView.tabItemNormalColor=[PageSwitchView colorFromHexRGB:@"868686"];
    self.pageSwitchView.tabItemSelectedColor=[PageSwitchView colorFromHexRGB:@"bb0b15"];
//    self.pageSwitchView.tabItemNormalBackgroundImage=[UIImage imageNamed:@"login_input_bg"];
    [self.view addSubview:self.pageSwitchView];
    
    DLog(@"%f",self.view.frame.size.height);
    
    self.chartController0=[[IChartViewController alloc]init];
    self.chartController0.title=@"体重";
    self.chartController1=[[IChartViewController alloc]init];
    self.chartController1.title=@"脂肪率";
    self.chartController2=[[IChartViewController alloc]init];
    self.chartController2.title=@"人体水份";
    self.chartController3=[[IChartViewController alloc]init];
    self.chartController3.title=@"内脏脂肪";
    self.chartController4=[[IChartViewController alloc]init];
    self.chartController4.title=@"肌肉含量";
    self.chartController5=[[IChartViewController alloc]init];
    self.chartController5.title=@"骨含量";
    self.chartController6=[[IChartViewController alloc]init];
    self.chartController6.title=@"基础代谢率";
    self.chartController7=[[IChartViewController alloc]init];
    self.chartController7.title=@"身体质量指数";
    self.chartController8=[[IChartViewController alloc]init];
    self.chartController8.title=@"皮下脂肪率";
    //皮下脂肪率
    [self.pageSwitchView buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfTab:(PageSwitchView *)view
{
    return 9;
}

-(UIViewController*)pageSwitchView:(PageSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number==0) {
        return self.chartController0;
    }else if (number==1) {
        return self.chartController1;
    }else if (number==2) {
        return self.chartController2;
    }else if (number==3) {
        return self.chartController3;
    }else if (number==4) {
        return self.chartController4;
    }else if (number==5) {
        return self.chartController5;
    }else if (number==6) {
        return self.chartController6;
    }else if (number==7) {
        return self.chartController7;
    }else if (number==8) {
        return self.chartController8;
    }
    return 0;
}

-(void)pageSwitchView:(PageSwitchView *)view didselectTab:(NSUInteger)number
{
    
}

@end
