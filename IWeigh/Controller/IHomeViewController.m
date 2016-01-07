//
//  IHomeViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IHomeViewController.h"
#import "AppDelegate.h"
#import "HKeyboardTableView.h"
#import "ILoginViewController.h"
#import "IRegisterViewController.h"
#import "UIButton+Bootstrap.h"
#import <UMSocial.h>
#import <UMSocialSinaHandler.h>


@interface IHomeViewController ()<TencentSessionDelegate,UITextFieldDelegate>
{
    TencentOAuth            *tencentOAuth;
}
@end

@implementation IHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
//    UIBarButtonItem* backBtn=[[UIBarButtonItem alloc]init];
//    [backBtn setTitle:@"返回"];
//    [backBtn setTintColor:[UIColor whiteColor]];
//    self.navigationItem.backBarButtonItem=backBtn;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.tableView==nil) {
        self.tableView=[[HKeyboardTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.backgroundColor=RGBCOLOR(60, 193, 102);
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.tableView.delegate = (id<UITableViewDelegate>)self;
        self.tableView.dataSource = (id<UITableViewDataSource>)self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
    tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"100334902" andDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(IBAction)login:(id)sender
{
    ILoginViewController* dController=[[ILoginViewController alloc]init];
    [self.navigationController pushViewController:dController animated:YES];
}

-(IBAction)regRequest:(id)sender
{
    IRegisterViewController* dController=[[IRegisterViewController alloc]init];
    [self.navigationController pushViewController:dController animated:YES];
}

-(IBAction)qqLogin:(id)sender
{
    [tencentOAuth authorize:[NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, nil] inSafari:YES];
}

-(IBAction)weixinLogin:(id)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
    });
}

-(IBAction)weiboLogin:(id)sender
{
 
    UMSocialSnsPlatform* snsPlatfrom=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatfrom.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode==UMSResponseCodeSuccess) {
            UMSocialAccountEntity* snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            DLog(@"username is %@ uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 260.0f;
    }else if(indexPath.row==4){
        return 44;
    }else if(indexPath.row==3){
        if (self.view.frame.size.height>568) {
            return 60;
        }
        return 30.0f;
    }
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=RGBCOLOR(60, 193, 102);
    CGRect bounds=self.view.bounds;
    switch (indexPath.row) {
        case 0:
        {
            UIImageView* icon=[[UIImageView alloc]initWithFrame:CGRectMake((bounds.size.width-150)/2, 60, 150, 150)];
            [icon setImage:[UIImage imageNamed:@"logo.png"]];
            [cell addSubview:icon];
            break;
            
        }
        case 1:
        {
            self.loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.loginBtn setFrame:CGRectMake(20, 6, bounds.size.width-40, 48)];
            [self.loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
            [self.loginBtn setBackgroundColor:[UIColor grayColor]];
            [self.loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [self.loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.loginBtn greenStyle];
            [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:self.loginBtn];
        }
            break;
        case 2:
        {
            self.registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [self.registerBtn setFrame:CGRectMake(20, 6, bounds.size.width-40, 48)];
            [self.registerBtn setTitle:@"注  册" forState:UIControlStateNormal];
            [self.registerBtn setBackgroundColor:[UIColor grayColor]];
            [self.registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.registerBtn addTarget:self action:@selector(regRequest:) forControlEvents:UIControlEventTouchUpInside];
            [self.registerBtn greenStyle ];
            [cell addSubview:self.registerBtn];
        }
            break;
        case 4:
        {
            UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, bounds.size.width-40, 40)];
            [lb setText:@"第三方帐号登录"];
            [lb setTextAlignment:NSTextAlignmentCenter];
            [lb setFont:[UIFont systemFontOfSize:14.0]];
            
            [cell addSubview:lb];
            
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 43,bounds.size.width, 1)];
            [line setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:line];
        }
            break;
        case 5:
        {
            UIButton* qqBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [qqBtn setFrame:CGRectMake((bounds.size.width-180)/2, 20, 36, 36)];
            [qqBtn setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
            [qqBtn setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateHighlighted];
            [qqBtn addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:qqBtn];
           
            UIButton* wxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [wxBtn setFrame:CGRectMake((bounds.size.width-180)/2+60, 20, 36, 36)];
            [wxBtn setImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
            [wxBtn setImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateHighlighted];
            [wxBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:wxBtn];
            
            UIButton* wbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [wbBtn setFrame:CGRectMake((bounds.size.width-180)/2+120, 20, 36, 36)];
            [wbBtn setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
            [wbBtn setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateHighlighted];
            [wbBtn addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:wbBtn];
        }
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - tencentDidLogin
-(void)tencentDidLogin
{
    NSLog(@"tencentDidLogin");
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
    NSLog(@"tencentDidNotLogin");
}

-(void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
}

@end
