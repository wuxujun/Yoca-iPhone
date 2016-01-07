//
//  WeightUtils.m
//  IWeigh
//
//  Created by xujunwu on 15/5/28.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "WeightUtils.h"

@implementation WeightUtils

#pragma mark - Weight
+(int)getWeightStatus:(int)nHeight sex:(int)nSex value:(double)fValue
{
    int result=1;
    int w=nHeight-105;
    if (nSex==1) {
        w=nHeight-100;
    }
    if (fValue>(w*1.1)){
        result=2;
    }else if(fValue<(w*0.9)){
        result=0;
    }
    return result;
}

+(NSString*)getWeightStatusTitle:(int)nHeight sex:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    int w=nHeight-105;
    if (nSex==1) {
        w=nHeight-100;
    }
    if (fValue>(w*1.1)){
        result=@"偏胖";
    }else if(fValue<(w*0.9)){
        result=@"偏瘦";
    }
    
    return result;
}

+(double)getWeightStatusValue:(int)nHeight sex:(int)nSex value:(double)fValue
{
    double result=0.5;
    int w=nHeight-105;
    if (nSex==1) {
        w=nHeight-100;
    }
    if (fValue>(w*1.1)){
        result=0.25;
    }else if(fValue<(w*0.9)){
        result=0.85;
    }
    return result;
}

#pragma mark - Fat
+(int)getFatStatus:(int)nAge sex:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 1:{
            if (nAge>17&&nAge<40){
                if (fValue<21.0){
                    result=0;
                }else if (fValue>27.0){
                    result=2;
                }
            }else if(nAge>39&&nAge<60){
                if (fValue<22.0){
                    result=0;
                }else if (fValue>28.0){
                    result=2;
                }
            }else if(nAge>59){
                if (fValue<23.0){
                    result=0;
                }else if (fValue>29.0){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nAge>17&&nAge<40){
                if (fValue<11.0){
                    result=0;
                }else if (fValue>16.0){
                    result=2;
                }
            }else if(nAge>39&&nAge<60){
                if (fValue<12.0){
                    result=0;
                }else if (fValue>17.0){
                    result=2;
                }
            }else if(nAge>59){
                if (fValue<14.0){
                    result=0;
                }else if (fValue>19.0){
                    result=2;
                }
            }
            break;
        }
    }
    return result;
}

+(NSString*)getFatStatusTitle:(int)nAge sex:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    switch (nSex){
        case 1:{
            if (nAge>17&&nAge<40){
                if (fValue<21.0){
                    result=@"偏低";
                }else if (fValue>27.0){
                    result=@"偏高";
                }
            }else if(nAge>39&&nAge<60){
                if (fValue<22.0){
                    result=@"偏低";
                }else if (fValue>28.0){
                    result=@"偏高";
                }
            }else if(nAge>59){
                if (fValue<23.0){
                    result=@"偏低";
                }else if (fValue>29.0){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (nAge>17&&nAge<40){
                if (fValue<11.0){
                    result=@"偏低";
                }else if (fValue>16.0){
                    result=@"偏高";
                }
            }else if(nAge>39&&nAge<60){
                if (fValue<12.0){
                    result=@"偏低";
                }else if (fValue>17.0){
                    result=@"偏高";
                }
            }else if(nAge>59){
                if (fValue<14.0){
                    result=@"偏低";
                }else if (fValue>19.0){
                    result=@"偏高";
                }
            }
            break;
        }
    }
    return result;
}

+(double)getFatStatusValue:(int)nAge sex:(int)nSex value:(double)fValue
{
    double result=0.5;
    switch (nSex) {
        case 1:
        {
            if (nAge>17&&nAge<40) {
                if (fValue<21.0) {
                    result=0.25;
                }else if(fValue>27.0){
                    result=0.85;
                }
            }else if(nAge>39&&nAge<60){
                if (fValue<22.0){
                    result=0.25;
                }else if (fValue>28.0){
                    result=0.85;
                }
            }else if(nAge>59){
                if (fValue<23.0){
                    result=0.25;
                }else if (fValue>29.0){
                    result=0.85;
                }
            }
        }
            break;
        default:
        {
            if (nAge>17&&nAge<40){
                if (fValue<11.0){
                    result=0.25;
                }else if (fValue>16.0){
                    result=0.85;
                }
            }else if(nAge>39&&nAge<60){
                if (fValue<12.0){
                    result=0.25;
                }else if (fValue>17.0){
                    result=0.85;
                }
            }else if(nAge>59){
                if (fValue<14.0){
                    result=0.25;
                }else if (fValue>19.0){
                    result=0.85;
                }
            }
        }
            break;
    }
    return result;
}

#pragma mark - SubFat
+(int)getSufFatStatus:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 1:{
            if (fValue<18.5){
                result=0;
            }else if(fValue>26.7){
                result=2;
            }
            break;
        }
        default:{
            if (fValue<8.6){
                result=0;
            }else if(fValue>16.7){
                result=2;
            }
            break;
        }
    }
    return result;
}

