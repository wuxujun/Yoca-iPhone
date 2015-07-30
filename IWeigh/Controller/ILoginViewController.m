//
//  ILoginViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "ILoginViewController.h"
#import "HKeyboardTableView.h"
#import "IForgotPwdViewController.h"
#import "IRegisterViewController.h"
#import "AppDelegate.h"
#import "HNetworkEngine.h"
#import "UIView+LoadingView.h"
#import "HCurrentUserContext.h"
#import "UIHelper.h"
#import "AccountEntity.h"
#import "IAccountDViewController.h"
#import "DBManager.h"
#import "UIButton+Bootstrap.h"
#import "UIViewController+NavigationBarButton.h"

@interface ILoginViewController ()<UITextFieldDelegate>

@end

@implementation ILoginViewController

-(id)init
{
    self=[super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"登录"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self addRightButtonWithTitle:@"注册" withSel:@selector(regRequest:)];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        [self.view addSubview:self.mTableView];
    }

    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.userField!=nil){
        DLog(@"viewDidAppear  /////");
        [self.userField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginRequest:(id)sender
{
    [self login];
}

-(void)login
{
    
    NSString *usernameStr = [self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr = [self.passField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *errorMeg;
    if (usernameStr.length == 0) {
        errorMeg = @"请输入用户帐号。";
    } else if (passwordStr.length == 0) {
        errorMeg = @"请输入用户密码。";
    }
    if (errorMeg) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMeg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        HCurrentUserContext *userContext = [HCurrentUserContext sharedInstance];
        __weak ILoginViewController *myself = self;
        [self.view showHUDLoadingView:YES];
        [userContext loginWithUserName:usernameStr password:passwordStr success:^(MKNetworkOperation *completedOperation, id result) {
            DLog(@"%@",result);
            [self loadHome:result];
//            if (self.completionBlock) {
//                self.completionBlock();
//            }
        } error:^(NSError *error) {
            [myself.view showHUDLoadingView:NO];
            [UIHelper showAlertMessage:error.domain];
            [self loadHome:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]];
        }];
    }
}

-(void)loadHome:(NSDictionary*)result
{
    id array=[result objectForKey:@"members"];
    if ([array isKindOfClass:[NSArray class]]) {
        for (int i=0; i<[array count]; i++) {
            if ([[DBManager getInstance] insertOrUpdateAccount:[array objectAtIndex:i]]) {
                DLog(@"Account insert or update success");
            }
        }
    }
    [self.view showHUDLoadingView:NO];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startMain) userInfo:nil repeats:NO];
}

-(void)startMain
{
    if ([[DBManager getInstance] queryAccountCountWithType:1]>0) {
        [ApplicationDelegate openTabMainView];
    }else{
        IAccountDViewController* dController=[[IAccountDViewController alloc]init];
        [dController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:@"填写用户信息",@"title",@"3",@"dataType",@"开始称重",@"buttonTitle", nil]];
        [self.navigationController pushViewController:dController animated:YES];
    }
}


-(IBAction)regRequest:(id)sender
{
    IRegisterViewController* dController=[[IRegisterViewController alloc]init];
    [self.navigationController pushViewController:dController animated:YES];
}

