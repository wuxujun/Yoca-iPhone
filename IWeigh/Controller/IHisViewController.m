//
//  IHisViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/5/25.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHisViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+LoadingView.h"
#import "DBManager.h"
#import "WeightHisEntity.h"
#import "AccountEntity.h"
#import "IHisTableCell.h"
#import "HSwipeButton.h"

@interface IHisViewController ()<HSwipeTableCellDelegate>

@end

@implementation IHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44.0f) style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if ([self.infoDict objectForKey:@"aid"]) {
        self.targetType=[[self.infoDict objectForKey:@"type"] integerValue];
        [self setCenterTitle:[NSString stringWithFormat:@"%@-历史",[self.infoDict objectForKey:@"title"]]];
        NSArray* array=[[DBManager getInstance] queryAccountForID:[[self.infoDict objectForKey:@"aid"] integerValue]];
        if ([array count]>0) {
//            AccountEntity* localAccount=[array objectAtIndex:0];
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
    if (self.infoDict) {
        [self.mDatas removeAllObjects];
        NSArray* array=[[DBManager getInstance] queryWeightHisWithAccountId:[[self.infoDict objectForKey:@"aid"] integerValue]];
        [self.mDatas addObjectsFromArray:array];
        DLog(@"%d",[self.mDatas count]);
        [self.mTableView reloadData];
    }
    
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
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IHisTableCell *cell =(IHisTableCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell=[[IHisTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.delegate=self;
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    float pointY=170;
    if (self.isEdit) {
        pointY=210;
    }
    WeightHisEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
    if (entity) {
        [cell.pickTime setText:entity.pickTime];
        DLog(@"%@",entity.pickTime);
        switch (self.targetType) {
            case 0:
                [cell.value setText:entity.bmi];
                break;
            case 1:
                [cell.value setText:entity.weight];
                break;
            case 2:
                [cell.value setText:entity.fat];
                break;
            case 3:
                [cell.value setText:entity.subFat];
                break;
            case 4:
                [cell.value setText:entity.visFat];
                break;
            case 5:
                [cell.value setText:entity.water];
                break;
            case 6:
                [cell.value setText:entity.BMR];
                break;
            case 7:
                [cell.value setText:entity.bodyAge];
                break;
            case 8:
                [cell.value setText:entity.muscle];
                break;
            case 9:
                [cell.value setText:entity.bone];
                break;
            case 10:
                [cell.value setText:@"0"];
                break;
            default:
                break;
        }
    }
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 63.5, bounds.size.width, 0.5)];
    [img setBackgroundColor:[UIColor blackColor]];
    [cell addSubview:img];
    [cell sendSubviewToBack:img];
    
    cell.rightButtons=[self createRightButtons:1];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)swipeTableCell:(HSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(HSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if (direction==HSwipeDirectionRightToLeft) {
        NSIndexPath *path=[self.mTableView indexPathForCell:cell];
        WeightHisEntity *entity=[self.mDatas objectAtIndex:path.row];
        if (entity) {
            if ([[DBManager getInstance] deleteWeightHisEntity:entity.wid]) {
                DLog(@"delete  %ld   %ld",path.row,  entity.wid);
            }
        }
        [self.mTableView beginUpdates];
        [self.mDatas removeObjectAtIndex:index];
        [self.mTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        [self.mTableView endUpdates];
        return NO;
    }
    
    return YES;
}

-(NSArray*)swipeTableCell:(HSwipeTableCell *)cell swipeButtonsForDirection:(HSwipeDirection)direction swipeSettings:(HSwipeSettings *)swipeSettings expansionSettings:(HSwipeExpansionSettings *)expansionSettings
{
    if (direction==HSwipeDirectionRightToLeft) {
        expansionSettings.buttonIndex=[self.mTableView indexPathForCell:cell].row;
        expansionSettings.fillOnTrigger=YES;
        return [self createRightButtons:1];
    }
    return nil;
}


@end
