//
//  HomeViewController.m
//  IWeigh
//
//  Created by xujunwu on 14-8-30.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UIViewController+NavigationBarButton.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "StringUtil.h"
#import "MobClick.h"
#import "IScanView.h"
#import "IHomeTView.h"
#import "AccountEntity.h"
#import "WeightHisEntity.h"
#import "WeightEntity.h"
#import "ITargetViewController.h"
#import "IChartPagesViewController.h"
#import "IChartViewController.h"
#import "DBHelper.h"
#import "DBManager.h"
#import "WeightUtils.h"
#import "HomeTargetEntity.h"
#import "TargetInfoEntity.h"
#import "IHomeIView.h"
#import "IYocaViewController.h"
#import "IContentEViewController.h"
#import "IUserViewController.h"
#import "AppConfig.h"
#import "AvatarEViewController.h"

static const int kSegmentedControlWidth  = 85;


@interface HomeViewController ()<IScanViewDelegate,IHomeIViewDelegate>
{
    CLLocationManager       *locManager;
    
    NSInteger             nHeight;
    NSInteger             nAge;
    NSInteger             nSex;
    
    NSMutableArray          *hisDatas;
    NSMutableArray          *datas;
    NSInteger               nIndex;
    NSInteger               nLastIndex;
    
    NSMutableArray          *targetDatas;
    
    long                    startWeightTime;
    
}
@property (nonatomic,strong)IScanView   *scanView;
@property (nonatomic,strong)NSString*   today;

@property (nonatomic,strong)AccountEntity*  accountEntity;

@end

@implementation HomeViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title=@"主页";
        self.navigationItem.title=@"Home";
//        [self.tabBarItem setImage:[UIImage imageNamed:@"Home"]];
        //        self.tabBarItem.selectedImage=[UIImage imageNamed:@"Home_Press"];
        //        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hisDatas=[[NSMutableArray alloc]init];
    datas=[[NSMutableArray alloc]init];
    self.accountDatas=[[NSMutableArray alloc] init];
    targetDatas=[[NSMutableArray alloc] init];
    nIndex=0;
    nLastIndex=-1;
    
//    if ([CLLocationManager locationServicesEnabled]) {
//        locManager=[[CLLocationManager alloc]init];
//        locManager.delegate=self;
//        locManager.desiredAccuracy=kCLLocationAccuracyBest;
//        locManager.distanceFilter=1000;
//        if (IOS_VERSION_8_OR_ABOVE) {
////            [locManager requestAlwaysAuthorization];  //一直在后台位置服务
//            [locManager requestWhenInUseAuthorization];//使用时获取位置信息
//            
//        }
//    }
    
    [self setCenterTitle:@"Home"];
    
	// Do any additional setup after loading the view, typically from a nib.
#ifdef NAV_LEFT_MENU
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_left"] style:UIBarButtonItemStylePlain target:(INavigationController*)self.navigationController action:@selector(showMenu)];
#else
    [self addLeftTitleButton:@"切换" action:@selector(switchAccount:)];
    [self addRightTitleButton:@"分享" action:@selector(onShare:)];
#endif
    DLog(@"%f",self.tabBarController.tabBar.frame.size.height);
    
//    [self addRightButtonWithTitle:@"编辑" withSel:@selector(edit:)];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timezone];
    self.today=[formatter stringFromDate:[NSDate date]];
 
//    if (self.infoDict) {
//        [self setCenterTitle:[self.infoDict objectForKey:@"title"]];
//        int index=[[self.infoDict objectForKey:@"dataIndex"] intValue];
        NSArray *array=[[DBManager getInstance] queryAccountForType:1];
        if ([array count]>0) {
            self.accountEntity=[array objectAtIndex:0];
            [[AppConfig getInstance] setPrefValue:[NSString stringWithFormat:@"%d",self.accountEntity.aid] key:CURRENT_ACCOUNT_ID];
            if (self.accountEntity.userNick) {
                [self setCenterTitle:self.accountEntity.userNick];
            }
            nHeight=self.accountEntity.height;
            nSex= self.accountEntity.sex;
            nAge=self.accountEntity.age;
            if ([[DBManager getInstance] queryHomeTargetCountWithAId:self.accountEntity.aid]==0) {
                [self initHomeTargetInfo];
            }
        }
