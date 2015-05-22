//
//  IWarnAViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/14.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IWarnAViewController.h"
#import "HKeyboardTableView.h"
#import "UIViewController+NavigationBarButton.h"
#import "ISegmentView.h"
#import "UIButton+Bootstrap.h"
#import "DBManager.h"
#import "IDatePicker.h"


@interface IWarnAViewController ()<ISegmentViewDelegate,UITextFieldDelegate,IDatePickerDelegate>
{
    NSInteger         currentType;
    
    NSString*   title;
    NSString*   note;
}
@property (nonatomic,strong)IDatePicker*  timePicker;
@property (nonatomic,strong)NSMutableDictionary*  weekDict;
@property (nonatomic,strong)NSMutableDictionary*  typeDict;

@end

@implementation IWarnAViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self addBackBarButton];
    [self setCenterTitle:@"添加提醒"];
    [self addRightButtonWithTitle:@"保存" withSel:@selector(save)];
    currentType=0;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if (self.timePicker==nil) {
        self.timePicker=[[IDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220) maxDate:[NSDate dateWithTimeIntervalSinceNow:7*24*60*60] minDate:[NSDate date] showValidDatesOnly:YES showType:1];
        self.timePicker.delegate=self;
        
//        [self.timePicker setDatePickerMode:UIDatePickerModeTime];
//        [self.timePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
        
//        [self.timePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
//        [self.timePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.mTableView setTableHeaderView:self.timePicker];
    }
    
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    timeFormatter.dateFormat = @"HH:mm";
    title= [timeFormatter stringFromDate:[NSDate date]];
    self.weekDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"100",@"1",@"101",@"1",@"102",@"1",@"103",@"1",@"104",@"1",@"105",@"1",@"106", nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)save
{
    if (note==nil) {
        [self alertRequestResult:@"请输入标签" isPop:NO];
        return;
    }
    
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:title forKey:@"title"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)currentType] forKey:@"repeats"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"100"]] forKey:@"weekMon"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"101"]] forKey:@"weekTue"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"102"]] forKey:@"weekWed"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"103"]] forKey:@"weekThu"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"104"]] forKey:@"weekFir"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"105"]] forKey:@"weekSat"];
    [dict setObject:[NSString stringWithFormat:@"%@",[self.weekDict objectForKey:@"106"]] forKey:@"weekSun"];
    [dict setObject:[title substringToIndex:2] forKey:@"hours"];
    [dict setObject:[title substringFromIndex:3] forKey:@"minutes"];
    [dict setObject:note forKey:@"note"];
    
    DLog(@"%@",dict);
    if ([[DBManager getInstance] insertOrUpdateWarn:dict]) {
        [self alertRequestResult:@"保存成功" isPop:YES];
    }
}

