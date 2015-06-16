//
//  IYocaViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/17.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IYocaViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "IHomeIView.h"
#import "HomeTargetEntity.h"
#import "TargetHeadView.h"
#import "AccountEntity.h"
#import "IHisPagesViewController.h"
#import "VerticallyAlignedLabel.h"

#define isOpen   @"75.0f"

@interface IYocaViewController ()<TargetHeadViewDelegate>
{
    NSMutableDictionary     *dictClicked;
}

@property (nonatomic,strong)TargetHeadView* headView;

@end

@implementation IYocaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"YOCA报告"];
    [self addRightButtonWithTitle:@"历史" withSel:@selector(history:)];
    
    dictClicked=[NSMutableDictionary dictionary];
    
    // Do any additional setup after loading the view.
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if (self.headView==nil) {
        self.headView=[[TargetHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) delegate:self];
        [self.mTableView setTableHeaderView:self.headView];
    }
    
    if ([self.infoDict objectForKey:@"dataIndex"]) {
        
        NSArray* array=[[DBManager getInstance] queryAccountForID:[[self.infoDict objectForKey:@"dataIndex"] integerValue]];
        if ([array count]>0) {
            AccountEntity* localAccount=[array objectAtIndex:0];
            [self.headView setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",localAccount.height],@"height", [NSString stringWithFormat:@"%d",localAccount.sex],@"sex",nil]];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)history:(id)sender
{
    IHisPagesViewController* dController=[[IHisPagesViewController alloc]init];
    dController.infoDict=self.infoDict;
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)loadData
{
    if (self.infoDict) {
        [self.mDatas removeAllObjects];
        NSArray* array=[[DBManager getInstance] queryHomeTargetWithAId:[[self.infoDict objectForKey:@"dataIndex"] integerValue] status:0];
        [self.mDatas addObjectsFromArray:array];
        
        [self.mTableView reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mDatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int state=[[dictClicked objectForKey:[NSString stringWithFormat:@"key_%d",section]] intValue];
    if (state==1) {
        return [[dictClicked objectForKey:[NSString stringWithFormat:@"key_%d",section]] integerValue];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTargetEntity* entity=[self.mDatas objectAtIndex:indexPath.section];
    if (entity!=NULL) {
        return [self countContentHeight:[[DBManager getInstance] queryTargetInfoForType:entity.type]]+20;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect bounds=self.view.frame;
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 70)];
    HomeTargetEntity* entity=[self.mDatas objectAtIndex:section];
    if (entity!=NULL) {
        IHomeIView* item=[[IHomeIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 70) delegate:self];
        NSMutableDictionary * dict=[NSMutableDictionary dictionary];
        [dict setObject:entity.title forKey:@"title"];
        if (entity.unit) {
            [dict setObject:entity.unit forKey:@"unit"];
        }
        if (entity.value) {
            [dict setObject:entity.value forKey:@"value"];
        }
        if (entity.valueTitle) {
            [dict setObject:entity.valueTitle forKey:@"valueTitle"];
        }
        if (entity.progres) {
            [dict setObject:entity.progres forKey:@"progres"];
        }
        [dict setObject:[NSString stringWithFormat:@"%d",entity.state] forKey:@"state"];
        [dict setObject:[NSString stringWithFormat:@"%d",entity.tid] forKey:@"id"];
        
        if (entity.type==1) {
            [self.headView setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:entity.value,@"weight", nil]];
        }
        
        [item setInfoDict:dict];
        [view addSubview:item];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, bounds.size.width, 0.5)];
        [img setBackgroundColor:[UIColor blackColor]];
        [view addSubview:img];
//        [view sendSubviewToBack:img];
        
        UIButton* button=[[UIButton alloc ]init];
        [button setFrame:CGRectMake(0, 0, bounds.size.width, 70)];
        button.tag=section;
        [button addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=[UIColor grayColor];
    CGRect bounds=self.view.frame;
   
    HomeTargetEntity* entity=[self.mDatas objectAtIndex:indexPath.section];
    if (entity) {
        NSString * strContent=[[DBManager getInstance] queryTargetInfoForType:entity.type];
        
        VerticallyAlignedLabel *content=[[VerticallyAlignedLabel alloc]initWithFrame:CGRectMake(10, 10, bounds.size.width-20, [self countContentHeight:strContent])];
        [content setVerticalAlignment:VerticalAlignmentTop];
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        [content setFont:[UIFont systemFontOfSize:13.0]];
        [content setNumberOfLines:0];
        [cell addSubview:content];
        content.text=strContent;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)countContentHeight:(NSString*)str
{
    CGRect bounds=self.view.frame;
    CGSize titleSize=[str sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(bounds.size.width-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return titleSize.height;
}

-(IBAction)headerClicked:(id)sender
{
    int sectionIdx=(int)((UIButton*)sender).tag;
    int state=[[dictClicked objectForKey:[NSString stringWithFormat:@"key_%d",sectionIdx]] intValue];
    if (state==1) {
        state=0;
    }else{
        state=1;
    }
    [dictClicked setValue:[NSString stringWithFormat:@"%d",state] forKey:[NSString stringWithFormat:@"key_%d",sectionIdx]];
    [self.mTableView reloadData];
    //    [mTableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)onTargetHeadViewFavClicked
{
    
}

@end