+(NSString*)getSubFatStatusTitle:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    switch (nSex){
        case 1:{
            if (fValue<18.5){
                result=@"偏低";
            }else if(fValue>26.7){
                result=@"偏高";
            }
            break;
        }
        default:{
            if (fValue<8.6){
                result=@"偏低";
            }else if(fValue>16.7){
                result=@"偏高";
            }
            break;
        }
    }
    return result;
}

+(double)getSubFatStatusValue:(int)nSex value:(double)fValue
{
    double result=0.5;
    switch (nSex){
        case 1:{
            if (fValue<18.5){
                result=0.25;
            }else if(fValue>26.7){
                result=0.85;
            }
            break;
        }
        default:{
            if (fValue<8.6){
                result=0.25;
            }else if(fValue>16.7){
                result=0.85;
            }
            break;
        }
    }
    return result;
}

#pragma mark - VisFat
+(int)getVisFatStatus:(double)fValue
{
    int result=1;
    if (fValue<1){
        result=0;
    }else if(fValue>9){
        result=2;
    }
    return result;
}

+(NSString*)getVisFatStatusTitle:(double)fValue
{
    NSString* result=@"标准";
    if (fValue<1){
        result=@"偏低";
    }else if(fValue>9){
        result=@"偏高";
    }
    return result;
}

+(double)getVisFatStatusValue:(double)fValue
{
    double result=0.50;
    if (fValue<1){
        result=0.25;
    }else if(fValue>9){
        result=0.85;
    }
    return result;
}

#pragma mark - Water
+(int)getWaterStatus:(int)nSex value:(double)fValue
{
    int result=1;
    if (nSex==0){
        if (fValue>65){
            result=2;
        }else if(fValue<55){
            result=0;
        }
    }else{
        if (fValue>60){
            result=2;
        }else if(fValue<45){
            result=0;
        }
    }
    return result;
}

+(NSString*)getWaterStatusTitle:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    if (nSex==0){
        if (fValue>65){
            result=@"偏高";
        }else if(fValue<55){
            result=@"偏低";
        }
    }else{
        if (fValue>60){
            result=@"偏高";
        }else if(fValue<45){
            result=@"偏低";
        }
    }
    return result;
}

+(double)getWaterStatusValue:(int)nSex value:(double)fValue
{
    double result=0.50;
    switch (nSex){
        case 1:
        {
            if (fValue<45.0){
                result=0.25;
            }else if(fValue>60.0){
                result=0.85;
            }
            break;
        }
        default:
        {
            if (fValue<55.0){
                result=0.25;
            }else if(fValue>65.0){
                result=0.85;
            }
            break;
        }
    }
    return result;
}