//        if ([self.infoDict objectForKey:@"type"]) {
//            nHeight=[[self.infoDict objectForKey:@"height"] integerValue];
//            nSex=[[self.infoDict objectForKey:@"sex"] integerValue];
//            nAge=[[self.infoDict objectForKey:@"age"] integerValue];
//        }
//    }
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.mTableView setBackgroundColor:APP_TABLEBG_COLOR];
        [self.view addSubview:self.mTableView];
    }
    
    if (self.scanView==nil) {
        self.scanView=[[IScanView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260) delegate:self];
        [self.mTableView setTableHeaderView:self.scanView];
    }
    
    [self.accountDatas removeAllObjects];
    [self.accountDatas addObjectsFromArray:[[DBManager getInstance] queryAccountForType:0]];
}

-(IBAction)onShare:(id)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"52649a7e56240b87b6169d13" shareText:@"Sholai" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects: UMShareToSina,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil] delegate:self];
}

-(IBAction)switchAccount:(id)sender
{
    UIBarButtonItem* btn=(UIBarButtonItem*)sender;
    [btn setEnabled:NO];
    __block IUserViewController* user=[[IUserViewController alloc]init];
    [user setBackBlock:^(void){
        [self removeUserView:user];
        [btn setEnabled:YES];
    }];
    
    [user setSelectBlock:^(int idx){
        [self refreshAccountData:idx];
        [self removeUserView:user];
        [btn setEnabled:YES];
    }];
    
    CATransition *catran=[CATransition animation];
    catran.type=kCATransitionPush;
    catran.subtype=kCATransitionFromLeft;
    catran.duration=0.3f;
    [user.view.layer addAnimation:catran forKey:nil];
    [self.view addSubview:user.view];
}

