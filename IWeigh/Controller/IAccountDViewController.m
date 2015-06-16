//
//  IAccountDViewController.m
//  IWeigh
//
//  Created by xujunwu on 15/2/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "IAccountDViewController.h"
#import "INavigationController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIViewController+REFrostedViewController.h"
#import "HKeyboardTableView.h"
#import "AccountEntity.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import <REFormattedNumberField.h>
#import "ITargetViewController.h"
#import "StringUtil.h"
#import "DBHelper.h"
#import "DBManager.h"
#import "PathHelper.h"
#import "UIButton+Bootstrap.h"

@interface IAccountDViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    bool        bSex;
    
    
    NSString        *fileName;
    NSString        *filePath;
    
    NSString*   mUserNick;
    NSString*   mBirthday;
    NSInteger   nHeight;
    NSInteger   nAge;
    
    NSInteger   nId;
}

@property(nonatomic,strong)UIButton*    dateButton;

@end

@implementation IAccountDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    
    bSex=false;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    int dataType=0;
    nId=1;
    if (self.infoDict) {
        dataType=[[self.infoDict objectForKey:@"dataType"] intValue];
        [self setCenterTitle:[self.infoDict objectForKey:@"title"]];
        nId=[[self.infoDict objectForKey:@"dataIndex"] integerValue];
    }
    if (dataType==0) {
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_left"] style:UIBarButtonItemStylePlain target:(INavigationController*)self.navigationController action:@selector(showMenu)];
    }
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if (dataType>=1) {
        [self addRightButtonWithTitle:@"目标" withSel:@selector(addTarget:)];
    }

    CGRect frame=self.view.bounds;
    if (dataType==3) {
        frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    }
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_TABLEBG_COLOR;
        self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate = (id<UITableViewDelegate>)self;
        self.mTableView.dataSource = (id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    if (dataType==2){
        AccountEntity* entity=(AccountEntity*)[DBHelper queryOne:[AccountEntity class] sql:@"SELECT * FROM t_account where id=?" params:@[[NSString stringWithFormat:@"%ld",nId]]];
        if (entity) {
            nId=entity.aid;
            bSex=entity.sex==0?false:true;
            mBirthday=entity.birthday;
            mUserNick=entity.userNick;
            nHeight=entity.height;
            fileName=entity.avatar;
        }
    }
    
    if (self.dateButton==nil) {
        self.dateButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 58)];
        [self.dateButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(IBAction)hideButton:(id)sender
{
    [self hideKey];
    
    UIButton* btn=(UIButton*)sender;
    [btn setHidden:YES];
}

-(IBAction)addTarget:(id)sender
{
    ITargetViewController* dController=[[ITargetViewController alloc]init];
    if (nId>0) {
        dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",nId],@"dataIndex", nil];
    }
    [self.navigationController pushViewController:dController animated:YES];
}


-(IBAction)sexSelected:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if (btn.tag==SEX_FAMALE_BTN) {
        [self.femaleButton setBackgroundColor:APP_FONT_COLOR_SEL];
        [self.maleButton setBackgroundColor:[UIColor grayColor]];
        bSex=false;
    }else{
        [self.femaleButton setBackgroundColor:[UIColor grayColor]];
        [self.maleButton setBackgroundColor:APP_FONT_COLOR_SEL];
        bSex=true;
    }
}

