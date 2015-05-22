//
//  IWarnViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IWarnViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "IWarnAViewController.h"
#import "DBManager.h"
#import "WarnEntity.h"

@implementation IWarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"提醒设置"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
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

-(void)loadData
{
    NSArray* array=[[DBManager getInstance]queryWarns];
    [self.mDatas removeAllObjects];
    [self.mDatas addObjectsFromArray:array];
    [self.mTableView reloadData];
}

-(IBAction)add:(id)sender
{
    IWarnAViewController* dController=[[IWarnAViewController alloc]init];
    [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"dataType", nil]];
    [self.navigationController pushViewController:dController animated:YES];
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
    return [self.mDatas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    CGRect bounds=self.view.frame;
    cell.backgroundColor=APP_TABLEBG_COLOR;
    
    WarnEntity *entity=[self.mDatas objectAtIndex:indexPath.row];

    UILabel* uLabel=[[UILabel alloc]init];
    [uLabel setFrame:CGRectMake(10, 10, 200, 44)];
    [uLabel setText:entity.title];
    [uLabel setTextColor:APP_FONT_COLOR_SEL];
    [uLabel setFont:[UIFont boldSystemFontOfSize:36.0]];
    [cell addSubview:uLabel];
    NSString* week=@"";
    if (entity.weekMon==1) {
        week=[NSString stringWithFormat:@"%@周一",week];
    }
    
    if (entity.weekTue==1) {
        week=[NSString stringWithFormat:@"%@ 周二",week];
    }
    
    if (entity.weekWed==1) {
        week=[NSString stringWithFormat:@"%@ 周三",week];
    }
    
    if (entity.weekThu==1) {
        week=[NSString stringWithFormat:@"%@ 周四",week];
    }
    
    if (entity.weekFir==1) {
        week=[NSString stringWithFormat:@"%@ 周五",week];
    }
    
    if (entity.weekSat==1) {
        week=[NSString stringWithFormat:@"%@ 周六",week];
    }
    
    if (entity.weekSun==1) {
        week=[NSString stringWithFormat:@"%@ 周日",week];
    }
    
    UILabel* weekLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, bounds.size.width-100, 30)];
    [weekLb setFont:[UIFont systemFontOfSize:14.0f]];
    [weekLb setText:week];
    [weekLb setTextColor:APP_FONT_COLOR];
    [cell addSubview:weekLb];
    
    UISwitch *sw=[[UISwitch alloc]initWithFrame:CGRectMake(bounds.size.width-70, (80-28)/2, 100, 28)];
    if (entity.status==1) {
        [sw setSelected:YES];
    }
    
    [cell addSubview:sw];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 79.5, bounds.size.width, 0.5)];
    [img setBackgroundColor:[UIColor blackColor]];
    [cell addSubview:img];
    [cell sendSubviewToBack:img];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IWarnAViewController* dController=[[IWarnAViewController alloc]init];
    [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"dataType",indexPath.row,@"dataIndex", nil]];
    [self.navigationController pushViewController:dController animated:YES];
    
}
@end