-(void)removeUserView:(UIViewController*)sender
{
    [UIView animateWithDuration:0.3f animations:^(void){
        [sender.view setFrame:CGRectMake(-SCREEN_WIDTH/2, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
    }];
}


-(void)refreshAccountData:(int)index
{
    
    NSArray* array=[[DBManager getInstance] queryAccountForID:index];
    if ([array count]>0) {
        self.accountEntity=[array objectAtIndex:0];
        [[AppConfig getInstance] setPrefValue:[NSString stringWithFormat:@"%d",self.accountEntity.aid] key:CURRENT_ACCOUNT_ID];
        [self setCenterTitle:self.accountEntity.userNick];
        DLog("refreshAccountData %d  %@   %d   sex:%d" ,index,self.accountEntity.userNick,self.accountEntity.height,self.accountEntity.sex);
        nHeight=self.accountEntity.height;
        nSex= self.accountEntity.sex;
        nAge=self.accountEntity.age;
        if ([[DBManager getInstance] queryHomeTargetCountWithAId:self.accountEntity.aid]==0) {
            [self initHomeTargetInfo];
        }
        [self loadHistoryData];
    }
}

-(void)initHomeTargetInfo
{
    NSArray* array=[[DBManager getInstance] queryTargetInfo];
    for (int i=0; i<[array count]; i++) {
        TargetInfoEntity* entity=[array objectAtIndex:i];
        NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%d",entity.type] forKey:@"type"];
        [dict setObject:entity.title forKey:@"title"];
        [dict setObject:entity.unit forKey:@"unit"];
        [dict setObject:[NSString stringWithFormat:@"%d",self.accountEntity.aid] forKey:@"aid"];
        if (entity.type<2) {
            [dict setObject:@"1" forKey:@"state"];
        }
        if([[DBManager getInstance] insertOrUpdateHomeTarget:dict]){
//            DLog(@"HomeTargetInfo insert or update Success.");
        }
    }
}

-(void)resetHomeTargetInfo:(WeightEntity*)weight
{
    NSArray* array=[[DBManager getInstance] queryHomeTargetWithAId:self.accountEntity.aid status:0];
    for (int i=0; i<[array count]; i++) {
        HomeTargetEntity* entity=[array objectAtIndex:i];
        NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
        switch (entity.type) {
            case 2:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.bmi] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getBMIStatus:[weight.bmi doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getBMIStatusTitle:[weight.bmi doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getBMIStatusValue:[weight.bmi doubleValue]]] forKey:@"progres"];
            }
                break;
            case 1:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.weight] forKey:@"value"];
                
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getWeightStatus:self.accountEntity.height sex:self.accountEntity.sex value:[weight.weight doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getWeightStatusTitle:self.accountEntity.height sex:self.accountEntity.sex value:[weight.weight doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getWeightStatusValue:self.accountEntity.height sex:self.accountEntity.sex value:[weight.weight doubleValue]]] forKey:@"progres"];
            }
                break;
            case 3:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.fat] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getFatStatus:self.accountEntity.age sex:self.accountEntity.sex value:[weight.fat doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getFatStatusTitle:self.accountEntity.age sex:self.accountEntity.sex value:[weight.fat doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getFatStatusValue:self.accountEntity.age sex:self.accountEntity.sex value:[weight.fat doubleValue]]] forKey:@"progres"];
            }
                break;
            case 4:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.subFat] forKey:@"value"];[dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getSufFatStatus:self.accountEntity.sex value:[weight.subFat doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getSubFatStatusTitle:self.accountEntity.sex value:[weight.subFat doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getSubFatStatusValue:self.accountEntity.sex value:[weight.subFat doubleValue]]] forKey:@"progres"];
            }
                break;
            case 5:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.visFat] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getVisFatStatus:[weight.visFat doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getVisFatStatusTitle:[weight.visFat doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getVisFatStatusValue:[weight.visFat doubleValue]]] forKey:@"progres"];
            }
                break;
            case 7:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.water] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getWaterStatus:self.accountEntity.sex value:[weight.water doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getWaterStatusTitle:self.accountEntity.sex value:[weight.water doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getWaterStatusValue:self.accountEntity.sex value:[weight.water doubleValue]]] forKey:@"progres"];
            }
                break;
            case 6:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.BMR] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getBMRStatus:self.accountEntity.age sex:self.accountEntity.sex value:[weight.BMR doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getBMRStatusTitle:self.accountEntity.age sex:self.accountEntity.sex value:[weight.BMR doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getBMRStatusValue:self.accountEntity.age sex:self.accountEntity.sex value:[weight.BMR doubleValue]]] forKey:@"progres"];
            }
                break;
            case 11:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.bodyAge] forKey:@"value"];
                [dict setObject:@"1" forKey:@"state"];
                [dict setObject:@"正常" forKey:@"valueTitle"];
                [dict setObject:@"0.50" forKey:@"progres"];
            }
                break;
            case 8:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.muscle] forKey:@"value"];[dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getMuscleStatus:self.accountEntity.height sex:self.accountEntity.sex value:[weight.muscle doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getMuscleStatusTitle:self.accountEntity.height sex:self.accountEntity.sex value:[weight.muscle doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getMuscleStatusValue:self.accountEntity.height sex:self.accountEntity.sex value:[weight.muscle doubleValue]]] forKey:@"progres"];
            }
                break;
            case 9:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.bone] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getBoneStatus:[weight.weight doubleValue] sex:self.accountEntity.sex value:[weight.bone doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getBoneStatusTitle:[weight.weight doubleValue] sex:self.accountEntity.sex value:[weight.bone doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getBoneStatusValue:[weight.weight doubleValue] sex:self.accountEntity.sex value:[weight.bone doubleValue]]] forKey:@"progres"];
            }
                break;
            case 10:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",weight.protein] forKey:@"value"];
                [dict setObject:@"1" forKey:@"state"];
                [dict setObject:@"正常" forKey:@"valueTitle"];
                [dict setObject:@"0.5" forKey:@"progres"];
            }
                break;
            default:
                break;
        }
        [dict setObject:[NSString stringWithFormat:@"%d",entity.tid] forKey:@"id"];
        [dict setObject:[NSString stringWithFormat:@"%d",self.accountEntity.aid] forKey:@"aid"];
        
        if([[DBManager getInstance] insertOrUpdateHomeTarget:dict]){
            DLog(@"HomeTargetInfo insert or update Success.");
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBLEStatusUpdate:) name:BLEDATA_RECVICE_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBLEDataReceive:) name:BLEDATA_RECVICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefresh:) name:SYNC_DATA_REFRESH object:nil];
    
    [MobClick event:@"123"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.accountEntity) {
        [self loadHistoryData];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLEDATA_RECVICE_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLEDATA_RECVICE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYNC_DATA_REFRESH object:nil];
//    if (locManager) {
//        [locManager stopUpdatingLocation];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onRefresh:(NSNotification*)notification
{
    [self loadHistoryData];
}

