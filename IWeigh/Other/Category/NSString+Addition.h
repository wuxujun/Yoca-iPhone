//
//  NSString+Addition.h
//  
//
//  Created by wuxujun on 13-8-13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

- (NSComparisonResult)versionStringCompare:(NSString *)other;

- (BOOL)isWhitespaceAndNewlines;

- (BOOL)isEmptyOrWhitespace;

- (BOOL)isEmail;

- (BOOL)isLegalPrice;

- (BOOL)isNumber;

-(BOOL)isLegalName;

- (BOOL)isOnlyContainNumberOrLatter;

-(unichar) intToHex:(int)n;

-(BOOL) isCharSafe:(unichar)ch;

-(BOOL)containString:(NSString *)string;

-(NSString *)removeSpace;

-(NSString *)replaceSpaceWithUnderline;

- (NSString *)replaceDotWithUnderline;

- (NSString *)encodeString;

-(NSString *)trimmedWhitespaceString;

-(NSString *)trimmedWhitespaceAndNewlineString;

- (NSDictionary *)parseURLParams;

- (NSString *)getValueStringFromUrlForParam:(NSString *)param;

@end
