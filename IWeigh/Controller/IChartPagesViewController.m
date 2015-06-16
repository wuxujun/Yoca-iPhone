//
//  IChartPagesViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/28.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IChartPagesViewController.h"
#import "IChartViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "IChartFView.h"

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
@property (nonatomic,strong)IChartViewController*   chartController9;
@property (nonatomic,strong)IChartViewController*   chartController10;



@property (nonatomic,strong)IChartFView*        footView;

@end

@implementation IChartPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarButton];
    [self setCenterTitle:@"指标趋势图"];
    
    self.pageSwitchView=[[PageSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.pageSwitchView.pageSwitchViewDelegate=self;
    self.pageSwitchView.tabItemNormalColor=[PageSwitchView colorFromHexRGB:@"868686"];
    self.pageSwitchView.tabItemSelectedColor=[PageSwitchView colorFromHexRGB:@"45C979"];
//    self.pageSwitchView.tabItemNormalBackgroundImage=[UIImage imageNamed:@"login_input_bg"];
    [self.view addSubview:self.pageSwitchView];
    [self.view setBackgroundColor:APP_BACKGROUND_COLOR];
    
    if (self.footView==nil) {
        self.footView=[[IChartFView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-80-64, self.view.frame.size.width, 80)];
        [self.view addSubview:self.footView];
        
    }
    
    DLog(@"%f  nav Height  %f   %f",self.view.frame.size.height,self.navigationController.navigationBar.frame.size.height,self.pageSwitchView.frame.size.height);
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:self.infoDict];
    [dict setObject:[NSString stringWithFormat:@"%.0f",self.pageSwitchView.frame.size.height] forKey:@"height"];
    
    self.chartController0=[[IChartViewController alloc]init];
    [self.chartController0.view setFrame:self.pageSwitchView.frame];
    self.chartController0.infoDict=dict;
    self.chartController0.targetType=0;
    self.chartController0.title=@"体质指数";
    self.chartController1=[[IChartViewController alloc]init];
    self.chartController1.infoDict=dict;
    self.chartController1.targetType=1;
    self.chartController1.title=@"体重";
    self.chartController2=[[IChartViewController alloc]init];
    self.chartController2.infoDict=dict;
    self.chartController2.targetType=2;
    self.chartController2.title=@"脂肪率";
    self.chartController3=[[IChartViewController alloc]init];
    self.chartController3.infoDict=dict;
    self.chartController3.targetType=3;
    self.chartController3.title=@"人体水份";
    self.chartController4=[[IChartViewController alloc]init];
    self.chartController4.infoDict=dict;
    self.chartController4.targetType=4;
    self.chartController4.title=@"内脏脂肪";
    self.chartController5=[[IChartViewController alloc]init];
    self.chartController5.infoDict=dict;
    self.chartController5.targetType=5;
    self.chartController5.title=@"肌肉含量";
    self.chartController6=[[IChartViewController alloc]init];
    self.chartController6.infoDict=dict;
    self.chartController6.targetType=6;
    self.chartController6.title=@"骨含量";
    self.chartController7=[[IChartViewController alloc]init];
    self.chartController7.infoDict=dict;
    self.chartController7.targetType=7;
    self.chartController7.title=@"基础代谢率";
    self.chartController8=[[IChartViewController alloc]init];
    self.chartController8.infoDict=dict;
    self.chartController8.targetType=8;
    self.chartController8.title=@"身体质量指数";
    self.chartController9=[[IChartViewController alloc]init];
    self.chartController9.infoDict=dict;
    self.chartController9.targetType=9;
    self.chartController9.title=@"皮下脂肪率";
    self.chartController10=[[IChartViewController alloc]init];
    self.chartController10.infoDict=dict;
    self.chartController10.targetType=10;
    self.chartController10.title=@"蛋白质";
    //皮下脂肪率
    [self.pageSwitchView buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfTab:(PageSwitchView *)view
{
    return 11;
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
    }else if (number==9) {
        return self.chartController9;
    }else if (number==10) {
        return self.chartController10;
    }
    return 0;
}

-(void)pageSwitchView:(PageSwitchView *)view didselectTab:(NSUInteger)number
{
    
}

@end