-(IBAction)startWeigh:(id)sender
{
    if (mUserNick==nil) {
        [self alertRequestResult:@"请输入昵称" isPop:NO];
        return;
    }
    if (mBirthday==nil) {
        [self alertRequestResult:@"请选择生日" isPop:NO];
        return;
    }
    if (nHeight==0) {
        [self alertRequestResult:@"请输入身高" isPop:NO];
        return;
    }
    
    if (self.infoDict) {
        if ([[self.infoDict objectForKey:@"dataType"] integerValue]==0) {
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            [homeViewController setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:mUserNick,@"title",@"0",@"type",[NSString stringWithFormat:@"%ld",nAge],@"age",[NSString stringWithFormat:@"%ld",nHeight],@"height",[NSString stringWithFormat:@"%d",bSex?1:0],@"sex", nil]];
            INavigationController *navigationController = [[INavigationController alloc] initWithRootViewController:homeViewController];
            self.frostedViewController.contentViewController = navigationController;
        }else{
            if ([[self.infoDict objectForKey:@"dataType"] integerValue]==2) {
                AccountEntity* entity=(AccountEntity*)[DBHelper queryOne:[AccountEntity class] sql:@"SELECT * FROM t_account WHERE id=?" params:@[[NSString stringWithFormat:@"%ld",nId]]];
                if (entity) {
                    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
                    [dict setObject:[NSString stringWithFormat:@"%d",bSex] forKey:@"sex"];
                    [dict setObject:mUserNick forKey:@"userNick"];
                    [dict setObject:mBirthday forKey:@"birthday"];
                    [dict setObject:[NSString stringWithFormat:@"%ld",nAge] forKey:@"age"];
                    [dict setObject:[NSString stringWithFormat:@"%ld",nHeight] forKey:@"height"];
                    if (fileName) {
                        [dict setObject:fileName forKey:@"avatar"];
                    }
                    [dict setObject:[NSString stringWithFormat:@"%ld",entity.aid] forKey:@"id"];
                    DLog(@"%@",dict);
                    if ([[DBManager getInstance] insertOrUpdateAccount:dict]) {
                        NSLog(@"%@ user account update success.",mUserNick);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
            }else{
                NSInteger rows=[[DBManager getInstance] queryAccountCountWithType:1];
                NSMutableDictionary *entity=[NSMutableDictionary dictionary];
                if (rows==0) {
                    [entity setObject:@"1" forKey:@"type"];
                }
                [entity setObject:mUserNick?mUserNick:@"" forKey:@"userNick"];
                [entity setObject:[NSString stringWithFormat:@"%ld",nHeight] forKey:@"height"];
                [entity setObject:mBirthday?mBirthday:@"" forKey:@"birthday"];
                [entity setObject:[NSString stringWithFormat:@"%ld",nAge] forKey:@"age"];
                [entity setObject:[NSString stringWithFormat:@"%d",bSex?1:0] forKey:@"sex"];
                if([[DBManager getInstance] insertOrUpdateAccount:entity]){
                    if ([[self.infoDict objectForKey:@"dataType"] integerValue]==3) {
                        [ApplicationDelegate openMainView];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)showCamera:(id)sender
{
//    [self showImagePicker:YES];
    
    if (IOS_VERSION_8_OR_ABOVE) {
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction* cameraAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showImagePicker:YES];
        }];
        
        UIAlertAction* photoAction=[UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showImagePicker:NO];
        }];
        
        [alert addAction:cancelAction];
        BOOL hasCamera=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (hasCamera) {
            [alert addAction:cameraAction];
        }
        [alert addAction:photoAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }else{
        UIActionSheet* sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册获取", nil];
        sheet.actionSheetStyle=UIActionSheetStyleAutomatic;
        sheet.tag=101;
        [sheet showInView:self.view];
    }
    
}

-(void)showImagePicker:(BOOL)isCamera
{
    BOOL hasCamera=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        [self alertRequestResult:@"对不起,拍照功能不支持" isPop:NO];
    }
    UIImagePickerController* dController=[[UIImagePickerController alloc]init];
    dController.delegate=self;
    if (hasCamera&&isCamera) {
        dController.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{
        dController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:dController animated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSString* mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *curTime=[formatter stringFromDate:[NSDate date] ];
    if ([mediaType isEqualToString:@"public.image"]) {
        fileName=[NSString stringWithFormat:@"%@.jpg",curTime];
        filePath=[PathHelper filePathInDocument:fileName];
        UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 0.8) attributes:nil];
        if (self.avatarImageView) {
            [self.avatarImageView setImage:[UIImage imageNamed:filePath]];
        }
    }
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
        return 140.0;
    }
    return 60.0f;
}

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
            self.avatarImageView=[[UIImageView alloc]initWithFrame:CGRectMake((bounds.size.width-100)/2, 20, 100, 100)];
            [self.avatarImageView setImage:[UIImage imageNamed:@"userbig.png"]];
            [cell addSubview:self.avatarImageView];
            if (fileName&&[PathHelper fileExistsAtPath:fileName]) {
                [self.avatarImageView setImage:[UIImage imageNamed:[PathHelper filePathInDocument:fileName]]];
            }
            
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake((bounds.size.width-100)/2, 20, 100, 100)];
            [btn addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
            break;
        case 1:
        {
            self.femaleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.femaleButton setTag:SEX_FAMALE_BTN];
            [self.femaleButton setFrame:CGRectMake(20, 10, (bounds.size.width-50)/2, 40)];
            [self.femaleButton setBackgroundColor:APP_FONT_COLOR_SEL];
            [self.femaleButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [self.femaleButton setTitle:@"女" forState:UIControlStateNormal];
            [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [self.femaleButton addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.femaleButton greenStyle];
            [cell addSubview:self.femaleButton];
            self.maleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.maleButton setTag:SEX_MALE_BTN];
            [self.maleButton setBackgroundColor:[UIColor grayColor]];
            [self.maleButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [self.maleButton setFrame:CGRectMake((bounds.size.width-50)/2+30, 10, (bounds.size.width-50)/2, 40)];
            [self.maleButton setTitle:@"男" forState:UIControlStateNormal];
            [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [self.maleButton addTarget:self action:@selector(sexSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.maleButton defaultStyle];
            
            [cell addSubview:self.maleButton];
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
            
            break;
        }
        case 3:
        {
            self.birthdayInputBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, (60-46)/2-0.5, bounds.size.width-39, 47)];
            [ self.birthdayInputBG setBackgroundColor:APP_FONT_COLOR];
            self.birthdayInputBG.layer.masksToBounds=YES;
            self.birthdayInputBG.layer.cornerRadius=5;
            [cell addSubview: self.birthdayInputBG];
            
            self.birthdayField=[[UITextField alloc] initWithFrame:CGRectMake(20, (60-46)/2, bounds.size.width-40, 46)];
            [self.birthdayField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.birthdayField setTextColor:APP_FONT_COLOR];
            [self.birthdayField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.birthdayField setTag:INPUT_BIRTHDAY];
            [self.birthdayField setPlaceholder:@"请选择生日"];
            [self.birthdayField setBorderStyle:UITextBorderStyleNone];
            [self.birthdayField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.birthdayField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.birthdayField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.birthdayField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            
            [self.birthdayField.layer setMasksToBounds:YES];
            [self.birthdayField.layer setCornerRadius:5.0f];
            if (mBirthday) {
                [self.birthdayField setText:mBirthday];
            }
            [self.birthdayField endEditing:NO];
            [self.birthdayField setReturnKeyType:UIReturnKeyDone];
            [self.birthdayField addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventEditingDidBegin];
            
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.birthdayField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.birthdayLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            [self.birthdayLabel setText:@"生日"];
            [self.birthdayLabel setTextAlignment:NSTextAlignmentCenter];
            [self.birthdayLabel setTextColor:APP_FONT_COLOR];
            [leftView addSubview:self.birthdayLabel];
            
            self.birthdayField.leftViewMode=UITextFieldViewModeAlways;
            self.birthdayField.leftView=leftView;
            [self.birthdayField setDelegate:self];
            [cell addSubview:self.birthdayField];
            
            if (self.dateButton) {
                [cell addSubview:self.dateButton];
            }
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
            break;
        }
        case 2:
        {
            self.nickInputBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, (60-46)/2-0.5, bounds.size.width-39, 47)];
            [ self.nickInputBG setBackgroundColor:APP_FONT_COLOR];
            self.nickInputBG.layer.masksToBounds=YES;
            self.nickInputBG.layer.cornerRadius=5;
            [cell addSubview: self.nickInputBG];
            
            self.nickField=[[UITextField alloc] initWithFrame:CGRectMake(20, (60-46)/2, bounds.size.width-40, 46)];
            [self.nickField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.nickField setTextColor:APP_FONT_COLOR];
            [self.nickField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.nickField setTag:INPUT_NICK];
            [self.nickField setPlaceholder:@"请输入昵称"];
            [self.nickField setBorderStyle:UITextBorderStyleNone];
            [self.nickField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.nickField setReturnKeyType:UIReturnKeyNext];
            [self.nickField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.nickField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.nickField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            if (mUserNick) {
                [self.nickField setText:mUserNick];
            }
            [self.nickField.layer setMasksToBounds:YES];
            [self.nickField.layer setCornerRadius:5.0f];
            
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.nickField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.nickLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            [self.nickLabel setText:@"昵称"];
            [self.nickLabel setTextAlignment:NSTextAlignmentCenter];
            [self.nickLabel setTextColor:APP_FONT_COLOR];
            [leftView addSubview:self.nickLabel];
            
            self.nickField.leftViewMode=UITextFieldViewModeAlways;
            self.nickField.leftView=leftView;
            [self.nickField setDelegate:self];
            [cell addSubview:self.nickField];
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
            break;
        }

        case 4:
        {
            self.heightInputBG=[[UIView alloc]initWithFrame:CGRectMake(19.5, (60-46)/2-0.5, bounds.size.width-39, 47)];
            [ self.heightInputBG setBackgroundColor:APP_FONT_COLOR];
            self.heightInputBG.layer.masksToBounds=YES;
            self.heightInputBG.layer.cornerRadius=5;
            [cell addSubview: self.heightInputBG];
            
            self.heightField=[[UITextField alloc] initWithFrame:CGRectMake(20, (60-46)/2, bounds.size.width-40, 46)];
            [self.heightField setBackgroundColor:APP_TABLEBG_COLOR];
            [self.heightField setTextColor:APP_FONT_COLOR];
            [self.heightField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [self.heightField setTag:INPUT_HEIGHT];
            [self.heightField setPlaceholder:@"请输入身高"];
            [self.heightField setBorderStyle:UITextBorderStyleNone];
            [self.heightField setFont:[UIFont systemFontOfSize:16.0f]];
            [self.heightField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.heightField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.heightField setValue:APP_FONT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            
            [self.heightField.layer setMasksToBounds:YES];
            [self.heightField.layer setCornerRadius:5.0f];
            [self.heightField setText:[NSString stringWithFormat:@"%ld",nHeight]];
            [self.heightField setReturnKeyType:UIReturnKeyGo];
            [self.heightField setKeyboardType:UIKeyboardTypePhonePad];
            
            
            UIView *leftView=[[UIView alloc]init];
            CGRect frame=self.heightField.frame;
            frame.size.width=60;
            [leftView setFrame:frame];
            self.heightLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 26)];
            [self.heightLabel setText:@"身高"];
            [self.heightLabel setTextAlignment:NSTextAlignmentCenter];
            [self.heightLabel setTextColor:APP_FONT_COLOR];
            [leftView addSubview:self.heightLabel];
            
            self.heightField.leftViewMode=UITextFieldViewModeAlways;
            self.heightField.leftView=leftView;
            [self.heightField setDelegate:self];
            [cell addSubview:self.heightField];
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, bounds.size.width, 0.5)];
            [img setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:img];
            [cell sendSubviewToBack:img];
            break;
        }

        case 5:
        {
            self.startButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.startButton setFrame:CGRectMake(20, 10, bounds.size.width-40, 40)];
            [self.startButton greenStyle];
            [self.startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [self.startButton setTitle:@"保存" forState:UIControlStateNormal];
            if (self.infoDict) {
                [self.startButton setTitle:[self.infoDict objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
            }
            [self.startButton addTarget:self action:@selector(startWeigh:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.startButton];
            break;
        }
        default:
        
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - 日期选择框
-(void)didChangeDate:(id)sender
{
    [self hideKey];
    
    UITextField *field=(UITextField*)sender;
    [field resignFirstResponder];
    if (IOS_VERSION_8_OR_ABOVE) {
        UIAlertController* alertController=[UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePicker.backgroundColor=[UIColor whiteColor];
        datePicker.tag=101;
        [datePicker setMaximumDate:[NSDate date]];
        UIAlertAction * canelAction=[UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMdd";
            NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timezone];
            
            NSString *dateTemp=[formatter stringFromDate:datePicker.date];
            nAge=[NSString ageWithDateOfBirth:datePicker.date];
            mBirthday=dateTemp;
            [self.mTableView reloadData];
        }];
        
        [alertController.view addSubview:datePicker];
        [alertController addAction:canelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }else{
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
        sheet.tag=100;
        sheet.actionSheetStyle=UIActionSheetStyleAutomatic;
        
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePicker.tag=101;
        [datePicker setMaximumDate:[NSDate date]];
        [sheet addSubview:datePicker];
        [sheet showInView:self.view];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==100) {
        UIDatePicker  *datePick=(UIDatePicker*)[actionSheet viewWithTag:101];
        if (datePick) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMdd";
            NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timezone];
        
            NSString *dateTemp=[formatter stringFromDate:datePick.date];
            nAge=[NSString ageWithDateOfBirth:datePick.date];
            mBirthday=dateTemp;
        }
        [self.mTableView reloadData];
    }else if(actionSheet.tag==101){
        DLog("%ld  %ld",(long)actionSheet.tag,(long)buttonIndex);
        if (buttonIndex==0) {
            [self showImagePicker:YES];
        }else if(buttonIndex==1){
            [self showImagePicker:NO];
        }
    }
}

-(BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DLog(@"%@",textField);
    if (textField.tag==INPUT_NICK||textField.tag==INPUT_HEIGHT) {
        [[self valueForKey:@"dateButton"] setHidden:NO];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    DLog(@"%@",textField);
    if (textField.tag==INPUT_NICK||textField.tag==INPUT_BIRTHDAY) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int tag=textField.tag;
    if (tag==INPUT_HEIGHT&&range.location==3) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag=textField.tag;
    if (tag==INPUT_NICK) {
        mUserNick=textField.text;
    }else if(tag==INPUT_BIRTHDAY){
        mBirthday=textField.text;
    }else if(tag==INPUT_HEIGHT){
        nHeight=[textField.text integerValue];
    }
}

-(void)hideKey
{
    for (UIView *view in self.mTableView.subviews) {
        if (iOS_VERSION_7) {
            for (UIView *v in view.subviews) {
                if ([v isKindOfClass:[UITableViewCell class]]) {
                    for (UIView *v1 in v.subviews) {
                        DLog(@"%@",v1);
                        if ([v1 isKindOfClass:[UITextField class]]) {
                            [v1 resignFirstResponder];
                        }else{
                            for (UIView *v2 in v1.subviews) {
                                if ([v2 isKindOfClass:[UITextField class]]) {
                                    [(UITextField*)v2 resignFirstResponder];
                                }
                            }
                        }
                    }
                }
            }
            
        }else{
            if ([view isKindOfClass:[UITableViewCell class]]) {
                for (UIView *v1 in view.subviews) {
                    if ([v1 isKindOfClass:[UITextField class]]) {
                        [(UITextField*)v1 resignFirstResponder];
                    }
                }
            }
        }
    }
}
@end
