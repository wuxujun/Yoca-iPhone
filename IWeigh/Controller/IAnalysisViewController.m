//
//  IAnalysisViewController.m
//  IWeigh
//
//  Created by xujunwu on 7/7/15.
//  Copyright (c) 2015 ___xujun___. All rights reserved.
//

#import "IAnalysisViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+LoadingView.h"
#import "IAnalysisDViewController.h"
#import "ISegmentView.h"
#import "DBManager.h"
#import "TargetInfoEntity.h"
#import "AppConfig.h"

@interface IAnalysisViewController()<ISegmentViewDelegate>
{
    int             dayCounts;
    int             currentAccountId;

}

@property(nonatomic,strong)ISegmentView* segmentView;
@end


@implementation IAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:APP_TABLEBG_COLOR];
    [self setCenterTitle:@"图表汇总"];
    dayCounts=7;
    if (_segmentView==nil) {
        NSArray* items=@[@"周",@"月",@"年"];
        _segmentView=[[ISegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) items:items];
        [_segmentView selectForItem:0];
        
        _segmentView.tintColor=APP_FONT_COLOR_SEL;
        _segmentView.delegate=self;
    }
    [self.view addSubview:_segmentView];
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-88) style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

-(void)loadData
{
//    [self.view showHUDLoadingView:YES];
    currentAccountId=[[[AppConfig getInstance] getPrefValue:CURRENT_ACCOUNT_ID] intValue];
    
    NSArray* array=[[DBManager getInstance] queryTargetInfo];
    if ([array count]>0) {
        [self.mDatas addObjectsFromArray:array];
    }
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
    return 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    TargetInfoEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
    IChartViewCell* item=[[IChartViewCell alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 200) delegate:self];
    [item setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:entity.title,@"title",[NSNumber numberWithInteger:entity.type],@"type",[NSNumber numberWithInt:dayCounts],@"dayCounts",[NSString stringWithFormat:@"%d",currentAccountId],@"aid", nil]];
    [cell addSubview:item];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)segmentViewSelectIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            dayCounts=7;
            break;
        case 1:
            dayCounts=30;
            break;
        case 2:
            dayCounts=365;
            break;
        case 3:
            dayCounts=365;
            break;
        default:
            break;
    }
    [self.mTableView reloadData];
}

#pragma mark - IChartViewCellDelegate
-(void)onIChartViewCellClicked:(IChartViewCell *)view
{
    IAnalysisDViewController* dController=[[IAnalysisDViewController alloc]init];
    dController.infoDict=view.infoDict;
    [self.navigationController pushViewController:dController animated:YES];
}

@end
