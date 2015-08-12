//
//  IWebViewController.m
//  IWeigh
//
//  Created by xujunwu on 7/11/15.
//  Copyright (c) 2015 ___xujun___. All rights reserved.
//

#import "IWebViewController.h"
#import "PathHelper.h"
#import "UIFont+Setting.h"
#import "UIViewController+NavigationBarButton.h"

@interface IWebViewController()<UIWebViewDelegate>
{
    UIWebView           *mWebView;
}
@end


@implementation IWebViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBarButton];
    if (mWebView==nil) {
        mWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-self.navHeight/*-self.tabBarHeight*/)];
        mWebView.delegate=self;
        mWebView.scalesPageToFit=NO;
        mWebView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:mWebView];
        
    }
    DLog(@"%f  %f   %f",self.view.frame.size.height,SCREEN_HEIGHT,self.tabBarController.tabBar.frame.size.height);
    
    UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 34)];
    [lab setText:@"品牌介绍"];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView=lab;
    
    if (self.infoDict) {
        if ([self.infoDict objectForKey:@"title"]) {
            [lab setText:[self.infoDict objectForKey:@"title"]];
        }
        [mWebView loadHTMLString:[self htmlForContent:[self.infoDict objectForKey:@"content"]] baseURL:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self setHidesBottomBarWhenPushed:NO];
//    [super viewDidDisappear:animated];
}

- (NSString *)htmlForContent:(NSString *)content
{
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:[PathHelper filePathInMainBundle:@"Detail_template.html"] encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:htmlTemplate, [UIFont currentSystemFontSizeBasedOn:14], 0, 0, 0, 0, content];
    return html;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

@end
