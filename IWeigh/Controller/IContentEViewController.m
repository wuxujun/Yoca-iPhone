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
#import "IHomeIView.h"
#import "HomeTargetEntity.h"

@interface IContentEViewController ()
{
    
}

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
    return [self.mDatas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    CGRect bounds=self.view.frame;
    cell.backgroundColor=APP_TABLEBG_COLOR;
    
    HomeTargetEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:entity.title forKey:@"title"];
    if (entity.unit) {
        [dict setObject:entity.unit forKey:@"unit"];
    }
    [dict setObject:@"正常" forKey:@"status"];
    [dict setObject:@"1" forKey:@"isEdit"];
    
    IHomeIView* item=[[IHomeIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 70) delegate:self];
    [item setInfoDict:dict];
    [cell addSubview:item];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, bounds.size.width, 0.5)];
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


@end
