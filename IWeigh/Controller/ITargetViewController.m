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

@interface ITargetViewController ()<ISegmentViewDelegate,UITextFieldDelegate,TargetHeadViewDelegate>
{
    int         currentType;
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
            AccountEntity* account=[array objectAtIndex:0];
            [self.headView setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",account.height],@"height", [NSString stringWithFormat:@"%ld",account.sex],@"sex",nil]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save
{
    
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
            
            self.doneDateField =[[UITextField alloc] initWithFrame:CGRectMake(20, 40, bounds.size.width-40, 36)];
            [self.doneDateField setBackground:[[UIImage imageNamed:@"long_input_bg"] stretchableImageWithLeftCapWidth:50 topCapHeight:50]];
            [self.doneDateField setPlaceholder:@"请输入完成日期"];
            [self.doneDateField setBorderStyle:UITextBorderStyleNone];
            [self.doneDateField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.doneDateField setReturnKeyType:UIReturnKeyDone];
            [self.doneDateField setKeyboardType:UIKeyboardTypeDefault];
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
    [self.setValueLabel setText:[NSString stringWithFormat:@"%.1f",sl.value]];
}

-(void)segmentViewSelectIndex:(NSInteger)index
{
    
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
