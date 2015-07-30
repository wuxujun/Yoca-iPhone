//
//  IAccountViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IAccountViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "INavigationController.h"
#import "IAccountDViewController.h"
#import "AccountEntity.h"
#import "DBManager.h"
#import "PathHelper.h"

@interface IAccountViewController ()

@end

@implementation IAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"成员管理"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
#ifdef NAV_LEFT_MENU
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_left"] style:UIBarButtonItemStylePlain target:(INavigationController*)self.navigationController action:@selector(showMenu)];
#endif
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccount:)];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(IBAction)addAccount:(id)sender
{
    IAccountDViewController* dController=[[IAccountDViewController alloc]init];
    [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"dataType",@"添加成员信息",@"title",@"保存",@"buttonTitle", nil]];
    [self.navigationController pushViewController:dController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    [self.mDatas removeAllObjects];
    [self.mDatas addObjectsFromArray:[[DBManager getInstance] queryAccount]];
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
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    
    UIImageView* icon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 64, 64)];
    [icon setImage:[UIImage imageNamed:@"userbig.png"]];
    [cell addSubview:icon];
    
    AccountEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
    
    if (entity.avatar&&[PathHelper fileExistsAtPath:entity.avatar]) {
        [icon setImage:[UIImage imageNamed:[PathHelper filePathInDocument:entity.avatar]]];
    }
    
    
    UILabel* uLabel=[[UILabel alloc]init];
    [uLabel setFrame:CGRectMake(100, 8, 200, 44)];
    [uLabel setText:entity.userNick];
    [uLabel setTextColor:APP_FONT_COLOR];
    [uLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [cell addSubview:uLabel];
    
    
    UILabel* dLabel=[[UILabel alloc]init];
    [dLabel setFrame:CGRectMake(100, 40, 200, 44)];
    [dLabel setText:entity.birthday];
    [dLabel setTextColor:APP_FONT_COLOR];
    [dLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell addSubview:dLabel];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 79.5, bounds.size.width, 0.5)];
    [img setBackgroundColor:[UIColor blackColor]];
    [cell addSubview:img];
    [cell sendSubviewToBack:img];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AccountEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
    if (entity) {
        IAccountDViewController* dController=[[IAccountDViewController alloc]init];
        [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"dataType",@"修改成员信息",@"title",@"保存",@"buttonTitle",
                                  [NSString stringWithFormat:@"%d",entity.aid],@"dataIndex",nil]];
        [self.navigationController pushViewController:dController animated:YES];
    }
}
@end