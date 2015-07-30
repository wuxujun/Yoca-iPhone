//
//  IInfoViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/6/16.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IInfoViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+LoadingView.h"
#import "IInfoViewCell.h"
#import "IWebViewController.h"

@interface IInfoViewController()<IInfoViewCellDelegate>

@end


@implementation IInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    // Do any additional setup after loading the view.
    
    [self setCenterTitle:@"资讯"];
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    [self.view showHUDLoadingView:YES];
    NSString *url = [NSString stringWithFormat:@"%@getInfo",kHttpUrl];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"syncid", nil]];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                [self.mDatas addObject:[array objectAtIndex:i]];
            }
        }
        if ([self.mDatas count]>0) {
            [self.mTableView reloadData];
        }
        [self.view showHUDLoadingView:NO];
    } error:^(NSError *error) {
        DLog(@"%@",error);
        [self.view showHUDLoadingView:NO];
    }];
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
    return 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    
    NSDictionary* dic=[self.mDatas objectAtIndex:indexPath.row];
    if (dic) {
        IInfoViewCell* infoView=[[IInfoViewCell alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 200) delegate:self];
        infoView.infoDict=dic;
        [cell addSubview:infoView];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)onIInfoViewCellClicked:(IInfoViewCell *)view
{
    IWebViewController* dController=[[IWebViewController alloc]init];
    dController.infoDict=view.infoDict;
    [self.navigationController pushViewController:dController animated:YES];
}

@end
