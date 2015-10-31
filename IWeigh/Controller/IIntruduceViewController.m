//
//  IIntruduceViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/10/21.
//  Copyright © 2015年 ___xujun___. All rights reserved.
//

#import "IIntruduceViewController.h"
#import "DMLazyScrollView.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "UserDefaultHelper.h"

@interface IIntruduceViewController ()<DMLazyScrollViewDelegate>
{
    DMLazyScrollView        *mScrollView;
    NSMutableArray          *photoDatas;
    NSMutableArray          *viewControllerArray;
    
    NSInteger               currentPage;
    NSInteger               endPage;
    
}

@end

@implementation IIntruduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    photoDatas=[[NSMutableArray alloc]init];
    viewControllerArray=[[NSMutableArray alloc]init];
    for (NSUInteger k=0 ; k<10; ++k) {
        [viewControllerArray addObject:[NSNull  null]];
    }
    
    if (mScrollView==nil) {
        mScrollView=[[DMLazyScrollView alloc]initWithFrame:self.view.bounds];
        mScrollView.controlDelegate=self;
        [mScrollView setEnableCircularScroll:NO];
        [mScrollView setAutoPlay:NO];
        [self.view addSubview:mScrollView];
    }
    
    UIButton* back=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-70, 100, 60)];
    [back setTitle:@"跳过" forState:UIControlStateNormal];
    [back.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(onOpenHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    

    __weak __typeof(&*self)weakSel=self;
    mScrollView.dataSource=^(NSUInteger index){
        return [weakSel controllerAtIndex:index];
    };
    
}

-(IBAction)onOpenHome:(id)sender
{
    [self openHomeView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadData
{
    [photoDatas removeAllObjects];
    for (int i=0; i<4; i++) {
        NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"dataType",[NSString stringWithFormat:@"intruduce%d",i],@"image", nil];
        [photoDatas addObject:dict];
    }
    mScrollView.numberOfPages=[photoDatas count];
}

-(UIViewController*)controllerAtIndex:(NSInteger)idx
{
    if (idx>photoDatas.count||idx<0) {
        return nil;
    }
    id res=[viewControllerArray objectAtIndex:idx%10];
    NSDictionary* dict=[photoDatas objectAtIndex:idx];
    if (res==[NSNull null]) {
        PhotoViewController* dController=[[PhotoViewController alloc]init];
        dController.infoDict=dict;
        [viewControllerArray replaceObjectAtIndex:idx%10 withObject:dController];
        return dController;
    }
    [(PhotoViewController*)res setInfoDict:dict];
    [(PhotoViewController*)res refresh];
    return res;
}

-(void)lazyScrollView:(DMLazyScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex
{
    currentPage=currentPageIndex;
    endPage=0;
}

-(void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex
{
    if (pageIndex==currentPage) {
        endPage++;
    }
    if (endPage==2) {
        [self performSelector:@selector(openHomeView) withObject:nil afterDelay:0.2];
    }
}

-(void)openHomeView
{
    [UserDefaultHelper setObject:[NSNumber numberWithBool:false] forKey:CONF_FIRST_START];
    [ApplicationDelegate openHomeView];
}


@end
