//
//  IForgotPwdViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/1/7.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IForgotPwdViewController.h"
#import "HKeyboardTableView.h"
#import <SMS_SDK/SMS_SDK.h>
#import "UIButton+Bootstrap.h"
#import "UIViewController+NavigationBarButton.h"
#import "StringUtils.h"

@interface IForgotPwdViewController ()<UITextFieldDelegate>
{
    bool            isCodeSender;
}

@end

@implementation IForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarButton];
    [self setCenterTitle:@"找出密码"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    isCodeSender=false;
    [self addRightButtonWithTitle:@"下一步" withSel:@selector(pwdRequest)];

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


-(void)pwdRequest
{
    
}

-(IBAction)codeRequest:(id)sender
{
    [self codeRequest];
}
-(void)codeRequest
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
            isCodeSender=YES;
            [self timeout];
        }
    }];

}

-(void)timeout
{
    __block int timeout=60;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
            });
        }else{
            int minutes=timeout/60;
            int seconds=timeout%60;
            NSString* strTime=[NSString stringWithFormat:@"%.2d秒",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_codeButton setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
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
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#define USER_FIELD  100
#define CODE_FIELD  200
#define AREACODE_FIELD 300

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
            self.userLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 26)];
            [self.userLabel setText:@"手机号"];
            [self.userLabel setTextAlignment:NSTextAlignmentLeft];
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
            self.codeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 26)];
            self.codeLabel.textAlignment=NSTextAlignmentLeft;
            self.codeLabel.text=@"验证码";
            [self.codeLabel setTextColor:[UIColor grayColor]];
            [leftView addSubview:self.codeLabel];
            self.codeField.leftViewMode=UITextFieldViewModeAlways;
            self.codeField.leftView=leftView;
            [cell addSubview:self.codeField];
            
            self.codeButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
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
        case 4:
        {
            
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
    int tag=[textField tag];
    
    if (tag==USER_FIELD&&[textField returnKeyType]==UIReturnKeyNext) {
        [self.codeField becomeFirstResponder];
        [self codeRequest];
    }else if(tag==CODE_FIELD&&[textField returnKeyType]==UIReturnKeyGo){
        DLog(@"password forgot ...");
        [self pwdRequest];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField tag]==AREACODE_FIELD) {
        [self.view endEditing:YES];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

@end
