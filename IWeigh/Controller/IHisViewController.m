//
//  IHisViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/5/25.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHisViewController.h"
#import "DBManager.h"
#import "WeightHisEntity.h"
#import "AccountEntity.h"

@interface IHisViewController ()

@end

@implementation IHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64.0f) style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if ([self.infoDict objectForKey:@"dataIndex"]) {
        
        NSArray* array=[[DBManager getInstance] queryAccountForID:[[self.infoDict objectForKey:@"dataIndex"] integerValue]];
        if ([array count]>0) {
//            AccountEntity* localAccount=[array objectAtIndex:0];
        }
    }
     [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    if (self.infoDict) {
        [self.mDatas removeAllObjects];
        NSArray* array=[[DBManager getInstance] queryWeightHisWithAccountId:[[self.infoDict objectForKey:@"dataIndex"] integerValue]];
        [self.mDatas addObjectsFromArray:array];
        [self.mTableView reloadData];
    }
    
}

-(void)reloadData:(BOOL)isEdit
{
    self.isEdit=isEdit;
    
    [self.mTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mDatas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    float pointY=170;
    if (self.isEdit) {
        pointY=210;
    }
    WeightHisEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
    if (entity) {

        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(20, (44-26)/2, 100, 26)];
        [label setText:entity.pickTime];
        [label setTextColor:APP_FONT_COLOR];
        [cell addSubview:label];
        
        
        
        UILabel* value=[[UILabel alloc]initWithFrame:CGRectMake(bounds.size.width-pointY, (44-26)/2, 150, 26)];
        switch (self.targetType) {
            case 0:
                [value setText:entity.bmi];
                break;
            case 1:
                [value setText:entity.weight];
                break;
            case 2:
                [value setText:entity.fat];
                break;
            case 3:
                [value setText:entity.subFat];
                break;
            case 4:
                [value setText:entity.visFat];
                break;
            case 5:
                [value setText:entity.water];
                break;
            case 6:
                [value setText:entity.BMR];
                break;
            case 7:
                [value setText:entity.bodyAge];
                break;
            case 8:
                [value setText:entity.muscle];
                break;
            case 9:
                [value setText:entity.bone];
                break;
            case 10:
                [value setText:@"0"];
                break;
            default:
                break;
        }
        
        [value setTextAlignment:NSTextAlignmentRight];
        [value setTextColor:APP_FONT_COLOR];
        [cell addSubview:value];
        
        
        if (self.isEdit) {

            UIButton *editBtn=[[UIButton alloc]initWithFrame:CGRectMake(bounds.size.width-50, (44-32)/2, 32, 32)];
            [editBtn setTag:indexPath.row];
            [editBtn setImage:[UIImage imageNamed:@"delet_red"] forState:UIControlStateNormal];
            [editBtn addTarget:self action:@selector(deleteEntity:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:editBtn];
            
        }
        
    }
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5, bounds.size.width, 0.5)];
    [img setBackgroundColor:[UIColor blackColor]];
    [cell addSubview:img];
    [cell sendSubviewToBack:img];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)deleteEntity:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    WeightHisEntity* entity=[self.mDatas objectAtIndex:btn.tag];
    
    if ([[DBManager getInstance] deleteWeightHisEntity:entity.wid]){
        [self loadData];
    }
}

@end