-(void)loadHistoryData
{
    NSInteger count=[[DBManager getInstance] queryWeightHisCountWithPicktime:self.today account:self.accountEntity.aid];
    NSArray* array=[[DBManager getInstance] queryWeightHisWithPicktime:self.today account:self.accountEntity.aid];
    if ([array count]>0) {
        [hisDatas addObjectsFromArray:array];
        WeightHisEntity *his=[hisDatas objectAtIndex:0];
        if (his!=NULL) {
            [self.scanView setWeighValue:his.weight];
        }
        if (count>0) {
            nIndex=0;
        }else{
            nIndex=-1;
        }
    }else{
        [self.scanView setFoot];
//        [self.scanView setWeighValue:@"72.5"];
    }
    
    DLog(@"%d",self.accountEntity.aid);
    
    [datas removeAllObjects];
    NSArray* array1=[[DBManager getInstance] queryWeights:self.accountEntity.aid];
    if ([array1 count]>0) {
        [datas addObjectsFromArray:array1];
    }

    if (nLastIndex>=0&&nLastIndex<[array1 count]) {
        WeightEntity* entity=[datas objectAtIndex:nLastIndex];
        if (entity!=NULL) {
            [self.scanView setWeighValue:entity.weight];
            [self.scanView setDateTitle:entity.pickTime];
        }
    }
    
    if (count>0) {
        [self loadHomeTarget];
    }
    DLog(@"............");
    [_mTableView reloadData];
}

-(void)loadHomeTarget
{
    [targetDatas removeAllObjects];
    NSArray* ary=[[DBManager getInstance] queryHomeTargetWithAId:self.accountEntity.aid status:2];
    [targetDatas addObjectsFromArray:ary];
    [self.mTableView reloadData];
}

-(void)onBLEStatusUpdate:(NSNotification*)notification
{
    NSDictionary* dict=(NSDictionary*)notification.object;
    if (dict&&[dict objectForKey:@"status"]) {
        [self.scanView setStatusValue:[dict objectForKey:@"status"]];
        if ([[dict objectForKey:@"status"] isEqualToString:@"已连接"]) {
           startWeightTime=(long)[[NSDate date] timeIntervalSince1970];
//            Byte byte[]={9,8,18,21,5,1,0,27};
//            [ApplicationDelegate writeBLEData:[[NSData alloc] initWithBytes:byte length:8] resp:true];
        }
    }
}

-(void)onBLEDataReceive:(NSNotification*)notification
{
    NSData* data=(NSData*)notification.object;
    [self dealWeightValue:data];
}

