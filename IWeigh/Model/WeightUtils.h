//
//  WeightUtils.h
//  IWeigh
//
//  Created by xujunwu on 15/5/28.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeightUtils : NSObject

+(int)getWeightStatus:(int)nHeight sex:(int)nSex value:(double)fValue;
+(NSString*)getWeightStatusTitle:(int)nHeight sex:(int)nSex value:(double)fValue;
+(double)getWeightStatusValue:(int)nHeight sex:(int)nSex value:(double)fValue;


+(int)getFatStatus:(int)nAge sex:(int)nSex value:(double)fValue;
+(NSString*)getFatStatusTitle:(int)nAge sex:(int)nSex value:(double)fValue;
+(double)getFatStatusValue:(int)nAge sex:(int)nSex value:(double)fValue;

+(int)getSufFatStatus:(int)nSex value:(double)fValue;
+(NSString*)getSubFatStatusTitle:(int)nSex value:(double)fValue;
+(double)getSubFatStatusValue:(int)nSex value:(double)fValue;

+(int)getVisFatStatus:(double)fValue;
+(NSString*)getVisFatStatusTitle:(double)fValue;
+(double)getVisFatStatusValue:(double)fValue;

+(int)getWaterStatus:(int)nSex value:(double)fValue;
+(NSString*)getWaterStatusTitle:(int)nSex value:(double)fValue;
+(double)getWaterStatusValue:(int)nSex value:(double)fValue;


+(int)getBMRStatus:(int)nAge sex:(int)nSex value:(double)fValue;
+(NSString*)getBMRStatusTitle:(int)nAge sex:(int)nSex value:(double)fValue;
+(double)getBMRStatusValue:(int)nAge sex:(int)nSex value:(double)fValue;

+(int)getMuscleStatus:(int)nHeight sex:(int)nSex value:(double)fValue;
+(NSString*)getMuscleStatusTitle:(int)nHeight sex:(int)nSex value:(double)fValue;
+(double)getMuscleStatusValue:(int)nHeight sex:(int)nSex value:(double)fValue;


+(int)getBoneStatus:(double)fWeight sex:(int)nSex value:(double)fValue;
+(NSString*)getBoneStatusTitle:(double)fWeight sex:(int)nSex value:(double)fValue;
+(double)getBoneStatusValue:(double)fWeight sex:(int)nSex value:(double)fValue;

+(int)getBMIStatus:(double)fValue;
+(NSString*)getBMIStatusTitle:(double)fValue;
+(double)getBMIStatusValue:(double)fValue;


@end
