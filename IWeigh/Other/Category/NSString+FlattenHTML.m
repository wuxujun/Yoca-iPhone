//
//  NSString+FlattenHTML.m
//  
//
//  Created by wuxujun on 13-4-29.
//  Copyright (c) 2013年 ___xujun___. All rights reserved.
//

#import "NSString+FlattenHTML.h"
#import "NSString+Addition.h"

@implementation NSString (FlattenHTML)

- (NSString *)flattenHTML
{
    NSScanner *theScanner;
    NSString *text = nil;
    
    NSString *html = [self copy];
    
    theScanner = [NSScanner scannerWithString:self];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
        
    } // while //
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
    html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    html = [html stringByReplacingOccurrencesOfString:@"&middot;" withString:@"∙"];
    html = [html stringByReplacingOccurrencesOfString:@"&bull;" withString:@"∙"];
    html = [html stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    
    return [html trimmedWhitespaceAndNewlineString];

}

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
        
    } // while //
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
    html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    html = [html stringByReplacingOccurrencesOfString:@"&middot;" withString:@"∙"];
    html = [html stringByReplacingOccurrencesOfString:@"&bull;" withString:@"∙"];
    html = [html stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    
    return [html trimmedWhitespaceAndNewlineString];
}

- (NSString *)filterHtmlTag:(NSString *)originHtmlStr trimmed:(BOOL)trimmed{
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) { //如果找到
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@">"];
        //        NSLog(@"start-> %d   end-> %d", arrowTagStartRange.location, arrowTagEndRange.location);
        //        NSString *arrowSubString = [originHtmlStr substringWithRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location)];
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        // NSLog(@"Result--->%@", result);
        return [self filterHtmlTag:result trimmed:trimmed];    //递归，过滤下一个标签
    }else{
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        result = [result stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
        result = [result stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
        result = [result stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        result = [result stringByReplacingOccurrencesOfString:@"&middot;" withString:@"∙"];
        result = [result stringByReplacingOccurrencesOfString:@"&bull;" withString:@"∙"];
        result = [result stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
        result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        //result = [originHtmlStr stringByReplacingOccurrencesOf  ........
    }
    
    return trimmed ? [result trimmedWhitespaceAndNewlineString] : result;
}

- (NSString *)filterForCommunity:(NSString *)originHtmlStr
{
    return [originHtmlStr stringByReplacingOccurrencesOfString:@" 　　" withString:@""];
}

@end