-(IBAction)edit:(id)sender
{
    IContentEViewController* dController=[[IContentEViewController alloc] init];
    dController.infoDict=self.infoDict;
    
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)dealWeightValue:(NSData* )data
{
    Byte *testByte = (Byte *)[data bytes];
    Byte total=0;
    for (int i=0; i<19; i++) {
        total+=testByte[i];
    }
    if (total!=testByte[19]) {
        DLog(@"检验码错误  %x   %x",total,testByte[19]);
        return;
    }
    
    NSString* cmd=[NSString stringWithFormat:@"%x",testByte[0]&0xff];
    if ([cmd isEqualToString:@"10"]) {
        int deviceType=testByte[2];
        int weightH=testByte[3];
        int weightL=testByte[4];
        int requestID=testByte[5];
        int fatH=testByte[6];
        int fatL=testByte[7];
        int subFatH=testByte[8];
        int subFatL=testByte[9];
        int visFat=testByte[10];
        int waterH=testByte[11];
        int waterL=testByte[12];
        int BMRH=testByte[13];
        int BMRL=testByte[14];
        int bodyAge=testByte[15];
        int muscleH=testByte[16];
        int muscleL=testByte[17];
        int bone=testByte[18];
        int total=testByte[0]+testByte[1]+deviceType+weightL+requestID+fatL+subFatL+visFat+waterL+BMRL+bodyAge+muscleL+bone;
        
//        DLog(@"%x === %x",testByte[0]+testByte[1]+testByte[2]+testByte[3]+testByte[4]+testByte[5]+testByte[6]+testByte[7]+testByte[8]+testByte[9]+testByte[10]+testByte[11]+testByte[12]+testByte[13]+testByte[14]+testByte[15]+testByte[16]+testByte[17]+testByte[18],testByte[19]);
        
        DLog(@"%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x",testByte[0]&0xff,testByte[1]&0xff,testByte[2]&0xff,testByte[3]&0xff,testByte[4]&0xff,testByte[5]&0xff,testByte[6]&0xff,testByte[7]&0xff,testByte[8]&0xff,testByte[9]&0xff,testByte[10]&0xff,testByte[11]&0xff,testByte[12]&0xff,testByte[13]&0xff,testByte[14]&0xff,testByte[15]&0xff,testByte[16]&0xff,testByte[17]&0xff,testByte[18]&0xff,testByte[19]&0xff);
//        DLog(@"cmd=%d len=%d   %d  %d %d  %d  %d  %d  %d",testByte[0],testByte[1],deviceType,weightH,weightL,requestID,testByte[19],total,(total+weightH+fatH+subFatH+waterH+BMRH+muscleH));
        float weight=((weightH*256+weightL)/5)/2/10.0;
        DLog(@"当前体重值 ===> %.1f",weight);
//        float fat=(fatH*256+fatL)/10.0;
//        if (weight<200.0) {
//            NSString * strWeight=[NSString stringWithFormat:@"%.1f",weight];
//            if (self.scanView) {
//                [self.scanView setFatValue:[NSString stringWithFormat:@"%.1f",fat]];
//                [self.scanView setWeighValue:strWeight];
//            }
//        }
        
        if (requestID==1) {
            if (self.accountEntity) {
                DLog(@"height=%d   age=%d   sex=%d",self.accountEntity.height,self.accountEntity.age,self.accountEntity.sex);
            }
            Byte byte[]={9,11,18,17,13,1,nHeight,nAge,nSex,1,0,0,0,0,0,(32+nHeight+nAge+nSex)};
            [ApplicationDelegate writeBLEData:[[NSData alloc] initWithBytes:byte length:16] resp:false];
//            [self.bleService setValue:[[NSData alloc] initWithBytes:byte length:11] forServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF1"];
        }else if(requestID==2){
            DLog(@"Fat=%.1f  SubFat=%.1f Water=%.1f BMR=%.1f Muscle=%.1f",(fatH*256+fatL)/10.0,(subFatH*256+subFatL)/10.0,(waterH*256+waterL)/10.0,(BMRH*256+BMRL)/10.0,(muscleH*256+muscleL)/10.0);
            NSString * strWeight=[NSString stringWithFormat:@"%.1f",weight];
            if (self.scanView) {
                [self.scanView setWeighValue:strWeight];
            }
            long endTime=(long)[[NSDate date] timeIntervalSince1970];
            DLog(@"-------------------------%ld#############################",(startWeightTime-endTime));
            if ((endTime-startWeightTime)>2) {
                startWeightTime=endTime;
                NSMutableDictionary *entity=[[NSMutableDictionary alloc] init];
                [entity setObject:self.today forKey:@"pickTime"];
                if (self.accountEntity) {
                    [entity setObject:[NSString stringWithFormat:@"%d",self.accountEntity.aid] forKey:@"aid"];
                    float height=powf(self.accountEntity.height/100.0,2.0);
                    [entity setObject:[NSString stringWithFormat:@"%.1f",weight/height] forKey:@"bmi"];
                }else{
                    [entity setObject:@"1" forKey:@"aid"];
                }
                [entity setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"wid"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",weight] forKey:@"weight"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",(fatH*256+fatL)/10.0] forKey:@"fat"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",(subFatH*256+subFatL)/10.0] forKey:@"subFat"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",visFat/10.0] forKey:@"visFat"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",(waterH*256+waterL)/10.0] forKey:@"water"];
                [entity setObject:[NSString stringWithFormat:@"%d",(BMRH*256+BMRL)] forKey:@"BMR"];
                [entity setObject:[NSString stringWithFormat:@"%d",bodyAge] forKey:@"bodyAge"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",(muscleH*256+muscleL)/10.0] forKey:@"muscle"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",bone/10.0] forKey:@"bone"];
                [entity setObject:[NSString stringWithFormat:@"%.1f",((muscleH*256+muscleL)/10.0)*0.27+0.02*((fatH*256+fatL)/10.0)] forKey:@"protein"];
                [entity setObject:@"0" forKey:@"sholai"];
                [entity setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"addtime"];
                if ([[DBManager getInstance] insertOrUpdateWeightHis:entity]){
                    DLog(@"insertOrUpdateWeightHis success");
                    [self updateWeightData:entity];
                    [entity setObject:@"syncweighthis" forKey:@"requestUrl"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_WEIGHT_NOTIFICATION object:entity];
                }
                [self countData:entity];
            }
            
            //10h =>16  14h=>20
            Byte byte[]={9,11,18,31,5,1,16,53};
            [ApplicationDelegate writeBLEData:[[NSData alloc]initWithBytes:byte length:8] resp:false];
//            [self.bleService setValue:[[NSData alloc] initWithBytes:byte length:11] forServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF1"];
        }
    }
}

