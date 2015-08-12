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
#import "IPhotoViewController.h"
#import "IWarnViewController.h"
#import "HCurrentUserContext.h"
#import "UserDefaultHelper.h"
#import "DMPasscode.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "PathHelper.h"
#import "AccountEntity.h"

@interface IMyViewController ()

@property(nonatomic,strong)AccountEntity*       account;

@end


@implementation IMyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setCenterTitle:@"我的"];
    
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
    NSArray* array=[[DBManager getInstance] queryAccountForType:1];
    if ([array count]>0) {
        _account=(AccountEntity*)[array objectAtIndex:0];
    }
    [self.mTableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 128;
    }
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    CGRect bounds=self.view.frame;
    cell.backgroundColor=APP_TABLEBG_COLOR;
    if (indexPath.section==0) {
        UIImageView* avatarImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 96, 96)];
        avatarImg.image = [UIImage imageNamed:@"userbig.png"];
        if (_account) {
            if (_account.avatar&&[PathHelper fileExistsAtPath:_account.avatar]) {
                [avatarImg setImage:[UIImage imageNamed:[PathHelper filePathInDocument:_account.avatar]]];
            }
        }
        [cell addSubview:avatarImg];
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, SCREEN_WIDTH-140, 30)];
        [lb setTextColor:APP_FONT_COLOR];
        [lb setFont:[UIFont systemFontOfSize:18.0f]];
        if (_account) {
            [lb setText:_account.userNick];
        }
        [cell addSubview:lb];
        
        UILabel* lb2=[[UILabel alloc]initWithFrame:CGRectMake(120, 70, SCREEN_WIDTH-140, 30)];
        lb2.text=[HCurrentUserContext sharedInstance].username;
        [lb2 setTextColor:APP_FONT_COLOR];
        [cell addSubview:lb2];
        
        UIImageView* line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 127.5, bounds.size.width, 0.5)];
        [line setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:line];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else{
        NSArray *titles = @[@"用户管理", @"设置",@"减服相册"];
        NSArray* images=@[@"ic_Item_My",@"ic_Item_Setting",@"ic_Item_My"];
        
        UIImageView* avatarImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        avatarImg.image = [UIImage imageNamed:images[indexPath.row]];
        [cell addSubview:avatarImg];
        
        UILabel* uLabel=[[UILabel alloc]init];
        [uLabel setFrame:CGRectMake(60, 10, 200, 44)];
        [uLabel setText:titles[indexPath.row]];
        [uLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [uLabel setTextColor:APP_FONT_COLOR];
        [cell addSubview:uLabel];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5, bounds.size.width, 0.5)];
        [img setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:img];
        [cell sendSubviewToBack:img];
            
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        
    }else{
        if (indexPath.row==0) {
            IAccountViewController *dController=[[IAccountViewController alloc]init];
            [self.navigationController pushViewController:dController animated:YES];
        }else if(indexPath.row==1){
            ISettingViewController* dController=[[ISettingViewController alloc]init];
            [self.navigationController pushViewController:dController animated:YES];
        }else if(indexPath.row==2){
            IPhotoViewController* dController=[[IPhotoViewController alloc]init];
            [self.navigationController pushViewController:dController animated:YES];
        }
    }
}

@end
