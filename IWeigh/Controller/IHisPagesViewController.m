//
//  IHisPagesViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/5/27.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHisPagesViewController.h"
#import "IHisViewController.h"
#import "UIViewController+NavigationBarButton.h"


@interface IHisPagesViewController()<PageSwitchViewDelegate>

@property (nonatomic,assign)BOOL            isEdit;
@property (nonatomic,strong)PageSwitchView  *pageSwitchView;
@property (nonatomic,strong)IHisViewController*   hisController0;
@property (nonatomic,strong)IHisViewController*   hisController1;
@property (nonatomic,strong)IHisViewController*   hisController2;
@property (nonatomic,strong)IHisViewController*   hisController3;
@property (nonatomic,strong)IHisViewController*   hisController4;
@property (nonatomic,strong)IHisViewController*   hisController5;
@property (nonatomic,strong)IHisViewController*   hisController6;
@property (nonatomic,strong)IHisViewController*   hisController7;
@property (nonatomic,strong)IHisViewController*   hisController8;
@property (nonatomic,strong)IHisViewController*   hisController9;
@property (nonatomic,strong)IHisViewController*   hisController10;


@end

@implementation IHisPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarButton];
    [self setCenterTitle:@"称重历史"];
    [self addRightButtonWithTitle:@"编辑" withSel:@selector(edit:)];
    self.isEdit=NO;
    
    self.pageSwitchView=[[PageSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.pageSwitchView.pageSwitchViewDelegate=self;
    self.pageSwitchView.tabItemNormalColor=[PageSwitchView colorFromHexRGB:@"868686"];
    self.pageSwitchView.tabItemSelectedColor=[PageSwitchView colorFromHexRGB:@"45C979"];
    //    self.pageSwitchView.tabItemNormalBackgroundImage=[UIImage imageNamed:@"login_input_bg"];
    [self.view addSubview:self.pageSwitchView];
    [self.view setBackgroundColor:APP_BACKGROUND_COLOR];

    DLog(@"%f  nav Height  %f   %f",self.view.frame.size.height,self.navigationController.navigationBar.frame.size.height,self.pageSwitchView.frame.size.height);
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:self.infoDict];
    [dict setObject:[NSString stringWithFormat:@"%.0f",self.pageSwitchView.frame.size.height] forKey:@"height"];
    
    self.hisController0=[[IHisViewController alloc]init];
    [self.hisController0.view setFrame:self.pageSwitchView.frame];
    self.hisController0.infoDict=dict;
    self.hisController0.targetType=0;
    self.hisController0.title=@"体质指数";
    self.hisController1=[[IHisViewController alloc]init];
    self.hisController1.infoDict=dict;
    self.hisController1.targetType=1;
    self.hisController1.title=@"体重";
    self.hisController2=[[IHisViewController alloc]init];
    self.hisController2.infoDict=dict;
    self.hisController2.targetType=2;
    self.hisController2.title=@"脂肪率";
    self.hisController3=[[IHisViewController alloc]init];
    self.hisController3.infoDict=dict;
    self.hisController3.targetType=3;
    self.hisController3.title=@"人体水份";
    self.hisController4=[[IHisViewController alloc]init];
    self.hisController4.infoDict=dict;
    self.hisController4.targetType=4;
    self.hisController4.title=@"内脏脂肪";
    self.hisController5=[[IHisViewController alloc]init];
    self.hisController5.infoDict=dict;
    self.hisController5.targetType=5;
    self.hisController5.title=@"肌肉含量";
    self.hisController6=[[IHisViewController alloc]init];
    self.hisController6.infoDict=dict;
    self.hisController6.targetType=6;
    self.hisController6.title=@"骨含量";
    self.hisController7=[[IHisViewController alloc]init];
    self.hisController7.infoDict=dict;
    self.hisController7.targetType=7;
    self.hisController7.title=@"基础代谢率";
    self.hisController8=[[IHisViewController alloc]init];
    self.hisController8.infoDict=dict;
    self.hisController8.targetType=8;
    self.hisController8.title=@"身体质量指数";
    self.hisController9=[[IHisViewController alloc]init];
    self.hisController9.infoDict=dict;
    self.hisController9.targetType=9;
    self.hisController9.title=@"皮下脂肪率";
    self.hisController10=[[IHisViewController alloc]init];
    self.hisController10.infoDict=dict;
    self.hisController10.targetType=10;
    self.hisController10.title=@"蛋白质";
    //皮下脂肪率
    [self.pageSwitchView buildUI];
}

-(IBAction)edit:(id)sender
{
    self.isEdit=!self.isEdit;
    if (self.isEdit) {
        [self addRightButtonWithTitle:@"完成" withSel:@selector(edit:)];
        
    }else{
        [self addRightButtonWithTitle:@"编辑" withSel:@selector(edit:)];
    }
    [self.hisController0 reloadData:self.isEdit];
    [self.hisController1 reloadData:self.isEdit];
    [self.hisController2 reloadData:self.isEdit];
    [self.hisController3 reloadData:self.isEdit];
    [self.hisController4 reloadData:self.isEdit];
    [self.hisController5 reloadData:self.isEdit];
    [self.hisController6 reloadData:self.isEdit];
    [self.hisController7 reloadData:self.isEdit];
    [self.hisController8 reloadData:self.isEdit];
    [self.hisController9 reloadData:self.isEdit];
    [self.hisController10 reloadData:self.isEdit];
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
        return self.hisController0;
    }else if (number==1) {
        return self.hisController1;
    }else if (number==2) {
        return self.hisController2;
    }else if (number==3) {
        return self.hisController3;
    }else if (number==4) {
        return self.hisController4;
    }else if (number==5) {
        return self.hisController5;
    }else if (number==6) {
        return self.hisController6;
    }else if (number==7) {
        return self.hisController7;
    }else if (number==8) {
        return self.hisController8;
    }else if (number==9) {
        return self.hisController9;
    }else if (number==10) {
        return self.hisController10;
    }
    return 0;
}

-(void)pageSwitchView:(PageSwitchView *)view didselectTab:(NSUInteger)number
{
    
}


@end
