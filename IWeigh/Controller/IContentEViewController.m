//
//  IContentEViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/5/12.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IContentEViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "IScanView.h"
#import "AccountEntity.h"
#import "IHomeTView.h"
#import "IHomeIView.h"
#import "HomeTargetEntity.h"

@interface IContentEViewController ()<IScanViewDelegate,IHomeIViewDelegate>
{
    
}
@property(nonatomic,strong)IScanView*  scanView;
@property(nonatomic,strong)AccountEntity*   accountEntity;

@end


@implementation IContentEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"指标编辑"];
    [self addRightButtonWithTitle:@"保存" withSel:@selector(save:)];
    
    // Do any additional setup after loading the view.
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    if (self.scanView==nil) {
        self.scanView=[[IScanView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260) delegate:self];
        [self.mTableView setTableHeaderView:self.scanView];
    }
    
    if (self.infoDict) {
        int index=[[self.infoDict objectForKey:@"dataIndex"] intValue];
        NSArray *array=[[DBManager getInstance] queryAccountForID:index];
        if ([array count]>0) {
            self.accountEntity=[array objectAtIndex:0];
        }
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData
{
    if (self.infoDict) {
        [self.mDatas removeAllObjects];
        NSArray* array=[[DBManager getInstance] queryHomeTargetWithAId:[[self.infoDict objectForKey:@"dataIndex"] integerValue] status:0];
        [self.mDatas addObjectsFromArray:array];
        
        [self.mTableView reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mDatas count]+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 80.0f;
    }
    
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    CGRect bounds=self.view.frame;
    cell.backgroundColor=APP_TABLEBG_COLOR;
    
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
            IHomeTView* item=[[IHomeTView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
            [item setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"weight",self.accountEntity.targetWeight,@"targetWeight",self.accountEntity.doneTime,@"doneTime", nil]];
            [cell addSubview:item];
        }
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 79.5, bounds.size.width, 0.5)];
        [img setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:img];
        [cell sendSubviewToBack:img];
        
    }else{
        if (indexPath.row<=[self.mDatas count]) {
            HomeTargetEntity* entity=[self.mDatas objectAtIndex:indexPath.row-1];
            NSMutableDictionary * dict=[NSMutableDictionary dictionary];
            [dict setObject:entity.title forKey:@"title"];
            if (entity.unit) {
                [dict setObject:entity.unit forKey:@"unit"];
            }
            if (entity.value) {
                [dict setObject:entity.value forKey:@"value"];
            }
            if (entity.valueTitle) {
                [dict setObject:entity.valueTitle forKey:@"valueTitle"];
            }
            if (entity.progres) {
                [dict setObject:entity.progres forKey:@"progres"];
            }
            [dict setObject:[NSString stringWithFormat:@"%d",entity.state] forKey:@"state"];
            [dict setObject:[NSString stringWithFormat:@"%d",entity.isShow] forKey:@"isShow"];
            [dict setObject:@"1" forKey:@"isEdit"];
            [dict setObject:[NSString stringWithFormat:@"%d",entity.tid] forKey:@"id"];
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
    
}

-(void)onEditClicked:(IHomeIView*)view
{
    NSInteger tid=[[view.infoDict objectForKey:@"id"] integerValue];
    if (tid>0) {
        NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
        [dict setObject:[NSString stringWithFormat:@"%ld",tid] forKey:@"id"];
        [dict setObject:[NSString stringWithFormat:@"%d",[view isShow]] forKey:@"isShow"];
        if ([[DBManager getInstance] insertOrUpdateHomeTarget:dict]) {
            DLog(@"%ld  state = %d is update success",tid,[view isShow]);
        }
    }
}


@end
