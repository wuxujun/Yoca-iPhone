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
#import "INavigationController.h"
#import "StringUtil.h"
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
#import "HomeTargetEntity.h"
#import "TargetInfoEntity.h"
#import "IHomeIView.h"
#import "IYocaViewController.h"
#import "IContentEViewController.h"

@interface HomeViewController ()<IScanViewDelegate,IHomeIViewDelegate>
{
    CLLocationManager       *locManager;
    
    BLEManager*     bleManager;
    
    NSInteger             nHeight;
    NSInteger             nAge;
    NSInteger             nSex;
    
    NSMutableArray          *datas;
    NSInteger               nIndex;
    
    NSMutableArray          *targetDatas;
    
}
@property (nonatomic,strong)IScanView   *scanView;
@property (nonatomic,strong)NSString*   today;

@property (nonatomic,strong)AccountEntity*  accountEntity;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    datas=[[NSMutableArray alloc]init];
    targetDatas=[[NSMutableArray alloc] init];
    nIndex=0;
    
    if ([CLLocationManager locationServicesEnabled]) {
        locManager=[[CLLocationManager alloc]init];
        locManager.delegate=self;
        locManager.desiredAccuracy=kCLLocationAccuracyBest;
        locManager.distanceFilter=1000;
        if (IOS_VERSION_8_OR_ABOVE) {
            [locManager requestAlwaysAuthorization];
        }
    }
    
    [self setCenterTitle:@"Home"];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_left"] style:UIBarButtonItemStylePlain target:(INavigationController*)self.navigationController action:@selector(showMenu)];
    
    [self addRightButtonWithTitle:@"编辑" withSel:@selector(edit:)];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timezone];
    self.today=[formatter stringFromDate:[NSDate date]];

//    bleManager=[BLEManager getInstance];
//    [bleManager controlSetup:1];
//    bleManager.deleagte=self;
    
    if (self.infoDict) {
        [self setCenterTitle:[self.infoDict objectForKey:@"title"]];
        int index=[[self.infoDict objectForKey:@"dataIndex"] intValue];
        NSArray *array=[[DBManager getInstance] queryAccountForID:index];
        if ([array count]>0) {
            self.accountEntity=[array objectAtIndex:0];
            nHeight=self.accountEntity.height;
            nSex= self.accountEntity.sex;
            nAge=self.accountEntity.age;
            if ([[DBManager getInstance] queryHomeTargetCountWithAId:self.accountEntity.aid]==0) {
                [self initHomeTargetInfo];
            }
        }
        if ([self.infoDict objectForKey:@"type"]) {
            nHeight=[[self.infoDict objectForKey:@"height"] integerValue];
            nSex=[[self.infoDict objectForKey:@"sex"] integerValue];
            nAge=[[self.infoDict objectForKey:@"age"] integerValue];
        }
    }
    
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
    
}

