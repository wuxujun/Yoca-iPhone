//
//  ISettingViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "ISettingViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "INavigationController.h"
#import "IWarnViewController.h"
#import "IAboutViewController.h"
#import "HCurrentUserContext.h"
#import "UserDefaultHelper.h"
#import "DMPasscode.h"
#import "AppDelegate.h"
#import "MobClick.h"

@interface ISettingViewController ()

@end

@implementation ISettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setCenterTitle:@"设置"];
    
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
    return 2;
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
    NSArray *titles = @[@"称重提醒",@"关于我们"];
    CGRect bounds=self.view.frame;
    cell.backgroundColor=APP_TABLEBG_COLOR;
//    switch (indexPath.row) {
//        case 2:
//        {
//            UILabel* uLabel=[[UILabel alloc]init];
//            [uLabel setFrame:CGRectMake(10, 10, 200, 44)];
//            [uLabel setText:titles[indexPath.row]];
//            [uLabel setTextColor:APP_FONT_COLOR];
//            [uLabel setFont:[UIFont systemFontOfSize:18.0f]];
//            [cell addSubview:uLabel];
//            
//            UISwitch* sw=[[UISwitch alloc]initWithFrame:CGRectMake(bounds.size.width-70, (64-28)/2, 100, 28)];
//            [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//            [cell addSubview:sw];
//            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5, bounds.size.width, 0.5)];
//            [img setBackgroundColor:[UIColor blackColor]];
//            [cell addSubview:img];
//            [cell sendSubviewToBack:img];
//        }
//            break;
//        case 1:
//        {
//            UILabel* uLabel=[[UILabel alloc]init];
//            [uLabel setFrame:CGRectMake(10, 10, 200, 44)];
//            [uLabel setText:titles[indexPath.row]];
//            [uLabel setTextColor:APP_FONT_COLOR];
//            [uLabel setFont:[UIFont systemFontOfSize:18.0f]];
//            [cell addSubview:uLabel];
//            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5, bounds.size.width, 0.5)];
//            [img setBackgroundColor:[UIColor blackColor]];
//            [cell addSubview:img];
//            [cell sendSubviewToBack:img];
//        }
//            break;
//        default:
//        {
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
//        }
//            break;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.row==0) {
        IWarnViewController *dController=[[IWarnViewController alloc]init];
        [self.navigationController pushViewController:dController animated:YES];
    }
//    else if(indexPath.row==1){
//        [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
//    }
    else if(indexPath.row==1){
        IAboutViewController* dController=[[IAboutViewController alloc]init];
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}

-(void)appUpdate:(NSDictionary*)appInfo
{
    DLog(@"%@",appInfo);
    if (![[appInfo objectForKey:@"update"] boolValue]) {
        [self alertRequestResult:@"已经是最新版了!" isPop:NO];
    }
}

-(IBAction)switchAction:(id)sender
{
    UISwitch* sw=(UISwitch*)sender;
    [UserDefaultHelper setObject:[NSNumber numberWithBool:sw.on] forKey:APP_OPEN_PASSWORD];
    if(sw.on){
        [DMPasscode setupPasscodeInViewController:self completion:^(BOOL success) {
            DLog(@"SUCCESS");
        }];
    }else{
        [DMPasscode removePasscode];
    }
    
}

@end
