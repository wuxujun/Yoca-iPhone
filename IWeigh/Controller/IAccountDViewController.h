//
//  IAccountDViewController.h
//  IWeigh
//
//  Created by xujunwu on 15/2/13.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "BaseViewController.h"

#define SEX_FAMALE_BTN      100
#define SEX_MALE_BTN        200

#define INPUT_NICK          300
#define INPUT_BIRTHDAY      400
#define INPUT_HEIGHT        500

@interface IAccountDViewController : BaseViewController

@property(nonatomic,strong)NSDictionary*        infoDict;
@property (nonatomic,strong)UIImageView         *avatarImageView;
@property (nonatomic,strong)UIButton            *femaleButton;
@property (nonatomic,strong)UIButton            *maleButton;
@property (nonatomic,strong)UIButton            *startButton;

@property(nonatomic,strong)UITextField          *nickField;
@property(nonatomic,strong)UILabel              *nickLabel;
@property(nonatomic,strong)UIView               *nickInputBG;

@property(nonatomic,strong)UITextField          *birthdayField;
@property(nonatomic,strong)UILabel              *birthdayLabel;
@property(nonatomic,strong)UIView               *birthdayInputBG;

@property(nonatomic,strong)UITextField          *heightField;
@property(nonatomic,strong)UILabel              *heightLabel;
@property(nonatomic,strong)UIView               *heightInputBG;


@end
