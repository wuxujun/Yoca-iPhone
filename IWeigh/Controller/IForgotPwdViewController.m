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
#import "UIViewController+NavigationBarButton.h"

@interface IForgotPwdViewController ()<UITextFieldDelegate>

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

-(void)codeRequest
{
    [SMS_SDK getVerifyCodeByPhoneNumber:@"13958197001" AndZone:@"+86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        DLog(@"%d",state);
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
    CGRect bounds=self.view.frame;
    switch (indexPath.row) {
        case 0:
        {
            UILabel* uLabel=[[UILabel alloc]init];
            [uLabel setFrame:CGRectMake(20, (58-26)/2, 80, 26)];
            [uLabel setText:@"手机号"];
            [uLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [cell addSubview:uLabel];
            
            UITextField* areaField=[[UITextField alloc] initWithFrame:CGRectMake(80, (58-36)/2, 59, 36)];
            [areaField setBackground:[[UIImage imageNamed:@"long_input_bg"] stretchableImageWithLeftCapWidth:50 topCapHeight:50]];
            [areaField setTag:AREACODE_FIELD];
            [areaField setText:@"+86"];
            [areaField setEnabled:NO];
            [areaField setBorderStyle:UITextBorderStyleNone];
            [areaField setFont:[UIFont systemFontOfSize:16.0f]];
            [areaField setReturnKeyType:UIReturnKeyNext];
            [cell addSubview:areaField];
            
            
            self.userField=[[UITextField alloc] initWithFrame:CGRectMake(140, (58-36)/2, 160, 36)];
            [self.userField setBackground:[[UIImage imageNamed:@"long_input_bg"] stretchableImageWithLeftCapWidth:50 topCapHeight:50]];
            [self.userField setTag:USER_FIELD];
            [self.userField setPlaceholder:@"请输入手机号"];
            [self.userField setBorderStyle:UITextBorderStyleNone];
            [self.userField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.userField setReturnKeyType:UIReturnKeyNext];
            [self.userField setKeyboardType:UIKeyboardTypePhonePad];
        
            
            [self.userField setDelegate:self];
            [cell addSubview:self.userField];
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, bounds.size.width, 1)];
            [img setImage:[UIImage imageNamed:@"contentview_topline"]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
        }
            break;
        case 1:
        {
            UILabel* uLabel=[[UILabel alloc]init];
            [uLabel setFrame:CGRectMake(20, (58-26)/2, 80, 26)];
            [uLabel setText:@"验证码"];
            [uLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [cell addSubview:uLabel];
            
            self.codeField=[[UITextField alloc] initWithFrame:CGRectMake(80, (58-36)/2, 100, 36)];
            [self.codeField setBackground:[[UIImage imageNamed:@"long_input_bg"] stretchableImageWithLeftCapWidth:50 topCapHeight:50]];
            [self.codeField setTag:CODE_FIELD];
            [self.codeField setBorderStyle:UITextBorderStyleNone];
            [self.codeField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.codeField setReturnKeyType:UIReturnKeyGo];
            [self.codeField setKeyboardType:UIKeyboardTypeNumberPad];
            [self.codeField setDelegate:self];
            [cell addSubview:self.codeField];
            
            
            self.codeButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.codeButton setFrame:CGRectMake(200, (58-36)/2, 100, 36)];
            [self.codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
            [self.codeButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.codeButton setBackgroundColor:[UIColor grayColor]];
            [self.codeButton addTarget:self action:@selector(codeRequest) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:self.codeButton];
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, bounds.size.width, 1)];
            [img setImage:[UIImage imageNamed:@"contentview_topline"]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
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