#pragma mark - BMR
+(int)getBMRStatus:(int)nAge sex:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 1:{
            if (nAge<=17) {
                if (fValue>1392) {
                    result=2;
                }else if (fValue<1139){
                    result=0;
                }
            }else if (nAge>17&&nAge<30){
                if (fValue<1168){
                    result=0;
                }else if(fValue>1428){
                    result=2;
                }
            }else if(nAge>29&&nAge<50){
                if (fValue<1172){
                    result=0;
                }else if(fValue>1432){
                    result=2;
                }
            }else if(nAge>49&&nAge<70){
                if (fValue<1118){
                    result=0;
                }else if(fValue>1366){
                    result=2;
                }
            }else{
                if (fValue<932){
                    result=0;
                }else if(fValue>1139){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nAge<=17) {
                if (fValue>1386) {
                    result=2;
                }else if(fValue<1134){
                    result=0;
                }
            }else if (nAge>17&&nAge<30){
                if (fValue>1716){
                    result=2;
                }else if(fValue<1404){
                    result=0;
                }
            }else if(nAge>29&&nAge<50){
                if (fValue<1405){
                    result=0;
                }else if(fValue>1717){
                    result=2;
                }
            }else if(nAge>49&&nAge<70){
                if (fValue<1355){
                    result=0;
                }else if(fValue>1656){
                    result=2;
                }
            }else{
                if (fValue<1405){
                    result=0;
                }else if(fValue>1538){
                    result=2;
                }
            }
            break;
        }
    }
    
    return result;
}

