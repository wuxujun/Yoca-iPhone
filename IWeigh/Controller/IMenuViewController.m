//
//  IMenuViewController.m
//  IWeigh
//
//  Created by xujunwu on 14/10/30.
//  Copyright (c) 2014年 ___xujun___. All rights reserved.
//

#import "IMenuViewController.h"
#import "HomeViewController.h"
#import "INavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "ISettingViewController.h"
#import "IAccountViewController.h"
#import "IAccountDViewController.h"
#import "AccountEntity.h"
#import "IMenuHView.h"
#import "DBManager.h"
#import "PathHelper.h"

@interface IMenuViewController ()<IMenuHViewDelegate>

@property (nonatomic,strong)IMenuHView*  menuHeadView;

@end

@implementation IMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mDatas=[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor grayColor];
    
    self.menuHeadView=[[IMenuHView alloc]initWithFrame:CGRectMake(0, 0, 320, 184) delegate:self];
    self.tableView.tableHeaderView=self.menuHeadView;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadAccountData];
}

-(void)loadAccountData
{
    NSArray* array=[[DBManager getInstance] queryAccountForType:1];
    if ([array count]>0) {
        AccountEntity *account=[array objectAtIndex:0];
        if (account!=NULL) {
            [self.menuHeadView setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:account.userNick,@"title",[NSString stringWithFormat:@"%ld",account.aid],@"dataIndex",account.avatar,@"avatar", nil]];
        }
    }
    [self.mDatas removeAllObjects];
    [self.mDatas addObjectsFromArray:[[DBManager getInstance] queryAccountForType:0]];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex>0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text=@"家庭成员";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex>0) {
        return 0.0f;
    }
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        AccountEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
        DLog(@"%@",entity.userNick);
        [homeViewController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:entity.userNick,@"title",[NSString stringWithFormat:@"%ld",entity.aid],@"dataIndex", nil]];
        
        INavigationController *navigationController = [[INavigationController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
    }else if (indexPath.section==1&&indexPath.row==0){
    
//        [ShareSDK getUserInfoWithType:ShareTypeQQ authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//            if (result) {
//                NSLog(@"%@     %@",[userInfo uid],[userInfo nickname]);
//            }
//        }];
        IAccountViewController* dController=[[IAccountViewController alloc]init];
        INavigationController *navController=[[INavigationController alloc]initWithRootViewController:dController];
        self.frostedViewController.contentViewController=navController;
    
    }
    else if(indexPath.section==1&&indexPath.row==2){
        ISettingViewController* dController=[[ISettingViewController alloc]init];
        INavigationController *navController=[[INavigationController alloc]initWithRootViewController:dController];
        self.frostedViewController.contentViewController=navController;
    }
    else if(indexPath.section==1&&indexPath.row==1){
        IAccountDViewController* dController=[[IAccountDViewController alloc]init];
        [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"dataType",@"填写称重信息",@"title",@"开始称重",@"buttonTitle", nil]];
        INavigationController *navController=[[INavigationController alloc]initWithRootViewController:dController];
        self.frostedViewController.contentViewController=navController;
    } 
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex==0) {
        return [self.mDatas count];
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        UIImageView* icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 34, 34)];
        [icon setImage:[UIImage imageNamed:@"userbig.png"]];
        
        
        [cell addSubview:icon];
        
        AccountEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
        if (entity.avatar&&[PathHelper fileExistsAtPath:entity.avatar]) {
            [icon setImage:[UIImage imageNamed:[PathHelper filePathInDocument:entity.avatar]]];
        }
        
        UILabel* uLabel=[[UILabel alloc]init];
        [uLabel setFrame:CGRectMake(50, (54-26)/2, 200, 26)];
        [uLabel setText:entity.userNick];
        [uLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:uLabel];
    } else {
        NSArray *icons=@[@"user.png",@"vistor.png",@"seting.png"];
        
        UIImageView* icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 34, 34)];
        [icon setImage:[UIImage imageNamed:icons[indexPath.row]]];
        [cell addSubview:icon];
        NSArray *titles = @[@"成员管理", @"访客", @"设置"];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(50, (54-26)/2, 200, 26)];
        [label setText:titles[indexPath.row]];
        [label setTextColor:[UIColor whiteColor]];
        [cell addSubview:label];
    }

    return cell;
}

-(void)onMenuHViewClicked:(IMenuHView *)view
{
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    [homeViewController setInfoDict:view.infoDict];
    
    INavigationController *navigationController = [[INavigationController alloc] initWithRootViewController:homeViewController];
    self.frostedViewController.contentViewController = navigationController;
    
    [self.frostedViewController hideMenuViewController];
}

@end
