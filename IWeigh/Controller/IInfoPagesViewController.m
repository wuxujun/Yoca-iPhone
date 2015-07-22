//
//  IInfoPagesViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/6/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IInfoPagesViewController.h"
#import "IInfoViewController.h"
#import "UIViewController+NavigationBarButton.h"


@interface IInfoPagesViewController()<PageSwitchViewDelegate>

@property (nonatomic,assign)BOOL            isEdit;
@property (nonatomic,strong)PageSwitchView  *pageSwitchView;
@property (nonatomic,strong)IInfoViewController*   infoController0;
@property (nonatomic,strong)IInfoViewController*   infoController1;


@end

@implementation IInfoPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarButton];
    [self setCenterTitle:@"健康资讯"];
    
    self.pageSwitchView=[[PageSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.pageSwitchView.pageSwitchViewDelegate=self;
    self.pageSwitchView.tabItemNormalColor=[PageSwitchView colorFromHexRGB:@"868686"];
    self.pageSwitchView.tabItemSelectedColor=[PageSwitchView colorFromHexRGB:@"45C979"];
    //    self.pageSwitchView.tabItemNormalBackgroundImage=[UIImage imageNamed:@"login_input_bg"];
    [self.view addSubview:self.pageSwitchView];
    [self.view setBackgroundColor:APP_BACKGROUND_COLOR];
    
    DLog(@"%f  nav Height  %f   %f",self.view.frame.size.height,self.navigationController.navigationBar.frame.size.height,self.pageSwitchView.frame.size.height);
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%.0f",self.pageSwitchView.frame.size.height] forKey:@"height"];
    
    self.infoController0=[[IInfoViewController alloc]init];
    [self.infoController0.view setFrame:self.pageSwitchView.frame];
//    self.infoController0.infoDict=dict;
    self.infoController0.dataType=0;
    self.infoController0.title=@"健康信息";
    self.infoController1=[[IInfoViewController alloc]init];
//    self.infoController1.infoDict=dict;
    self.infoController1.dataType=1;
    self.infoController1.title=@"减肥资讯";
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
        return self.infoController0;
    }else if (number==1) {
        return self.infoController1;
    }
    return 0;
}

-(void)pageSwitchView:(PageSwitchView *)view didselectTab:(NSUInteger)number
{
    
}

@end
