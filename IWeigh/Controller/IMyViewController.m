//
//  IMyViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/7/21.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IMyViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "INavigationController.h"
#import "IAccountViewController.h"
#import "ISettingViewController.h"
#import "IWarnViewController.h"
#import "HCurrentUserContext.h"
#import "UserDefaultHelper.h"
#import "DMPasscode.h"
#import "AppDelegate.h"

@interface IMyViewController ()

@end


@implementation IMyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setCenterTitle:@"我"];
    
#ifdef NAV_LEFT_MENU
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_left"] style:UIBarButtonItemStylePlain target:(INavigationController*)self.navigationController action:@selector(showMenu)];
#endif
    [self addRightButtonWithTitle:@"注销" withSel:@selector(logout)];
    
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
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout
{
    [[HCurrentUserContext sharedInstance] clearUserInfo];
    [ApplicationDelegate openHomeView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSArray *titles = @[@"用户管理", @"数据管理", @"设置",@"减服相册"];
    CGRect bounds=self.view.frame;
    cell.backgroundColor=APP_TABLEBG_COLOR;
    UILabel* uLabel=[[UILabel alloc]init];
    
    [uLabel setFrame:CGRectMake(10, 10, 200, 44)];
    [uLabel setText:titles[indexPath.row]];
    [uLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [uLabel setTextColor:APP_FONT_COLOR];
    [cell addSubview:uLabel];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5, bounds.size.width, 0.5)];
    [img setBackgroundColor:[UIColor blackColor]];
    [cell addSubview:img];
    [cell sendSubviewToBack:img];
            
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
        IAccountViewController *dController=[[IAccountViewController alloc]init];
        [self.navigationController pushViewController:dController animated:YES];
    }else if(indexPath.row==2){
        ISettingViewController* dController=[[ISettingViewController alloc]init];
        [self.navigationController pushViewController:dController animated:YES];
    }
    
}

@end
