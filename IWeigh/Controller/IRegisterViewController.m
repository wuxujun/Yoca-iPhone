//
//  IRegisterViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IRegisterViewController.h"
#import "HKeyboardTableView.h"
#import "UIViewController+NavigationBarButton.h"
#import "AppDelegate.h"
#import "HNetworkEngine.h"
#import "UIView+LoadingView.h"
#import "HCurrentUserContext.h"
#import "UIHelper.h"
#import "StringUtils.h"
#import "UIButton+Bootstrap.h"

@interface IRegisterViewController ()<UITextFieldDelegate>
{
    bool            isCodeSender;
}

@end

@implementation IRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    [self setCenterTitle:@"用户注册"];
    [self addRightButtonWithTitle:@"清空" withSel:@selector(clear:)];
    
    isCodeSender=false;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.userField!=nil){
        [self.userField becomeFirstResponder];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(IBAction)clear:(id)sender
{
    if (self.userField) {
        [self.userField setText:@""];
    }
    if (self.passField) {
        [self.passField setText:@""];
    }
    
}

-(void)regRequest
{
    NSString *usernameStr = [self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr = [self.passField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *errorMeg;
    if (usernameStr.length == 0) {
        errorMeg = @"请输入手机号。";
    }else if(passwordStr.length==0){
        errorMeg=@"请输入密码.";
    }
    if (errorMeg) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMeg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        self.networkEngine=[[HNetworkEngine alloc]initWithHostName:nil customHeaderFields:nil];
        __weak IRegisterViewController *myself=self;
        [myself.view showHUDLoadingView:YES];
        [[HCurrentUserContext sharedInstance]registerWithUserName:usernameStr password:passwordStr email:@"" success:^(BOOL success) {
            if (success) {
                [UIHelper showAlertMessage:@"用户注册成功"];
                [myself.navigationController popViewControllerAnimated:YES];
            }
            [myself.view showHUDLoadingView:NO];
        } error:^(NSError *error) {
            ELog(error);
            [UIHelper showAlertMessage:error.domain];
            [myself.view showHUDLoadingView:NO];
        }];
    }
}

- (BOOL)checkEmail:(NSString *)emailStr
{
    NSString *regex        = @"^[a-zA-Z0-9_\\+-\\.]*(\\.[a-zA-Z0-9_\\+-]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.([a-zA-Z]{2,4})$";
    NSPredicate *pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch           = [pred evaluateWithObject:emailStr];
    return isMatch;
}

-(IBAction)codeRequest:(id)sender
{
    NSString* userStr=[self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* errorMsg;
    if (userStr.length==0) {
        errorMsg=@"请输入手机号";
        [self alertRequestResult:errorMsg isPop:NO];
        return;
    }
    if (![StringUtils checkTelNumber:userStr]) {
        errorMsg=@"手机号格式错误";
        [self alertRequestResult:errorMsg isPop:NO];
        return;
    }
    [SMS_SDK getVerificationCodeBySMSWithPhone:userStr zone:@"86" result:^(SMS_SDKError *error) {
        if (error) {
            [self alertRequestResult:error.errorDescription isPop:NO];
        }else{
            
        }
    }];
    
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

#define USER_FIELD  100
#define PASSWORD_FIELD 200
#define PASSWORD_FIELD2 300
#define CODE_FIELD      400

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
            
            self.userField=[[UITextField alloc] initWithFrame:CGRectMake(20,(80-46)/2, bounds.size.width-40, 46)];
            [self.userField setTextColor:APP_FONT_COLOR];
            [self.userField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.userField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.userField setTag:USER_FIELD];
            [self.userField setPlaceholder:@"请输入手机号"];
            [self.userField setBorderStyle:UITextBorderStyleRoundedRect];
            [self.userField setFont:[UIFont systemFontOfSize:14.0f]];
            [self.userField setReturnKeyType:UIReturnKeyNext];
            [self.userField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.userField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.userField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            [self.userField.layer setMasksToBounds:YES];
            [self.userField.layer setCornerRadius:5.0f];
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.userField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.userLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            [self.userLabel setText:@"手机号"];
            [self.userLabel setTextAlignment:NSTextAlignmentCenter];
            [self.userLabel setTextColor:APP_FONT_COLOR];
            [leftView addSubview:self.userLabel];
            
            self.userField.leftViewMode=UITextFieldViewModeAlways;
            self.userField.leftView=leftView;
            [self.userField setDelegate:self];
            [cell addSubview:self.userField];
        }
            break;
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
            [self.passField setBorderStyle:UITextBorderStyleRoundedRect];
            [self.passField setFont:[UIFont systemFontOfSize:14.0f]];
            [self.passField setSecureTextEntry:YES];
            [self.passField setReturnKeyType:UIReturnKeyNext];
            [self.passField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.passField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.passField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            
            [self.passField.layer setMasksToBounds:YES];
            [self.passField.layer setCornerRadius:5.0f];
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.passField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.passLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            self.passLabel.textAlignment=NSTextAlignmentCenter;
            self.passLabel.text=@"密码";
            [self.passLabel setTextColor:[UIColor grayColor]];
            [leftView addSubview:self.passLabel];
            
            self.passField.leftViewMode=UITextFieldViewModeAlways;
            self.passField.leftView=leftView;
            
            [self.passField setDelegate:self];
            [cell addSubview:self.passField];
            
        }
            break;
        case 2:
        {
            self.codeInputBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, (80-46)/2-0.5, bounds.size.width-139, 47)];
            [self.codeInputBG setBackgroundColor:APP_FONT_COLOR];
            self.codeInputBG.layer.masksToBounds=YES;
            self.codeInputBG.layer.cornerRadius=5;
            [cell addSubview:self.codeInputBG];
            
            self.codeField=[[UITextField alloc] initWithFrame:CGRectMake(20, (80-46)/2, bounds.size.width-140, 46)];
            [self.codeField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.codeField setTextColor:APP_FONT_COLOR];
            [self.codeField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.codeField setTag:CODE_FIELD];
            [self.codeField setPlaceholder:@"验证码"];
            [self.codeField setBorderStyle:UITextBorderStyleRoundedRect];
            [self.codeField setFont:[UIFont systemFontOfSize:14.0f]];
            [self.codeField setReturnKeyType:UIReturnKeyGo];
            [self.codeField setDelegate:self];
            [self.codeField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            [self.codeField.layer setMasksToBounds:YES];
            [self.codeField.layer setCornerRadius:5.0f];
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.codeField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.codeLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            self.codeLabel.textAlignment=NSTextAlignmentCenter;
            self.codeLabel.text=@"验证码";
            [self.codeLabel setTextColor:[UIColor grayColor]];
            [leftView addSubview:self.codeLabel];
            self.codeField.leftViewMode=UITextFieldViewModeAlways;
            self.codeField.leftView=leftView;
            [cell addSubview:self.codeField];
            
            self.codeButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.codeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
            [self.codeButton setFrame:CGRectMake(bounds.size.width-100, (80-46)/2, 80, 46)];
            [self.codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
            [self.codeButton greenStyle];
            if (isCodeSender) {
                [self.codeButton setEnabled:NO];
            }else{
                [self.codeButton setEnabled:YES];
            }
            [self.codeButton addTarget:self action:@selector(codeRequest:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:self.codeButton];
        }
            break;
        case 3:
        {
            self.regButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.regButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [self.regButton setFrame:CGRectMake(20, (80-46)/2, bounds.size.width-40, 46)];
            [self.regButton setTitle:@"注册" forState:UIControlStateNormal];
            [self.regButton greenStyle];
            if (isCodeSender) {
                [self.regButton setEnabled:YES];
            }else{
                [self.regButton setEnabled:NO];
            }
            [self.regButton addTarget:self action:@selector(regRequest) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.regButton];
            
        }
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int tag=[textField tag];
    if (tag==USER_FIELD&&[textField returnKeyType]==UIReturnKeyNext) {
        if (self.passField) {
            [self.passField becomeFirstResponder];
        }
    }else if(tag==PASSWORD_FIELD&&[textField returnKeyType]==UIReturnKeyNext){
        DLog(@"get code");
    }else if(tag==CODE_FIELD&&[textField returnKeyType]==UIReturnKeyGo){
        DLog(@"register ...");
        [self regRequest];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==USER_FIELD) {
        [self.userField setTextColor:APP_FONT_COLOR_SEL];
        [self.userInputBG setBackgroundColor:APP_FONT_COLOR_SEL];
        [self.userLabel setTextColor:APP_FONT_COLOR_SEL];
        
        [self.passField setTextColor:APP_FONT_COLOR];
        [self.passInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.passLabel setTextColor:APP_FONT_COLOR];
        
        [self.codeField setTextColor:APP_FONT_COLOR];
        [self.codeInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.codeLabel setTextColor:APP_FONT_COLOR];
        
    }else if (textField.tag==PASSWORD_FIELD){
        [self.userField setTextColor:APP_FONT_COLOR];
        [self.userInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.userLabel setTextColor:APP_FONT_COLOR];
        
        [self.passField setTextColor:APP_FONT_COLOR_SEL];
        [self.passInputBG setBackgroundColor:APP_FONT_COLOR_SEL];
        [self.passLabel setTextColor:APP_FONT_COLOR_SEL];
        
        [self.codeField setTextColor:APP_FONT_COLOR];
        [self.codeInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.codeLabel setTextColor:APP_FONT_COLOR];
    }else{
        [self.userField setTextColor:APP_FONT_COLOR];
        [self.userInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.userLabel setTextColor:APP_FONT_COLOR];
        
        [self.passField setTextColor:APP_FONT_COLOR];
        [self.passInputBG setBackgroundColor:APP_FONT_COLOR];
        [self.passLabel setTextColor:APP_FONT_COLOR];
        
        [self.codeField setTextColor:APP_FONT_COLOR_SEL];
        [self.codeInputBG setBackgroundColor:APP_FONT_COLOR_SEL];
        [self.codeLabel setTextColor:APP_FONT_COLOR_SEL];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

@end