-(void)initHomeTargetInfo
{
    NSArray* array=[[DBManager getInstance] queryTargetInfo];
    for (int i=0; i<[array count]; i++) {
        TargetInfoEntity* entity=[array objectAtIndex:i];
        NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld",entity.type] forKey:@"type"];
        [dict setObject:entity.title forKey:@"title"];
        [dict setObject:entity.unit forKey:@"unit"];
        [dict setObject:[NSString stringWithFormat:@"%ld",self.accountEntity.aid] forKey:@"aid"];
        if (entity.type<2) {
            [dict setObject:@"1" forKey:@"state"];
        }
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
    [self countData];
//    if (bleManager.activePeripheral.isConnected) {
//        return;
//    }
//    if (bleManager.peripherals) {
//        bleManager.peripherals=nil;
//    }
//    [bleManager findBLEPeripherals:5];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [locManager startUpdatingLocation];
    if ([self.infoDict objectForKey:@"dataIndex"]) {
        [self loadHistoryData];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLEDATA_RECVICE_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLEDATA_RECVICE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYNC_DATA_REFRESH object:nil];
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
    NSInteger count=[[DBManager getInstance] queryWeightCountWithPicktime:self.today account:self.accountEntity.aid];
    NSArray* array=[[DBManager getInstance] queryWeightWithPicktime:self.today account:self.accountEntity.aid];
    if ([array count]>0) {
        [datas addObjectsFromArray:array];
        
        WeightHisEntity *his=[datas objectAtIndex:0];
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

    if (count>0) {
        [targetDatas removeAllObjects];
        NSArray* ary=[[DBManager getInstance] queryHomeTargetWithAId:self.accountEntity.aid status:1];
        [targetDatas addObjectsFromArray:ary];
        [self.mTableView reloadData];
    }
}

-(void)onBLEStatusUpdate:(NSNotification*)notification
{
    NSDictionary* dict=(NSDictionary*)notification.object;
    if (dict&&[dict objectForKey:@"status"]) {
        [self.scanView setStatusValue:[dict objectForKey:@"status"]];
    }
}

-(void)onBLEDataReceive:(NSNotification*)notification
{
    NSData* data=(NSData*)notification.object;
    [self.scanView setNum:888];
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
    DLog(@"检验码正确 %x======%x",total,testByte[19]);
    
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
        
        DLog(@"%x === %x",testByte[0]+testByte[1]+testByte[2]+testByte[3]+testByte[4]+testByte[5]+testByte[6]+testByte[7]+testByte[8]+testByte[9]+testByte[10]+testByte[11]+testByte[12]+testByte[13]+testByte[14]+testByte[15]+testByte[16]+testByte[17]+testByte[18],testByte[19]);
        DLog(@"%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x",testByte[0]&0xff,testByte[1]&0xff,testByte[2]&0xff,testByte[3]&0xff,testByte[4]&0xff,testByte[5]&0xff,testByte[6]&0xff,testByte[7]&0xff,testByte[8]&0xff,testByte[9]&0xff,testByte[10]&0xff,testByte[11]&0xff,testByte[12]&0xff,testByte[13]&0xff,testByte[14]&0xff,testByte[15]&0xff,testByte[16]&0xff,testByte[17]&0xff,testByte[18]&0xff,testByte[19]&0xff);
//        DLog(@"cmd=%d len=%d   %d  %d %d  %d  %d  %d  %d",testByte[0],testByte[1],deviceType,weightH,weightL,requestID,testByte[19],total,(total+weightH+fatH+subFatH+waterH+BMRH+muscleH));
        float weight=(weightH*256+weightL)/10.0;
//        float fat=(fatH*256+fatL)/10.0;
        if (weight<200.0) {
            NSString * strWeight=[NSString stringWithFormat:@"%.1f",weight];
            if (self.scanView) {
//                [self.scanView setFatValue:[NSString stringWithFormat:@"%.1f",fat]];
                [self.scanView setWeighValue:strWeight];
            }
        }
        
        if (requestID==1) {
            if (self.accountEntity) {
                DLog(@"height=%d   age=%d   sex=%d",self.accountEntity.height,self.accountEntity.age,self.accountEntity.sex);
            }
            Byte byte[]={9,11,18,17,8,1,nHeight,nAge,nSex,1,(27+nHeight+nAge+nSex)};
            [ApplicationDelegate writeBLEData:[[NSData alloc]initWithBytes:byte length:11]];
//            [self.bleService setValue:[[NSData alloc] initWithBytes:byte length:11] forServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF1"];
        }else if(requestID==2){
            DLog(@"Fat:%d %d  SubFat:%d %d VisFat:%d Water:%d %d BMRH:%d %d BodyAge:%d  Muscle:%d  %d  Bone:%d",fatH,fatL,subFatH,subFatL,visFat,waterH,waterL,BMRH,BMRL,bodyAge,muscleH,muscleL,bone);
            DLog(@"Fat=%.1f  SubFat=%.1f Water=%.1f BMR=%.1f Muscle=%.1f",(fatH*256+fatL)/10.0,(subFatH*256+subFatL)/10.0,(waterH*256+waterL)/10.0,(BMRH*256+BMRL)/10.0,(muscleH*256+muscleL)/10.0);
            
            NSMutableDictionary *entity=[[NSMutableDictionary alloc] init];
            [entity setObject:self.today forKey:@"picktime"];
            if (self.accountEntity) {
                [entity setObject:[NSString stringWithFormat:@"%d",self.accountEntity.aid] forKey:@"aid"];
                float height=powf(self.accountEntity.height/100.0,2.0);
                [entity setObject:[NSString stringWithFormat:@"%.1f",weight/height] forKey:@"bmi"];
            }else{
                [entity setObject:@"1" forKey:@"aid"];
            }
            [entity setObject:[NSString stringWithFormat:@"%.1f",weight] forKey:@"weight"];
            
            [entity setObject:[NSString stringWithFormat:@"%.1f",(fatH*256+fatL)/10.0] forKey:@"fat"];
            [entity setObject:[NSString stringWithFormat:@"%.1f",(subFatH*256+subFatL)/10.0] forKey:@"subFat"];
            [entity setObject:[NSString stringWithFormat:@"%d",visFat] forKey:@"visFat"];
            [entity setObject:[NSString stringWithFormat:@"%.1f",(waterH*256+waterL)/10.0] forKey:@"water"];
            [entity setObject:[NSString stringWithFormat:@"%.1f",(BMRH*256+BMRL)/10.0] forKey:@"BMR"];
            [entity setObject:[NSString stringWithFormat:@"%d",bodyAge] forKey:@"bodyAge"];
            [entity setObject:[NSString stringWithFormat:@"%.1f",(muscleH*256+muscleL)/10.0] forKey:@"muscle"];
            [entity setObject:[NSString stringWithFormat:@"%.1f",bone/10.0] forKey:@"bone"];
            [entity setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"addtime"];
            DLog(@"%@",entity);
            [[DBManager getInstance] insertOrUpdateWeightHis:entity];
            
//            [self countData];
            
            //10h =>16  14h=>20
            Byte byte[]={9,11,18,31,5,1,16,53};
            [ApplicationDelegate writeBLEData:[[NSData alloc]initWithBytes:byte length:8]];
//            [self.bleService setValue:[[NSData alloc] initWithBytes:byte length:11] forServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF1"];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.accountEntity&&self.accountEntity.targetType==0) {
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
        if (self.accountEntity&&self.accountEntity.targetType==0) {
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
    }else{
        if (indexPath.row<=[targetDatas count]) {
            HomeTargetEntity* entity=[targetDatas objectAtIndex:indexPath.row-1];
            NSMutableDictionary * dict=[NSMutableDictionary dictionary];
            [dict setObject:entity.title forKey:@"title"];
            if (entity.unit) {
                [dict setObject:entity.unit forKey:@"unit"];
            }
            [dict setObject:@"正常" forKey:@"status"];
            IHomeIView* item=[[IHomeIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 70) delegate:self];
            [item setInfoDict:dict];
            [cell addSubview:item];
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
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.accountEntity.aid],@"dataIndex", nil];
            [self.navigationController pushViewController:dController animated:YES];
        }
    }
}


#pragma mark - IScanViewDelegate
-(void)onScanViewShared:(IScanView *)view
{
    
}

-(void)onScanViewSelected:(UIButton *)btn
{
    if (self.scanView) {
        if(btn.tag==100){
            nIndex++;
            if (nIndex>[datas count]) {
                nIndex=[datas count]-1;
            }
            if ([datas count]>0&&nIndex>=0) {
                WeightEntity* entity=[datas objectAtIndex:nIndex];
                if (entity!=NULL) {
                    [self.scanView setDateTitle:[NSString stringWithFormat:@"%@",entity.picktime]];
                    [self.scanView setWeighValue:entity.weight];
                }
            }
        }else{
            nIndex--;
            if (nIndex<0) {
                nIndex=0;
                [self.scanView setDateTitle:@"今日"];
            }else{
                WeightEntity* entity=[datas objectAtIndex:nIndex];
                if (entity!=NULL) {
                    if ([entity.picktime isEqualToString:self.today]) {
                        [self.scanView setDateTitle:@"今日"];
                    }else{
                        [self.scanView setDateTitle:[NSString stringWithFormat:@"%@",entity.picktime]];
                    }
                    [self.scanView setWeighValue:entity.weight];
                }
            }
        }
    }
}

-(void)onScanViewClicked:(IScanView *)view
{
    IYocaViewController* dController=[[IYocaViewController alloc]init];
    dController.infoDict=self.infoDict;
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)onChartClicked:(IHomeIView *)view
{
    
}

-(void)countData
{
    
//    WeightHisEntity* entity=[WeightHisEntity MR_findFirstWithPredicate:[NSPredicate predicateWithValue:YES] sortedBy:@"wid" ascending:NO];
//    if (entity) {
//        [self.accountEntity setWeight:entity.weight];
//        [self.accountEntity setFat:entity.fat];
//        [self.accountEntity setSubFat:entity.subFat];
//        [self.accountEntity setVisFat:entity.visFat];
//        [self.accountEntity setWater:entity.water];
//        [self.accountEntity setBmr:entity.bmr];
//        [self.accountEntity setBodyAge:entity.bodyAge];
//        [self.accountEntity setMuscle:entity.muscle];
//        [self.accountEntity setBone:entity.bone];
//        
//        [self.scanView setWeighValue:entity.weight];
//        
//        [self.mTableView reloadData];
//    }
}


-(void)BLEConnected:(NSString *)uuid
{
    DLog(@"%@",uuid);
}

-(void)BLEDisConnected
{
    if (bleManager.activePeripheral.isConnected) {
        [[bleManager CM] cancelPeripheralConnection:bleManager.activePeripheral];
        bleManager.activePeripheral=nil;
    }
}

-(void)BLEValueUpdated:(char)value
{
    DLog(@"%c",value);
}


#pragma mark -- LocationManager
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    DLog(@"%d",status);
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
