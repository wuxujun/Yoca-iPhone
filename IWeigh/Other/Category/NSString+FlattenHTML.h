//
//  NSString+FlattenHTML.h
//  
//
//  Created by wuxujun on 13-4-29.
//  Copyright (c) 2013年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FlattenHTML)

- (NSString *)flattenHTML;

- (NSString *)flattenHTML:(NSString *)html;

- (NSString *)filterHtmlTag:(NSString *)originHtmlStr trimmed:(BOOL)trimmed;

- (NSString *)filterForCommunity:(NSString *)originHtmlStr;

@end
