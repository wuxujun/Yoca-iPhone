//
//  AvatarEViewController.m
//  IWeigh
//
//  Created by xujunwu on 16/1/5.
//  Copyright © 2016年 ___xujun___. All rights reserved.
//

#import "AvatarEViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "INavigationController.h"
#import "IWarnViewController.h"
#import "HCurrentUserContext.h"
#import "UserDefaultHelper.h"
#import "AppDelegate.h"
#import "HomeTargetEntity.h"
#import "IHomeIView.h"

@interface AvatarEViewController()<IHomeIViewDelegate>
{
    
    NSMutableArray          *targetDatas;
}
@end

@implementation AvatarEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    targetDatas=[[NSMutableArray alloc]init];
    
    [self addBackBarButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setCenterTitle:@"数据"];
    
#ifdef NAV_LEFT_MENU
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_left"] style:UIBarButtonItemStylePlain target:(INavigationController*)self.navigationController action:@selector(showMenu)];
#endif
    //    [self addRightButtonWithTitle:@"注销" withSel:@selector(logout)];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [targetDatas count];
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
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    
    if (indexPath.row<=[targetDatas count]) {
        HomeTargetEntity* entity=[targetDatas objectAtIndex:indexPath.row-1];
        NSMutableDictionary * dict=[NSMutableDictionary dictionary];
        [dict setObject:entity.title forKey:@"title"];
        if (entity.unit) {
            [dict setObject:entity.unit forKey:@"unit"];
        }
        if (entity.value) {
            [dict setObject:entity.value forKey:@"value"];
        }
        if (entity.state) {
            [dict setObject:[NSString stringWithFormat:@"%d",entity.state] forKey:@"state"];
        }
        if (entity.valueTitle){
            [dict setObject:entity.valueTitle forKey:@"valueTitle"];
        }
        if (entity.progres) {
            [dict setObject:entity.progres forKey:@"progres"];
        }
        
        //            [dict setObject:@"1" forKey:@"isChart"];
        IHomeIView* item=[[IHomeIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 70) delegate:self];
        [item setInfoDict:dict];
        [cell addSubview:item];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, bounds.size.width, 0.5)];
        [img setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:img];
        [cell sendSubviewToBack:img];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)onChartClicked:(IHomeIView*)view
{
    
}

-(void)onEditClicked:(IHomeIView*)view
{
    
}
@end