+(NSString*)getBMRStatusTitle:(int)nAge sex:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    switch (nSex){
        case 1:{
            if (nAge<=17) {
                if (fValue<1139) {
                    result=@"偏低";
                }else if(fValue>1392){
                    result=@"偏高";
                }
            } else if (nAge>17&&nAge<30){
                if (fValue<1168){
                    result=@"偏低";
                }else if(fValue>1428){
                    result=@"偏高";
                }
            }else if(nAge>29&&nAge<50){
                if (fValue<1172){
                    result=@"偏低";
                }else if(fValue>1432){
                    result=@"偏高";
                }
            }else if(nAge>49&&nAge<70){
                if (fValue<1118){
                    result=@"偏低";
                }else if(fValue>1366){
                    result=@"偏高";
                }
            }else{
                if (fValue<932){
                    result=@"偏低";
                }else if(fValue>1139){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (nAge<=17) {
                if (fValue<1134) {
                    result=@"偏低";
                }else if (fValue>1386){
                    result=@"偏高";
                }
            }else if (nAge>17&&nAge<30){
                if (fValue<1404){
                    result=@"偏低";
                }else if(fValue>1716){
                    result=@"偏高";
                }
            }else if(nAge>29&&nAge<50){
                if (fValue<1405){
                    result=@"偏低";
                }else if(fValue>1717){
                    result=@"偏高";
                }
            }else if(nAge>49&&nAge<70){
                if (fValue<1355){
                    result=@"偏低";
                }else if(fValue>1656){
                    result=@"偏高";
                }
            }else{
                if (fValue<1405){
                    result=@"偏低";
                }else if(fValue>1538){
                    result=@"偏高";
                }
            }
            break;
        }
    }
    
    return result;
}

+(double)getBMRStatusValue:(int)nAge sex:(int)nSex value:(double)fValue
{
    int result=0.50;
    switch (nSex){
        case 1:{
            if (nAge<=17) {
                if (fValue<1139) {
                    result=0;
                }else if(fValue>1392){
                    result=2;
                }
            } else if (nAge>17&&nAge<30){
                if (fValue<1168){
                    result=0;
                }else if(fValue>1428){
                    result=2;
                }
            }else if(nAge>29&&nAge<50){
                if (fValue<1172){
                    result=0;
                }else if(fValue>1432){
                    result=2;
                }
            }else if(nAge>49&&nAge<70){
                if (fValue<1118){
                    result=0;
                }else if(fValue>1366){
                    result=2;
                }
            }else{
                if (fValue<932){
                    result=0;
                }else if(fValue>1139){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nAge<=17) {
                if (fValue<1134) {
                    result=0;
                }else if (fValue>1386){
                    result=2;
                }
            }else if (nAge>17&&nAge<30){
                if (fValue<1404){
                    result=0;
                }else if(fValue>1716){
                    result=2;
                }
            }else if(nAge>29&&nAge<50){
                if (fValue<1405){
                    result=0;
                }else if(fValue>1717){
                    result=2;
                }
            }else if(nAge>49&&nAge<70){
                if (fValue<1355){
                    result=0;
                }else if(fValue>1656){
                    result=2;
                }
            }else{
                if (fValue<1405){
                    result=0;
                }else if(fValue>1538){
                    result=2;
                }
            }
            break;
        }
    }
    return result;
}

#pragma mark - Muscle
+(int)getMuscleStatus:(int)nAge sex:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 1:
        {
            if (nAge<16){
                if (fValue<44.0) {
                    result =0;
                }else if(fValue>49.0){
                    result=2;
                }
            }else if(nAge>15&&nAge<31){
                if (fValue<43.0){
                    result=0;
                }else if(fValue>48.0){
                    result=2;
                }
            }else if (nAge>30&&nAge<61){
                if (fValue<42.0) {
                    result=0;
                }else if(fValue>47.0){
                    result=2;
                }
            } else{
                if(fValue<41.0){
                    result=0;
                }else if(fValue>46.0){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nAge<16){
                if (fValue<46.0) {
                    result = 0;
                }else if(fValue>51.0){
                    result=2;
                }
            }else if(nAge>15&&nAge<31){
                if (fValue<45.0){
                    result=0;
                }else if(fValue>50.0){
                    result=2;
                }
            }else if(nAge>30&&nAge<61){
                if (fValue<44.0){
                    result=0;
                }else if(fValue>49.0){
                    result=2;
                }
            }else{
                if(fValue<43.0){
                    result=0;
                }else if(fValue>48.0){
                    result=2;
                }
            }
            break;
        }
    }
    
    return result;
}

+(NSString*)getMuscleStatusTitle:(int)nAge sex:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    switch (nSex){
        case 1:
        {
            if (nAge<16){
                if (fValue<44.0) {
                    result =@"偏低";
                }else if(fValue>49.0){
                    result=@"偏高";
                }
            }else if(nAge>15&&nAge<31){
                if (fValue<43.0){
                    result=@"偏低";
                }else if(fValue>48.0){
                    result=@"偏高";
                }
            }else if (nAge>30&&nAge<61){
                if (fValue<42.0) {
                    result=@"偏低";
                }else if(fValue>47.0){
                    result=@"偏高";
                }
            } else{
                if(fValue<41.0){
                    result=@"偏低";
                }else if(fValue>46.0){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (nAge<16){
                if (fValue<46.0) {
                    result = @"偏低";
                }else if(fValue>51.0){
                    result=@"偏高";
                }
            }else if(nAge>15&&nAge<31){
                if (fValue<45.0){
                    result=@"偏低";
                }else if(fValue>50.0){
                    result=@"偏高";
                }
            }else if(nAge>30&&nAge<61){
                if (fValue<44.0){
                    result=@"偏低";
                }else if(fValue>49.0){
                    result=@"偏高";
                }
            }else{
                if(fValue<43.0){
                    result=@"偏低";
                }else if(fValue>48.0){
                    result=@"偏高";
                }
            }
            break;
        }
    }
    return result;
}

+(double)getMuscleStatusValue:(int)nAge sex:(int)nSex value:(double)fValue
{
    double result=0.50;
    switch (nSex){
        case 1:
        {
            if (nAge<16){
                if (fValue<44.0) {
                    result =0.25;
                }else if(fValue>49.0){
                    result=0.85;
                }
            }else if(nAge>15&&nAge<31){
                if (fValue<43.0){
                    result=0.25;
                }else if(fValue>48.0){
                    result=0.85;
                }
            }else if (nAge>30&&nAge<61){
                if (fValue<42.0) {
                    result=0.25;
                }else if(fValue>47.0){
                    result=0.85;
                }
            } else{
                if(fValue<41.0){
                    result=0.25;
                }else if(fValue>46.0){
                    result=0.85;
                }
            }
            break;
        }
        default:{
            if (nAge<16){
                if (fValue<46.0) {
                    result = 0.25;
                }else if(fValue>51.0){
                    result=0.85;
                }
            }else if(nAge>15&&nAge<31){
                if (fValue<45.0){
                    result=0.25;
                }else if(fValue>50.0){
                    result=0.85;
                }
            }else if(nAge>30&&nAge<61){
                if (fValue<44.0){
                    result=0.25;
                }else if(fValue>49.0){
                    result=0.85;
                }
            }else{
                if(fValue<43.0){
                    result=0.25;
                }else if(fValue>48.0){
                    result=0.85;
                }
            }
            break;
        }
    }
    
    return result;
}

#pragma mark - Bone
+(int)getBoneStatus:(double)fWeight sex:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 1:
        {
            if (fWeight<45){
                if (fValue<0.5) {
                    result =0;
                }else if(fValue>3.0){
                    result=2;
                }
            }else if(fWeight>44&&fWeight<61){
                if (fValue<0.5){
                    result=0;
                }else if(fValue>4.2){
                    result=2;
                }
            }else if(fWeight>60.0){
                if(fValue<0.5){
                    result=0;
                }else if(fValue>3.0){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (fWeight<60){
                if (fValue<0.5) {
                    result =0;
                }else if(fValue>4.5){
                    result=2;
                }
            }else if(fWeight>59&&fWeight<76){
                if (fValue<0.5){
                    result=0;
                }else if(fValue>6.0){
                    result=2;
                }
            }else if(fWeight>75){
                if(fValue<0.5){
                    result=0;
                }else if(fValue>7.5){
                    result=2;
                }
            }
            break;
        }
    }
    return result;
}

+(NSString*)getBoneStatusTitle:(double)fWeight sex:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    switch (nSex){
        case 1:
        {
            if (fWeight<45){
                if (fValue<0.5) {
                    result =@"偏低";
                }else if(fValue>3.0){
                    result=@"偏高";
                }
            }else if(fWeight>44&&fWeight<61){
                if (fValue<0.5){
                    result=@"偏低";
                }else if(fValue>4.2){
                    result=@"偏高";
                }
            }else if(fWeight>60.0){
                if(fValue<0.5){
                    result=@"偏低";
                }else if(fValue>3.0){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (fWeight<60){
                if (fValue<0.5) {
                    result =@"偏低";
                }else if(fValue>4.5){
                    result=@"偏高";
                }
            }else if(fWeight>59&&fWeight<76){
                if (fValue<0.5){
                    result=@"偏低";
                }else if(fValue>6.0){
                    result=@"偏高";
                }
            }else if(fWeight>75){
                if(fValue<0.5){
                    result=@"偏低";
                }else if(fValue>7.5){
                    result=@"偏高";
                }
            }
            break;
        }
    }
    return result;
}

+(double)getBoneStatusValue:(double)fWeight sex:(int)nSex value:(double)fValue
{
    double result=0.50;
    switch (nSex){
        case 1:
        {
            if (fWeight<45){
                if (fValue<0.5) {
                    result =0.25;
                }else if(fValue>3.0){
                    result=0.85;
                }
            }else if(fWeight>44&&fWeight<61){
                if (fValue<0.5){
                    result=0.25;
                }else if(fValue>4.2){
                    result=0.85;
                }
            }else if(fWeight>60.0){
                if(fValue<0.5){
                    result=0.25;
                }else if(fValue>3.0){
                    result=0.85;
                }
            }
            break;
        }
        default:{
            if (fWeight<60){
                if (fValue<0.5) {
                    result =0.25;
                }else if(fValue>4.5){
                    result=0.85;
                }
            }else if(fWeight>59&&fWeight<76){
                if (fValue<0.5){
                    result=0.25;
                }else if(fValue>6.0){
                    result=0.85;
                }
            }else if(fWeight>75){
                if(fValue<0.5){
                    result=0.25;
                }else if(fValue>7.5){
                    result=0.85;
                }
            }
            break;
        }
    }
    
    return result;
}

#pragma mark - BMI
+(int)getBMIStatus:(double)fValue
{
    int result=1;
    if (fValue>23.0)
    {
        result=2;
    }else if(fValue<18.5){
        result=0;
    }
    return result;
}

+(NSString*)getBMIStatusTitle:(double)fValue
{
    NSString* result=@"标准";
    if (fValue>23.0)
    {
        result=@"偏高";
    }else if(fValue<18.5){
        result=@"偏低";
    }
    return result;
}

+(double)getBMIStatusValue:(double)fValue
{
    double result=0.50;
    if (fValue>23.0)
    {
        result=0.85;
    }else if(fValue<18.5){
        result=0.25;
    }
    return result;
}



@end