-(IBAction)passRequest:(id)sender
{
    IForgotPwdViewController* dController=[[IForgotPwdViewController alloc]init];
    [self.navigationController pushViewController:dController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

#define USER_FIELD  100
#define PASSWORD_FIELD 200

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=APP_TABLEBG_COLOR;
    CGRect bounds=self.view.frame;
    switch (indexPath.row) {
        case 0:
        {
            self.userInputBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, (80-46)/2-0.5, bounds.size.width-39, 47)];
            [ self.userInputBG setBackgroundColor:APP_FONT_COLOR];
            self.userInputBG.layer.masksToBounds=YES;
            self.userInputBG.layer.cornerRadius=5;
            [cell addSubview: self.userInputBG];
            
            self.userField=[[UITextField alloc] initWithFrame:CGRectMake(20, (80-46)/2, bounds.size.width-40, 46)];
            [self.userField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.userField setTextColor:APP_FONT_COLOR];
            [self.userField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.userField setTag:USER_FIELD];
            [self.userField setPlaceholder:@"请输入帐号"];
            [self.userField setBorderStyle:UITextBorderStyleNone];
            [self.userField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.userField setReturnKeyType:UIReturnKeyNext];
            [self.userField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.userField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.userField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            
            [self.userField.layer setMasksToBounds:YES];
            [self.userField.layer setCornerRadius:5.0f];
            
//            [self.userField setText:@"13958197001"];
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.userField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.userLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            [self.userLabel setText:@"帐号"];
            [self.userLabel setTextAlignment:NSTextAlignmentCenter];
            [self.userLabel setTextColor:APP_FONT_COLOR];
            [leftView addSubview:self.userLabel];
            
            self.userField.leftViewMode=UITextFieldViewModeAlways;
            self.userField.leftView=leftView;
            [self.userField setDelegate:self];
            [cell addSubview:self.userField];
            
            break;
        }
        case 1:
        {
            self.passInputBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, (80-46)/2-0.5, bounds.size.width-39, 47)];
            [self.passInputBG setBackgroundColor:APP_FONT_COLOR];
            self.passInputBG.layer.masksToBounds=YES;
            self.passInputBG.layer.cornerRadius=5;
            [cell addSubview:self.passInputBG];
            self.passField=[[UITextField alloc] initWithFrame:CGRectMake(20, (80-46)/2, bounds.size.width-40, 46)];
            [self.passField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.passField setTextColor:APP_FONT_COLOR];
            [self.passField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.passField setTag:PASSWORD_FIELD];
            [self.passField setPlaceholder:@"请输入密码"];
            [self.passField setBorderStyle:UITextBorderStyleNone];
            [self.passField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.passField setSecureTextEntry:YES];
            [self.passField setReturnKeyType:UIReturnKeyGo];
            [self.passField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.passField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.passField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            [self.passField.layer setMasksToBounds:YES];
            [self.passField.layer setCornerRadius:5.0f];
//            [self.passField setText:@"123456"];
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.passField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.passLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            [self.passLabel setText:@"密码"];
            [self.passLabel setTextAlignment:NSTextAlignmentCenter];
            [self.passLabel setTextColor:APP_FONT_COLOR];
            [leftView addSubview:self.passLabel];
            
            self.passField.leftViewMode=UITextFieldViewModeAlways;
            self.passField.leftView=leftView;
            
            [self.passField setDelegate:self];
            [cell addSubview:self.passField];
            break;
        }
        case 2:
        {
            self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [self.loginButton setFrame:CGRectMake(20, (80-48)/2, bounds.size.width-40, 48)];
            [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
            [self.loginButton setBackgroundColor:[UIColor greenColor]];
            [self.loginButton addTarget:self action:@selector(loginRequest:) forControlEvents:UIControlEventTouchUpInside];
            [self.loginButton greenStyle];
            [cell addSubview:self.loginButton];

        }
            break;
        case 3:
        {
            self.forgotButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.forgotButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [self.forgotButton setFrame:CGRectMake(bounds.size.width-120, 5, 100, 40)];
            [self.forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
            [self.forgotButton setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            [self.forgotButton setTitleColor:APP_FONT_COLOR_SEL forState:UIControlStateHighlighted];
            [self.forgotButton setBackgroundColor:[UIColor clearColor]];
            [self.forgotButton addTarget:self action:@selector(passRequest:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:self.forgotButton];
        }
            break;
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
    DLog(@"%@   %d",textField.text,[textField returnKeyType]);
    
    int tag=[textField tag];
    if (tag==USER_FIELD&&[textField returnKeyType]==UIReturnKeyNext) {
        if (self.passField) {
            [self.passField becomeFirstResponder];
        }
    }else if(tag==PASSWORD_FIELD&&[textField returnKeyType]==UIReturnKeyGo){
        DLog(@"login.....");
        [self login];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==PASSWORD_FIELD) {
        [self.passField setTextColor:APP_FONT_COLOR_SEL];
        [self.passLabel setTextColor:APP_FONT_COLOR_SEL];
        [self.passInputBG setBackgroundColor:APP_FONT_COLOR_SEL];
        [self.userField setTextColor:APP_FONT_COLOR];
        [self.userLabel setTextColor:APP_FONT_COLOR];
        [self.userInputBG setBackgroundColor:APP_FONT_COLOR];
    }else{
        [self.userField setTextColor:APP_FONT_COLOR_SEL];
        [self.userInputBG setBackgroundColor:APP_FONT_COLOR_SEL];
        [self.userLabel setTextColor:APP_FONT_COLOR_SEL];
        [self.passField setTextColor:APP_FONT_COLOR];
        [self.passInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.passLabel setTextColor:APP_FONT_COLOR];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag==PASSWORD_FIELD) {
        [self.passField setTextColor:APP_FONT_COLOR];
        [self.passLabel setTextColor:APP_FONT_COLOR];
        [self.passInputBG setBackgroundColor:APP_FONT_COLOR];
        
    }else{
        [self.userField setTextColor:APP_FONT_COLOR];
        [self.userInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.userLabel setTextColor:APP_FONT_COLOR];
    }
    return YES;
}



@end
