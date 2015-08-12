//
//  IAnalysisDViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/7/26.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IAnalysisDViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+LoadingView.h"
#import "ISegmentView.h"
#import "IHisViewController.h"

@interface IAnalysisDViewController()<ISegmentViewDelegate>
{
    int             dayCounts;
}
@property(nonatomic,strong)IChartViewCell*  headView;
@property(nonatomic,strong)ISegmentView* segmentView;
@end


@implementation IAnalysisDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:APP_TABLEBG_COLOR];
    [self setCenterTitle:@"分析"];
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
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if (_headView==nil) {
        _headView=[[IChartViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) delegate:self];
        [self.mTableView setTableHeaderView:_headView];
    }
    
    if (self.infoDict) {
        _headView.infoDict=self.infoDict;
        switch ([[self.infoDict objectForKey:@"dayCounts"] intValue]) {
            case 7:
                [_segmentView selectForItem:0];
                break;
            case 365:
                [_segmentView selectForItem:2];
                break;
            default:
                [_segmentView selectForItem:1];
                break;
        }
    }
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    //    [self.view showHUDLoadingView:YES];
    [self.mDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"显示所有数据",@"title",@"",@"desc",nil]];
    [self.mDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"单位",@"title",@"Kg",@"desc", nil]];
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
    if (indexPath.row==2) {
        return 110.0;
    }
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    NSDictionary* dic=[self.mDatas objectAtIndex:indexPath.row];
    if (indexPath.row<2) {
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(20, (64-30)/2, SCREEN_WIDTH-40, 30)];
        [lb setTextColor:APP_FONT_COLOR];
        [lb setFont:[UIFont systemFontOfSize:18.0f]];
        [lb setText:[dic objectForKey:@"title"]];
        [cell addSubview:lb];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==1) {
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, (64-30)/2, 100, 30)];
        [lb setTextColor:APP_FONT_COLOR];
        [lb setTextAlignment:NSTextAlignmentRight];
        [lb setText:[dic objectForKey:@"desc"]];
        [cell addSubview:lb];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5, bounds.size.width, 0.5)];
    [img setBackgroundColor:[UIColor blackColor]];
    [cell addSubview:img];
    [cell sendSubviewToBack:img];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        IHisViewController* dController=[[IHisViewController alloc]init];
        dController.infoDict=self.infoDict;
        [self.navigationController pushViewController:dController animated:YES];
    }
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
    if (self.infoDict) {
        [_headView loadData:[[self.infoDict objectForKey:@"aid"] intValue] targetType:[[self.infoDict objectForKey:@"type"] intValue] days:dayCounts];
    }
}

#pragma mark - IChartViewCellDelegate
-(void)onIChartViewCellClicked:(IChartViewCell *)view
{
    
}

@end