-(void)updateWeightData:(NSMutableDictionary*)dict
{
    NSArray* array=[[DBManager getInstance] queryWeightHisWithWeight:[dict objectForKey:@"pickTime"] account:[[dict objectForKey:@"aid"] integerValue]];
    if ([array count]>0) {
        WeightEntity * entity=[array objectAtIndex:0];
        
        NSArray* a=[[DBManager getInstance] queryWeightWithPicktime:[dict objectForKey:@"pickTime"] account:[[dict objectForKey:@"aid"] integerValue]];
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        [params setObject:entity.weight forKey:@"weight"];
        [params setObject:entity.fat forKey:@"fat"];
        [params setObject:entity.subFat forKey:@"subFat"];
        [params setObject:entity.BMR forKey:@"BMR"];
        [params setObject:entity.bmi forKey:@"bmi"];
        [params setObject:entity.water forKey:@"water"];
        [params setObject:entity.bodyAge forKey:@"bodyAge"];
        [params setObject:entity.muscle forKey:@"muscle"];
        [params setObject:entity.bone forKey:@"bone"];
        [params setObject:entity.protein forKey:@"protein"];
        [params setObject:entity.visFat forKey:@"visFat"];
        [params setObject:[dict objectForKey:@"aid"] forKey:@"aid"];
        [params setObject:[dict objectForKey:@"pickTime"] forKey:@"pickTime"];
        if ([a count]>0) {
            WeightEntity *we=[a objectAtIndex:0];
            [params setObject:[NSString stringWithFormat:@"%d",we.wid] forKey:@"wid"];
            
        }else{
            [params setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"wid"];
        }
        [params setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"addtime"];
        if ([[DBManager getInstance] insertOrUpdateWeight:params]) {
            [params setObject:@"syncweight" forKey:@"requestUrl"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_WEIGHT_NOTIFICATION object:params];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.accountEntity&&self.accountEntity.targetType<0) {
        return 1;
    }
    return [targetDatas count]+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 80;
    }
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    if (indexPath.row==0) {
        if (self.accountEntity&&self.accountEntity.targetType<0) {
            UIImageView* edit=[[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 36, 36)];
            [edit setContentMode:UIViewContentModeScaleAspectFill];
            [edit setImage:[UIImage imageNamed:@"edit"]];
            [cell addSubview:edit];
            
            UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(60, (50-26)/2, 200, 26)];
            [lb setText:@"目标未设置,点击设置"];
            [lb setFont:[UIFont boldSystemFontOfSize:16.0f]];
            [cell addSubview:lb];
        }else{
            IHomeTView* item=[[IHomeTView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
            [item setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"weight",self.accountEntity.targetWeight,@"targetWeight",self.accountEntity.doneTime,@"doneTime", nil]];
            [cell addSubview:item];
            
        }
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 79.5, bounds.size.width, 0.5)];
        [img setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:img];
        [cell sendSubviewToBack:img];
    }else{
        if (indexPath.row<=[targetDatas count]) {
            HomeTargetEntity* entity=[targetDatas objectAtIndex:indexPath.row-1];
            NSMutableDictionary * dict=[NSMutableDictionary dictionary];
            [dict setObject:entity.title forKey:@"title"];
            if (entity.unit) {
                [dict setObject:entity.unit forKey:@"unit"];
            }
            if (entity.value) {
                [dict setObject:entity.value forKey:@"value"];
            }
            if (entity.state) {
                [dict setObject:[NSString stringWithFormat:@"%d",entity.state] forKey:@"state"];
            }
            if (entity.valueTitle){
                [dict setObject:entity.valueTitle forKey:@"valueTitle"];
            }
            if (entity.progres) {
                [dict setObject:entity.progres forKey:@"progres"];
            }
            
//            [dict setObject:@"1" forKey:@"isChart"];
            IHomeIView* item=[[IHomeIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 70) delegate:self];
            [item setInfoDict:dict];
            [cell addSubview:item];
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        if (self.accountEntity&&self.accountEntity.targetType==0) {
            ITargetViewController* dController=[[ITargetViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.accountEntity.aid],@"dataIndex", nil];
            [self.navigationController pushViewController:dController animated:YES];
        }
    }
}


