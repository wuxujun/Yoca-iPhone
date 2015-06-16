//
//  ITargetViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "ITargetViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "HKeyboardTableView.h"
#import "ISegmentView.h"
#import "TargetHeadView.h"
#import "DBManager.h"
#import "AccountEntity.h"
#import "StringUtil.h"


@interface ITargetViewController ()<ISegmentViewDelegate,UITextFieldDelegate,TargetHeadViewDelegate,UIActionSheetDelegate>
{
    int         currentType;
    
    NSInteger       aid;
    
    NSInteger       targetType;
    NSString*       doneDate;
    float           sliderValue;
}


@property (nonatomic,strong)TargetHeadView   *headView;

@end

@implementation ITargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarButton];
    [self setCenterTitle:@"目标设置"];
    [self addRightButtonWithTitle:@"保存" withSel:@selector(save)];
    targetType=0;
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if (self.headView==nil) {
        self.headView=[[TargetHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) delegate:self];
        [self.mTableView setTableHeaderView:self.headView];
    }
    if ([self.infoDict objectForKey:@"dataIndex"]) {
        
        NSArray* array=[[DBManager getInstance] queryAccountForID:[[self.infoDict objectForKey:@"dataIndex"] integerValue]];
        if ([array count]>0) {
            AccountEntity* localAccount=[array objectAtIndex:0];
            [self.headView setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",localAccount.height],@"height", [NSString stringWithFormat:@"%d",localAccount.sex],@"sex",nil]];
            if (localAccount.sex==0) {
                sliderValue=(localAccount.height-100)/100.0;
            }else{
                sliderValue=(localAccount.height-105)/100.0;
            }
            aid=localAccount.aid;
            targetType=localAccount.targetType;
            doneDate=localAccount.doneTime;
            sliderValue=[localAccount.targetWeight floatValue]/100.0;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save
{
    if (doneDate==nil) {
        [self alertRequestResult:@"请选择达成日期" isPop:NO];
        return;
    }
    NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d",aid] forKey:@"id"];
    [dict setValue:[NSString stringWithFormat:@"%d",targetType] forKey:@"targetType"];
    [dict setValue:[NSString stringWithFormat:@"%.1f",sliderValue*100.0]  forKey:@"targetWeight"];
    [dict setValue:[NSString stringWithFormat:@"%@",doneDate] forKey:@"doneTime"];
    
    if ([[DBManager getInstance] insertOrUpdateAccount:dict]) {
        [self alertRequestResult:@"目标设置成功" isPop:YES];
    }else{
        [self alertRequestResult:@"保存失败!" isPop:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 80;
        case 1:
            return 88;
        case 2:
            return 120;
        default:
            return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    
    switch (indexPath.row) {
        case 0:
        {
            NSArray* types=@[@"减重",@"减脂",@"保持"];
            ISegmentView* segmentView=[[ISegmentView alloc]initWithFrame:CGRectMake(5, (80-44)/2, bounds.size.width-10, 44) items:types];
            [segmentView selectForItem:currentType];
            segmentView.tintColor=[UIColor grayColor];
            segmentView.delegate=self;
            [cell addSubview:segmentView];
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 79.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
        }
            break;
        case 1:
        {
            UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 26)];
            [label setText:@"希望体重:"];
            [label setTextColor:APP_FONT_COLOR];
            [cell addSubview:label];
            
            self.setValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 36)];
            [self.setValueLabel setTextColor:APP_FONT_COLOR_SEL];
            [self.setValueLabel setFont:[UIFont boldSystemFontOfSize:26.0f]];
            
            [cell addSubview:self.setValueLabel];
            
            UISlider *slider=[[UISlider alloc]initWithFrame:CGRectMake(40, 80-30, bounds.size.width-80, 20)];
            [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
            if (sliderValue) {
                [slider setValue:sliderValue];
                [self.setValueLabel setText:[NSString stringWithFormat:@"%.1f",sliderValue*100]];
            }
            [cell addSubview:slider];
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 87.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
        }
            break;
        case 2:
        {
            UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 26)];
            [label setText:@"达成日期:"];
            [label setTextColor:APP_FONT_COLOR];
            [cell addSubview:label];
            
            self.doneDateBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, 39.5, bounds.size.width-39, 37)];
            [self.doneDateBG setBackgroundColor:APP_FONT_COLOR];
            [self.doneDateBG.layer setMasksToBounds:YES];
            [self.doneDateBG.layer setCornerRadius:5];
            [cell addSubview:self.doneDateBG];
            
            self.doneDateField =[[UITextField alloc] initWithFrame:CGRectMake(20, 40, bounds.size.width-40, 36)];
            [self.doneDateField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.doneDateField setTextColor:APP_FONT_COLOR];
            [self.doneDateField setPlaceholder:@"请输入完成日期"];
            [self.doneDateField setBorderStyle:UITextBorderStyleNone];
            [self.doneDateField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.doneDateField setReturnKeyType:UIReturnKeyDone];
            [self.doneDateField setKeyboardType:UIKeyboardTypeDefault];
            [self.doneDateField.layer setMasksToBounds:YES];
            [self.doneDateField.layer setCornerRadius:5.0];
            [self.doneDateField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            [self.doneDateField endEditing:NO];
            [self.doneDateField addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventEditingDidBegin];
            if (doneDate) {
                [self.doneDateField setText:doneDate];
            }
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.doneDateField.frame;
            frame.size.width=8;
            [leftView setFrame:frame];
            self.doneDateField.leftViewMode=UITextFieldViewModeAlways;
            self.doneDateField.leftView=leftView;
            
            [self.doneDateField setDelegate:self];
            
            [cell addSubview:self.doneDateField];
            
        }
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(IBAction)slider:(id)sender
{
    UISlider* sl=(UISlider*)sender;
    DLog(@"%f",sl.value);
    sliderValue=sl.value;
    [self.setValueLabel setText:[NSString stringWithFormat:@"%.1f",(sl.value)*100]];
}

-(void)segmentViewSelectIndex:(NSInteger)index
{
    targetType=index;
    DLog(@"%d",targetType);
}

#pragma mark - 日期选择框
-(void)didChangeDate:(id)sender
{
    UITextField *field=(UITextField*)sender;
    [field resignFirstResponder];
    if (IOS_VERSION_8_OR_ABOVE) {
        UIAlertController* alertController=[UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePicker.backgroundColor=[UIColor whiteColor];
        datePicker.tag=101;
        [datePicker setMinimumDate:[NSDate date]];
        UIAlertAction * canelAction=[UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMdd";
            NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timezone];
            
            NSString *dateTemp=[formatter stringFromDate:datePicker.date];
            doneDate=dateTemp;
            [self.mTableView reloadData];
        }];
        
        [alertController.view addSubview:datePicker];
        [alertController addAction:canelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }else{
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
        sheet.tag=100;
        sheet.actionSheetStyle=UIActionSheetStyleAutomatic;
        
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePicker.tag=101;
        [datePicker setMinimumDate:[NSDate date]];
        [sheet addSubview:datePicker];
        [sheet showInView:self.view];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==100) {
        UIDatePicker  *datePick=(UIDatePicker*)[actionSheet viewWithTag:101];
        if (datePick) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMdd";
            NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timezone];
            NSString *dateTemp=[formatter stringFromDate:datePick.date];
            doneDate=dateTemp;
        }
        [self.mTableView reloadData];
    }
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - TargetHeadViewDelegate
-(void)onTargetHeadViewFavClicked
{
    
}

@end
