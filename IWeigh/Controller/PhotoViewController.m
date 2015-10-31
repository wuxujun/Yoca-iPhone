//
//  PhotoViewController.m
//  Parking
//
//  Created by xujunwu on 15/10/9.
//  Copyright © 2015年 ___Hongkui___. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppConfig.h"

@interface PhotoViewController ()
{
    UIImageView*        imageView;
}
@end

@implementation PhotoViewController
@synthesize infoDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setContentMode:UIViewContentModeScaleToFill];
//    [imageView sizeToFit];
    
    [self.view addSubview:imageView];
    
    if (self.infoDict) {
        if ([self.infoDict objectForKey:@"url"]) {
            imageView.frame=CGRectMake(0, 0, self.view.frame.size.width, 180);
        }else{
            if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"2"]) {
                [imageView setImage:[UIImage imageNamed:@"intruduce0"]];
            }else if([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"1"]){
                imageView.frame=CGRectMake(0, 0, self.view.frame.size.width, 180);
                [imageView setImage:[UIImage imageNamed:[self.infoDict objectForKey:@"image"]]];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.infoDict) {
        if ([self.infoDict objectForKey:@"url"]) {
                [imageView setImageWithURL:[NSURL URLWithString:[self.infoDict objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"parking"]];
        }else{
            if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"2"]) {
                [imageView setImage:[UIImage imageNamed:[self.infoDict objectForKey:@"image"]]];
            }
        }
    }
}

-(void)refresh
{
    if (self.infoDict) {
        if ([self.infoDict objectForKey:@"url"]) {
            [imageView setImageWithURL:[NSURL URLWithString:[self.infoDict objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"parking"]];
        }else{
            if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"2"]) {
                [imageView setImage:[UIImage imageNamed:[self.infoDict objectForKey:@"image"]]];
            }else if([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"1"]){
                imageView.frame=CGRectMake(0, 0, self.view.frame.size.width, 180);
                [imageView setImage:[UIImage imageNamed:[self.infoDict objectForKey:@"image"]]];
            }
        }
    }
}

@end