#pragma mark - IScanViewDelegate
-(void)onScanViewShared:(IScanView *)view
{
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"52649a7e56240b87b6169d13" shareText:@"分享文件" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects: UMShareToSina,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil] delegate:self];
    AvatarEViewController *dController=[[AvatarEViewController alloc]init];
    dController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)onScanViewSelected:(UIButton *)btn
{
    if (self.scanView) {
        if(btn.tag==100){
            nIndex++;
            if (nIndex>=[datas count]) {
                nIndex=[datas count]-1;
            }
            if ([datas count]>0&&nIndex>=0&&nIndex<[datas count]) {
                WeightEntity* entity=[datas objectAtIndex:nIndex];
                if (entity!=NULL) {
                    [self.scanView setDateTitle:[NSString stringWithFormat:@"%@",entity.pickTime]];
                    [self.scanView setWeighValue:[NSString stringWithFormat:@"%.1f",[entity.weight floatValue]]];
                    [self resetHomeTargetInfo:entity];
                    [self loadHomeTarget];
                }
            }
            nLastIndex=nIndex;
        }else{
            nIndex--;
            if (nIndex<0) {
                nIndex=0;
                [self.scanView setDateTitle:@"今日"];
                if ([datas count]>0) {
                    WeightEntity *entity=[datas objectAtIndex:nIndex];
                    if (entity!=NULL) {
                        if ([entity.pickTime isEqualToString:self.today]) {
                            [self.scanView setWeighValue:entity.weight];
                            [self resetHomeTargetInfo:entity];
                            [self loadHomeTarget];
                        }else{
                            [self.scanView setFoot];
                        }
                    }
                }
            }else{
                WeightEntity* entity=[datas objectAtIndex:nIndex];
                if (entity!=NULL) {
                    if ([entity.pickTime isEqualToString:self.today]) {
                        [self.scanView setDateTitle:@"今日"];
                    }else{
                        [self.scanView setDateTitle:[NSString stringWithFormat:@"%@",entity.pickTime]];
                    }
                    [self.scanView setWeighValue:[NSString stringWithFormat:@"%.1f",[entity.weight floatValue]]];
                    [self resetHomeTargetInfo:entity];
                    [self loadHomeTarget];
                    DLog(@"%@  %@",entity.pickTime,entity.weight);
                }
            }
            nLastIndex=nIndex;
        }
    }
}

-(void)onScanViewClicked:(IScanView *)view
{
//    IYocaViewController* dController=[[IYocaViewController alloc]init];
//    dController.infoDict=self.infoDict;
//    [self.navigationController pushViewController:dController animated:YES];
}