- (void)dateChanged:(IDatePicker *) sender {
    
    NSDate *select = [sender date]; // 获取被选中的时间
    NSLog(@"%@",select);
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    [selectDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    selectDateFormatter.dateFormat = @"HH:mm"; // 设置时间和日期的格式
    title= [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    
    NSLog(@"%@   %@   %@   %@", [sender date],title,[title substringToIndex:2],[title substringFromIndex:3]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    if (sectionIndex==0) {
        label.text=@"重复";
    }else{
        label.text=@"标签";
    }
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 34;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    
    CGRect bounds=self.view.frame;
    switch (indexPath.section) {
        case 0:
        {
            NSArray *titles = @[@"周一", @"周二", @"周三",@"周四",@"周五",@"周六",@"周日"];
            int btnWidth=bounds.size.width/7;
            for (int i=0; i<7; i++) {
                UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn defaultStyle];
                [btn setTag:100+i];
                [btn setFrame:CGRectMake(i*btnWidth+2, 6, btnWidth-2, 32)];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                if ([[self.weekDict objectForKey:[NSString stringWithFormat:@"%d",(100+i)]] intValue]==0) {
                    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [btn setBackgroundColor:[UIColor clearColor]];
                }else{
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setBackgroundColor:[UIColor grayColor]];
                }
                [btn addTarget:self action:@selector(weekSelected:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                
            }
            NSArray* types=@[@"每天",@"工作日",@"周末"];
            ISegmentView* segmentView=[[ISegmentView alloc]initWithFrame:CGRectMake(5, 44, 310, 36) items:types];
            [segmentView selectForItem:currentType];
            segmentView.tintColor=[UIColor grayColor];
            segmentView.delegate=self;
            [cell addSubview:segmentView];
        }
            break;
        case 1:
        {
            self.noteInputBG=[[UIView alloc]initWithFrame:CGRectMake(9.5, 5.5, bounds.size.width-19, 61)];
            [self.noteInputBG setBackgroundColor:APP_FONT_COLOR];
            [self.noteInputBG.layer setMasksToBounds:YES];
            [self.noteInputBG.layer setCornerRadius:5.0f];
            [cell addSubview:self.noteInputBG];
            
            self.noteField=[[UITextField alloc] initWithFrame:CGRectMake(10, 6, bounds.size.width-20, 60)];
            [self.noteField setTextColor:APP_FONT_COLOR];
            [self.noteField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.noteField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.noteField setBorderStyle:UITextBorderStyleNone];
            [self.noteField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.noteField.layer setMasksToBounds:YES];
            [self.noteField.layer setCornerRadius:5.0f];
            [self.noteField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            
            [self.noteField setDelegate:self];
            if (note) {
                [self.noteField setText:note];
            }
            [cell addSubview:self.noteField];
            
        }
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(IBAction)weekSelected:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    NSString *key=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    if ([[self.weekDict objectForKey:key] intValue]==0) {
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekDict setObject:@"1" forKey:key];
    }else{
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.weekDict setObject:@"0" forKey:key];
    }
}

-(void)segmentViewSelectIndex:(NSInteger)index
{
    currentType=index;
    if (index==0) {
        [self.weekDict setObject:@"1" forKey:@"100"];
        [self.weekDict setObject:@"1" forKey:@"101"];
        [self.weekDict setObject:@"1" forKey:@"102"];
        [self.weekDict setObject:@"1" forKey:@"103"];
        [self.weekDict setObject:@"1" forKey:@"104"];
        [self.weekDict setObject:@"1" forKey:@"105"];
        [self.weekDict setObject:@"1" forKey:@"106"];
    }else if(index==1){
        [self.weekDict setObject:@"1" forKey:@"100"];
        [self.weekDict setObject:@"1" forKey:@"101"];
        [self.weekDict setObject:@"1" forKey:@"102"];
        [self.weekDict setObject:@"1" forKey:@"103"];
        [self.weekDict setObject:@"1" forKey:@"104"];
        [self.weekDict setObject:@"0" forKey:@"105"];
        [self.weekDict setObject:@"0" forKey:@"106"];
    }else{
        [self.weekDict setObject:@"0" forKey:@"100"];
        [self.weekDict setObject:@"0" forKey:@"101"];
        [self.weekDict setObject:@"0" forKey:@"102"];
        [self.weekDict setObject:@"0" forKey:@"103"];
        [self.weekDict setObject:@"0" forKey:@"104"];
        [self.weekDict setObject:@"1" forKey:@"105"];
        [self.weekDict setObject:@"1" forKey:@"106"];
    }
    [self.mTableView reloadData];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField becomeFirstResponder];
    [self save];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.noteInputBG setBackgroundColor:APP_FONT_COLOR_SEL];
    [self.noteField setTextColor:APP_FONT_COLOR_SEL];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    note=textField.text;
    [self.noteInputBG setBackgroundColor:APP_FONT_COLOR];
    [self.noteField setTextColor:APP_FONT_COLOR];
    return YES;
}

@end
