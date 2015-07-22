//
//  IUserViewController.m
//  IWeigh
//
//  Created by xujunwu on 7/11/15.
//  Copyright (c) 2015 ___xujun___. All rights reserved.
//

#import "IUserViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "AccountEntity.h"

@interface IUserViewController()

@property(nonatomic,strong)UIView       *leftGroup;
@property(nonatomic,strong)AccountEntity*       account;

@end

@implementation IUserViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _leftGroup=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2,SCREEN_HEIGHT)];
    [self.view addSubview:_leftGroup];
    
    [_leftGroup setBackgroundColor:[UIColor grayColor]];
    
    _scranButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    [_scranButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scranButton];
    
    [_scranButton addTarget:self action:@selector(touchAnyPoint:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/2-20, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    [_leftGroup addSubview:self.mTableView];
    [self.mTableView setDataSource:self];
    [self.mTableView setDelegate:self];
    [self.mTableView setBackgroundColor:[UIColor clearColor]];
    [self.mTableView setScrollEnabled:NO];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadAccountData];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)touchAnyPoint:(id)sender
{
    if (_backBlock) {
        _backBlock();
    }
}

-(void)loadAccountData
{
    NSArray* array=[[DBManager getInstance] queryAccountForType:1];
    if ([array count]>0) {
       _account=(AccountEntity*)[array objectAtIndex:0];
    }
    [self.mDatas removeAllObjects];
    [self.mDatas addObjectsFromArray:[[DBManager getInstance] queryAccountForType:0]];
    [self.mTableView reloadData];
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return [self.mDatas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 120.0f;
        default:
            return 60.0f;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        [cell.layer setCornerRadius:8.0f];
//        cell.layer.masksToBounds=YES;
    }
    cell.backgroundColor=[UIColor clearColor];
    switch (indexPath.section) {
        case 0:
        {
            if (_account) {
                UIImageView* avatarImg=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2-100)/2, 10, 80, 80)];
                avatarImg.image = [UIImage imageNamed:@"userbig.png"];
                [cell addSubview:avatarImg];
            
                UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH/2-20, 30)];
                lb.text=_account.userNick;
                lb.textAlignment=NSTextAlignmentCenter;
                
                [cell addSubview:lb];
            }
        }
            break;
        default:
        {
            AccountEntity * entity=[self.mDatas objectAtIndex:indexPath.row];
            if (entity) {
                UIImageView* avatarImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 48, 48)];
                avatarImg.image = [UIImage imageNamed:@"userbig.png"];
                [cell addSubview:avatarImg];
                
                UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(60, 15, SCREEN_WIDTH/2-20-60, 30)];
                lb.text=entity.userNick;
                [cell addSubview:lb];
            }
        }
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (_selectBlock) {
                _selectBlock(_account.aid);
            }
        }
            break;
        default:
        {
            AccountEntity* entity=[self.mDatas objectAtIndex:indexPath.row];
            if (entity&&_selectBlock) {
                _selectBlock(entity.aid);
            }
        }
            break;
    }
}



@end