-(void)onChartClicked:(IHomeIView *)view
{
    IChartPagesViewController* dController=[[IChartPagesViewController alloc]init];
    dController.infoDict=self.infoDict;
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)countData:(NSDictionary*)aDict
{
    NSArray* array=[[DBManager getInstance] queryHomeTargetWithAId:self.accountEntity.aid status:0];
    for (int i=0; i<[array count]; i++) {
        HomeTargetEntity* entity=[array objectAtIndex:i];
        NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
        switch (entity.type) {
            case 2:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"bmi"]] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getBMIStatus:[[aDict objectForKey:@"bmi"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getBMIStatusTitle:[[aDict objectForKey:@"bmi"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getBMIStatusValue:[[aDict objectForKey:@"bmi"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 1:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"weight"]] forKey:@"value"];
                
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getWeightStatus:self.accountEntity.height sex:self.accountEntity.sex value:[[aDict objectForKey:@"weight"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getWeightStatusTitle:self.accountEntity.height sex:self.accountEntity.sex value:[[aDict objectForKey:@"weight"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getWeightStatusValue:self.accountEntity.height sex:self.accountEntity.sex value:[[aDict objectForKey:@"weight"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 3:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"fat"]] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getFatStatus:self.accountEntity.age sex:self.accountEntity.sex value:[[aDict objectForKey:@"fat"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getFatStatusTitle:self.accountEntity.age sex:self.accountEntity.sex value:[[aDict objectForKey:@"fat"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getFatStatusValue:self.accountEntity.age sex:self.accountEntity.sex value:[[aDict objectForKey:@"fat"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 4:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"subFat"]] forKey:@"value"];[dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getSufFatStatus:self.accountEntity.sex value:[[aDict objectForKey:@"subFat"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getSubFatStatusTitle:self.accountEntity.sex value:[[aDict objectForKey:@"subFat"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getSubFatStatusValue:self.accountEntity.sex value:[[aDict objectForKey:@"subFat"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 5:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"visFat"]] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getVisFatStatus:[[aDict objectForKey:@"visFat"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getVisFatStatusTitle:[[aDict objectForKey:@"visFat"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getVisFatStatusValue:[[aDict objectForKey:@"visFat"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 7:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"water"]] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getWaterStatus:self.accountEntity.sex value:[[aDict objectForKey:@"water"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getWaterStatusTitle:self.accountEntity.sex value:[[aDict objectForKey:@"water"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getWaterStatusValue:self.accountEntity.sex value:[[aDict objectForKey:@"water"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 6:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"BMR"]] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getBMRStatus:self.accountEntity.age sex:self.accountEntity.sex value:[[aDict objectForKey:@"BMR"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getBMRStatusTitle:self.accountEntity.age sex:self.accountEntity.sex value:[[aDict objectForKey:@"BMR"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getBMRStatusValue:self.accountEntity.age sex:self.accountEntity.sex value:[[aDict objectForKey:@"BMR"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 11:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"bodyAge"]] forKey:@"value"];
                [dict setObject:@"1" forKey:@"state"];
                [dict setObject:@"正常" forKey:@"valueTitle"];
                [dict setObject:@"0.50" forKey:@"progres"];
            }
                break;
            case 8:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"muscle"]] forKey:@"value"];[dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getMuscleStatus:self.accountEntity.height sex:self.accountEntity.sex value:[[aDict objectForKey:@"muscle"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getMuscleStatusTitle:self.accountEntity.height sex:self.accountEntity.sex value:[[aDict objectForKey:@"muscle"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getMuscleStatusValue:self.accountEntity.height sex:self.accountEntity.sex value:[[aDict objectForKey:@"muscle"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 9:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"bone"]] forKey:@"value"];
                [dict setObject:[NSString stringWithFormat:@"%d",[WeightUtils getBoneStatus:[[aDict objectForKey:@"weight"] doubleValue] sex:self.accountEntity.sex value:[[aDict objectForKey:@"bone"] doubleValue]]] forKey:@"state"];
                [dict setObject:[NSString stringWithFormat:@"%@",[WeightUtils getBoneStatusTitle:[[aDict objectForKey:@"weight"] doubleValue] sex:self.accountEntity.sex value:[[aDict objectForKey:@"bone"] doubleValue]]] forKey:@"valueTitle"];
                [dict setObject:[NSString stringWithFormat:@"%f",[WeightUtils getBoneStatusValue:[[aDict objectForKey:@"weight"] doubleValue] sex:self.accountEntity.sex value:[[aDict objectForKey:@"bone"] doubleValue]]] forKey:@"progres"];
            }
                break;
            case 10:
            {
                [dict setObject:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"protein"]] forKey:@"value"];
                [dict setObject:@"1" forKey:@"state"];
                [dict setObject:@"正常" forKey:@"valueTitle"];
                [dict setObject:@"0.5" forKey:@"progres"];
            }
                break;
            default:
                break;
        }
        [dict setObject:[NSString stringWithFormat:@"%d",entity.tid] forKey:@"id"];
        [dict setObject:[NSString stringWithFormat:@"%d",self.accountEntity.aid] forKey:@"aid"];
        if([[DBManager getInstance] insertOrUpdateHomeTarget:dict]){
            DLog(@"HomeTargetInfo insert or update Success.");
        }
    }
    [self loadHomeTarget];
}

#pragma mark -- LocationManager
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    DLog(@"%d",status);
    if (status==kCLAuthorizationStatusAuthorizedAlways||status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        DLog(@"Authorized...");
        [locManager startUpdatingLocation];
    }else if(status==kCLAuthorizationStatusDenied||status==kCLAuthorizationStatusRestricted){
        DLog(@"Denied");
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DLog(@"%@",locations);
}

@end
