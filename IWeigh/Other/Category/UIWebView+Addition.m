//
//  UIWebView+Addition.m
//
//
//  Created by wuxujun on 13-2-21.
//  Copyright (c) 2013年 ___xujun___. All rights reserved.
//

#import "UIWebView+Addition.h"

@implementation UIWebView (Addition)

- (void)loadHTMLString:(NSString *)string withFontSize:(CGFloat)size
{
    string = [NSString stringWithFormat:@"<html> \n"
               "<head> \n"
               "<style type=\"text/css\"> \n"
               "body {font-family: \"%@\"; font-size: %f;}\n"
               "</style> \n"
               "</head> \n"
               "<body>%@</body> \n"
              "</html>", @"宋体", size,string];
    [self loadHTMLString:string baseURL:nil];
}

@end
