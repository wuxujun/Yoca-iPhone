//
//  StringUtil.m
//  TwitterFon
//
//  Created by kaz on 7/20/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "StringUtil.h"
#import <CommonCrypto/CommonDigest.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@implementation NSString (NSStringUtils)
- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if ('0' <= c && c <= '9' || 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z' || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

+ (NSString*)base64encode:(NSString*)str 
{
    if ([str length] == 0)
        return @"";

    const char *source = [str UTF8String];
    int strlength  = strlen(source);
    
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;

    NSUInteger length = 0;
    NSUInteger i = 0;

    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML
{
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [self mutableCopy];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

+ (NSString*)localizedString:(NSString*)key
{
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
}

+(float)calcTextBoundsHeight:(NSString *)str toSize:(CGSize)size fontSize:(float)fSize
{
    CGRect bounds,result;
    bounds=CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
    label.font=[UIFont systemFontOfSize:fSize];
    label.text=str;
    result=[label textRectForBounds:bounds limitedToNumberOfLines:0];
    return result.size.height;
}


-(NSString*)md5
{
    const char *cStr=[self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ];
}


-(NSString*)urlEncode
{
    NSString *encodedValue = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
	encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
	encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
	encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    return encodedValue;
}


+(NSString*)regularStringFromSearchString:(NSString *)string
{
    NSMutableString *result=[[NSMutableString alloc]initWithCapacity:0];
    for (int i=0; i<[string length]; i++) {
        [result appendFormat:@".*(%@)",[string substringWithRange:NSMakeRange(i, 1)]];
    }
    [result appendFormat:@".*"];
    return result;
}


+(NSString*)currentTime:(NSDateFormatter *)formatter
{
    NSString *local=[formatter stringFromDate:[NSDate date]];
    return local;
}

+(NSInteger)ageWithDateOfBirth:(NSDate *)date
{
    NSDateComponents* components1=[[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear=[components1 year];
    NSInteger brithDateDay=[components1 day];
    NSInteger brithDateMonth=[components1 month];
    
    NSDateComponents *components2=[[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear=[components2 year];
    NSInteger currentDateDay=[components2 day];
    NSInteger currentDateMonth=[components2 month];
    NSInteger iAge=currentDateYear-brithDateYear-1;
    if ((currentDateMonth>brithDateMonth)||(currentDateMonth==brithDateMonth&&currentDateDay>=brithDateDay)) {
        iAge++;
    }
    DLog(@"%d",iAge);
    return iAge;
}

+(NSInteger)dateWithForDays:(NSString *)newDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* endDate=[dateFormatter dateFromString:newDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlag = NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlag fromDate:[NSDate date] toDate:endDate options:0];
    NSInteger days = [components day] + 1;
    return days;
}
+(NSString*)dateToDay:(NSString *)pickTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* newDate=[dateFormatter dateFromString:pickTime];
    [dateFormatter setDateFormat:@"d"];
    return [dateFormatter stringFromDate:newDate];
}

+(NSString*)dateToMonth:(NSString *)pickTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* newDate=[dateFormatter dateFromString:pickTime];
    [dateFormatter setDateFormat:@"M/d"];
    return [dateFormatter stringFromDate:newDate];
}
+(NSInteger)dateWithPickTimeDays:(NSString *)pickTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* endDate=[dateFormatter dateFromString:pickTime];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlag = NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlag fromDate:[NSDate date] toDate:endDate options:0];
    NSInteger days = [components day] + 1;
    return days;
}

+(NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}
@end



