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
    switch (nSex) {
        case 0:
        {
            int val=(nHeight-100);
            if (fValue<(val*1.1)) {
                result=0;
            }else if(fValue>(val*1.1)){
                result=2;
            }
        }
            break;
        default:
        {
            int val=(nHeight-105);
            if (fValue<(val*1.1)) {
                result=0;
            }else if(fValue>(val*1.1)){
                result=2;
            }
        }
            break;
    }
    return result;
}

+(NSString*)getWeightStatusTitle:(int)nHeight sex:(int)nSex value:(double)fValue
{
    NSString* result=@"正常";
    switch (nSex) {
        case 0:
        {
            int val=(nHeight-100);
            if (fValue<(val*1.1)) {
                result=@"偏瘦";
            }else if(fValue>(val*1.1)){
                result=@"偏胖";
            }
        }
            break;
        default:
        {
            int val=(nHeight-105);
            if (fValue<(val*1.1)) {
                result=@"偏瘦";
            }else if(fValue>(val*1.1)){
                result=@"偏胖";
            }
        }
            break;
    }
    
    return result;
}

+(double)getWeightStatusValue:(int)nHeight sex:(int)nSex value:(double)fValue
{
    double result=0.5;
    switch (nSex) {
        case 0:
        {
            int val=(nHeight-100);
            if (fValue<(val*1.1)) {
                result=0.25;
            }else if(fValue>(val*1.1)){
                result=0.75;
            }
        }
            break;
        default:
        {
            int val=(nHeight-105);
            if (fValue<(val*1.1)) {
                result=0.25;
            }else if(fValue>(val*1.1)){
                result=0.75;
            }
        }
            break;
    }
    return result;
}

#pragma mark - Fat
+(int)getFatStatus:(int)nAge sex:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 0:{
            if (nAge>=18&&nAge<=39){
                if (fValue<21.0){
                    result=0;
                }else if (fValue>27.0){
                    result=2;
                }
            }else if(nAge>=40&&nAge<=59){
                if (fValue<22.0){
                    result=0;
                }else if (fValue>29.0){
                    result=2;
                }
            }else if(nAge>=60){
                if (fValue<23.0){
                    result=0;
                }else if (fValue>29.0){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nAge>=18&&nAge<=39){
                if (fValue<11.0){
                    result=0;
                }else if (fValue>17.0){
                    result=2;
                }
            }else if(nAge>=40&&nAge<=59){
                if (fValue<12.0){
                    result=0;
                }else if (fValue>17.0){
                    result=2;
                }
            }else if(nAge>=60){
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
    NSString* result=@"健康";
    switch (nSex){
        case 0:{
            if (nAge>=18&&nAge<=39){
                if (fValue<21.0){
                    result=@"偏瘦";
                }else if (fValue>27.0){
                    result=@"偏胖";
                }
            }else if(nAge>=40&&nAge<=59){
                if (fValue<22.0){
                    result=@"偏瘦";
                }else if (fValue>29.0){
                    result=@"偏胖";
                }
            }else if(nAge>=60){
                if (fValue<23.0){
                    result=@"偏瘦";
                }else if (fValue>29.0){
                    result=@"偏胖";
                }
            }
            break;
        }
        default:{
            if (nAge>=18&&nAge<=39){
                if (fValue<11.0){
                    result=@"偏瘦";
                }else if (fValue>17.0){
                    result=@"偏胖";
                }
            }else if(nAge>=40&&nAge<=59){
                if (fValue<12.0){
                    result=@"偏瘦";
                }else if (fValue>17.0){
                    result=@"偏胖";
                }
            }else if(nAge>=60){
                if (fValue<14.0){
                    result=@"偏瘦";
                }else if (fValue>19.0){
                    result=@"偏胖";
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
        case 0:
        {
            if (nAge>=18&&nAge<=39) {
                if (fValue<21.0) {
                    result=0.25;
                }else if(fValue>27.0){
                    result=0.75;
                }
            }else if(nAge>=40&&nAge<=59){
                if (fValue<22.0){
                    result=0.26;
                }else if (fValue>29.0){
                    result=0.76;
                }
            }else if(nAge>=60){
                if (fValue<23.0){
                    result=0.26;
                }else if (fValue>29.0){
                    result=0.80;
                }
            }
        }
            break;
        default:
        {
            if (nAge>=18&&nAge<=39){
                if (fValue<11.0){
                    result=0.25;
                }else if (fValue>17.0){
                    result=0.70;
                }
            }else if(nAge>=40&&nAge<=59){
                if (fValue<12.0){
                    result=0.23;
                }else if (fValue>17.0){
                    result=0.76;
                }
            }else if(nAge>=60){
                if (fValue<14.0){
                    result=0.24;
                }else if (fValue>19.0){
                    result=0.73;
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
        case 0:{
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
        case 0:{
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
        case 0:{
            if (fValue<18.5){
                result=0.24;
            }else if(fValue>26.7){
                result=0.70;
            }
            break;
        }
        default:{
            if (fValue<8.6){
                result=0.18;
            }else if(fValue>16.7){
                result=0.72;
            }
            break;
        }
    }
    return result;
}

#pragma mark - VisFat
+(int)getVisFatStatus:(double)fValue
{
    if (fValue>1&&fValue<9){
        return 0;
    }else if(fValue>10&&fValue<14){
        return 2;
    }else if(fValue>15){
        return 3;
    }
    return 1;
}

+(NSString*)getVisFatStatusTitle:(double)fValue
{
    if (fValue>1&&fValue<9){
        return @"正常";
    }else if(fValue>10&&fValue<14){
        return @"偏高";
    }else if(fValue>15){
        return @"严重偏高";
    }
    return @"标准";
}

+(double)getVisFatStatusValue:(double)fValue
{
    double result=0.20;
    if (fValue>1&&fValue<9){
        result=0.50;
    }else if(fValue>10&&fValue<14){
        result=0.75;
    }else if(fValue>15){
        result=0.90;
    }
    return result;
}

#pragma mark - Water
+(int)getWaterStatus:(int)nSex value:(double)fValue
{
    if (nSex==1){
        if (fValue>=55&&fValue<=65){
            return 1;
        }else if(fValue<55){
            return 0;
        }
        return 2;
    }else{
        if (fValue>=45&&fValue<=60){
            return 1;
        }else if(fValue<45){
            return 0;
        }
        return 2;
    }
}

+(NSString*)getWaterStatusTitle:(int)nSex value:(double)fValue
{
    if (nSex==1){
        if (fValue>=55&&fValue<=65){
            return @"正常";
        }else if(fValue<55){
            return @"偏低";
        }
        return @"偏高";
    }else{
        if (fValue>=45&&fValue<=60){
            return @"正常";
        }else if(fValue<45){
            return @"偏低";
        }
        return @"偏高";
    }
}

+(double)getWaterStatusValue:(int)nSex value:(double)fValue
{
    double result=0.50;
    switch (nSex){
        case 0:
        {
            if (fValue<=45.0){
                result=0.25;
            }else if(fValue>=60.0){
                result=0.78;
            }
            break;
        }
        default:
        {
            if (fValue<=55.0){
                result=0.22;
            }else if(fValue>=65.0){
                result=0.80;
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
        case 0:{
            if (nAge>=18&&nAge<=29){
                if (fValue<23.6){
                    result=0;
                }else if(fValue>23.6){
                    result=2;
                }
            }else if(nAge>=30&&nAge<=49){
                if (fValue<21.7){
                    result=0;
                }else if(fValue>21.7){
                    result=2;
                }
            }else if(nAge>=50&&nAge<=69){
                if (fValue<20.7){
                    result=0;
                }else if(fValue>20.7){
                    result=2;
                }
            }else if(nAge>=70){
                if (fValue<20.7){
                    result=0;
                }else if(fValue>20.7){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nAge>=18&&nAge<=29){
                if (fValue<24.0){
                    result=0;
                }else if(fValue>24.0){
                    result=2;
                }
            }else if(nAge>=30&&nAge<=49){
                if (fValue<22.3){
                    result=0;
                }else if(fValue>22.3){
                    result=2;
                }
            }else if(nAge>=50&&nAge<=69){
                if (fValue<21.5){
                    result=0;
                }else if(fValue>21.5){
                    result=2;
                }
            }else if(nAge>=70){
                if (fValue<21.5){
                    result=0;
                }else if(fValue>21.5){
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
        case 0:{
            if (nAge>=18&&nAge<=29){
                if (fValue<23.6){
                    result=@"偏低";
                }else if(fValue>23.6){
                    result=@"偏高";
                }
            }else if(nAge>=30&&nAge<=49){
                if (fValue<21.7){
                    result=@"偏低";
                }else if(fValue>21.7){
                    result=@"偏高";
                }
            }else if(nAge>=50&&nAge<=69){
                if (fValue<20.7){
                    result=@"偏低";
                }else if(fValue>20.7){
                    result=@"偏高";
                }
            }else if(nAge>=70){
                if (fValue<20.7){
                    result=@"偏低";
                }else if(fValue>20.7){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (nAge>=18&&nAge<=29){
                if (fValue<24.0){
                    result=@"偏低";
                }else if(fValue>24.0){
                    result=@"偏高";
                }
            }else if(nAge>=30&&nAge<=49){
                if (fValue<22.3){
                    result=@"偏低";
                }else if(fValue>22.3){
                    result=@"偏高";
                }
            }else if(nAge>=50&&nAge<=69){
                if (fValue<21.5){
                    result=@"偏低";
                }else if(fValue>21.5){
                    result=@"偏高";
                }
            }else if(nAge>=70){
                if (fValue<21.5){
                    result=@"偏低";
                }else if(fValue>21.5){
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
        case 0:{
            if (nAge>=18&&nAge<=29){
                if (fValue<23.6){
                    result=0.23;
                }else if(fValue>23.6){
                    result=0.80;
                }
            }else if(nAge>=30&&nAge<=49){
                if (fValue<21.7){
                    result=0.24;
                }else if(fValue>21.7){
                    result=0.76;
                }
            }else if(nAge>=50&&nAge<=69){
                if (fValue<20.7){
                    result=0.28;
                }else if(fValue>20.7){
                    result=0.71;
                }
            }else if(nAge>=70){
                if (fValue<20.7){
                    result=0.18;
                }else if(fValue>20.7){
                    result=0.75;
                }
            }
            break;
        }
        default:{
            if (nAge>=18&&nAge<=29){
                if (fValue<24.0){
                    result=0.28;
                }else if(fValue>24.0){
                    result=0.79;
                }
            }else if(nAge>=30&&nAge<=49){
                if (fValue<22.3){
                    result=0.25;
                }else if(fValue>22.3){
                    result=0.78;
                }
            }else if(nAge>=50&&nAge<=69){
                if (fValue<21.5){
                    result=0.28;
                }else if(fValue>21.5){
                    result=0.78;
                }
            }else if(nAge>=70){
                if (fValue<21.5){
                    result=0.28;
                }else if(fValue>21.5){
                    result=0.72;
                }
            }
            break;
        }
    }
    
    return result;
}

#pragma mark - Muscle
+(int)getMuscleStatus:(int)nHeight sex:(int)nSex value:(double)fValue
{
    int result=1;
    switch (nSex){
        case 0:
        {
            if (nHeight<150){
                if (fValue<29.1) {
                    result =0;
                }else if(fValue>34.7){
                    result=2;
                }
            }else if(nHeight>150&&nHeight<160){
                if (fValue<32.9){
                    result=0;
                }else if(fValue>37.5){
                    result=2;
                }
            }else{
                if(fValue<36.5){
                    result=0;
                }else if(fValue>42.5){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (nHeight<160){
                if (fValue<38.5) {
                    result = 0;
                }else if(fValue>46.5){
                    result=2;
                }
            }else if(nHeight>160&&nHeight<170){
                if (fValue<42.0){
                    result=0;
                }else if(fValue>52.4){
                    result=2;
                }
            }else{
                if(fValue<49.4){
                    result=0;
                }else if(fValue>59.4){
                    result=2;
                }
            }
            break;
        }
    }
    
    return result;
}

+(NSString*)getMuscleStatusTitle:(int)nHeight sex:(int)nSex value:(double)fValue
{
    NSString* result=@"标准";
    switch (nSex){
        case 0:
        {
            if (nHeight<150){
                if (fValue<29.1) {
                    result =@"偏低";
                }else if(fValue>34.7){
                    result=@"偏高";
                }
            }else if(nHeight>150&&nHeight<160){
                if (fValue<32.9){
                    result=@"偏低";
                }else if(fValue>37.5){
                    result=@"偏高";
                }
            }else{
                if(fValue<36.5){
                    result=@"偏低";
                }else if(fValue>42.5){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (nHeight<160){
                if (fValue<38.5) {
                    result = @"偏低";
                }else if(fValue>46.5){
                    result=@"偏高";
                }
            }else if(nHeight>160&&nHeight<170){
                if (fValue<42.0){
                    result=@"偏低";
                }else if(fValue>52.4){
                    result=@"偏高";
                }
            }else{
                if(fValue<49.4){
                    result=@"偏低";
                }else if(fValue>59.4){
                    result=@"偏高";
                }
            }
            break;
        }
    }
    
    return result;
}

+(double)getMuscleStatusValue:(int)nHeight sex:(int)nSex value:(double)fValue
{
    double result=0.50;
    switch (nSex){
        case 0:
        {
            if (nHeight<150){
                if (fValue<29.1) {
                    result=0.26;
                }else if(fValue>34.7){
                    result=0.75;
                }
            }else if(nHeight>150&&nHeight<160){
                if (fValue<32.9){
                    result=0.22;
                }else if(fValue>37.5){
                    result=0.78;
                }
            }else{
                if(fValue<36.5){
                    result=0.23;
                }else if(fValue>42.5){
                    result=0.68;
                }
            }
            break;
        }
        default:{
            if (nHeight<160){
                if (fValue<38.5) {
                    result=0.19;
                }else if(fValue>46.5){
                    result=0.68;
                }
            }else if(nHeight>160&&nHeight<170){
                if (fValue<42.0){
                    result=0.28;
                }else if(fValue>52.4){
                    result=0.78;
                }
            }else{
                if(fValue<49.4){
                    result=0.28;
                }else if(fValue>59.4){
                    result=0.68;
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
        case 0:
        {
            if (fWeight<45){
                if (fValue<1.8) {
                    result =0;
                }else if(fValue>1.8){
                    result=2;
                }
            }else if(fWeight>45&&fWeight<60){
                if (fValue<2.2){
                    result=0;
                }else if(fValue>2.2){
                    result=2;
                }
            }else{
                if(fValue<2.5){
                    result=0;
                }else if(fValue>2.5){
                    result=2;
                }
            }
            break;
        }
        default:{
            if (fWeight<60){
                if (fValue<2.5) {
                    result =0;
                }else if(fValue>2.5){
                    result=2;
                }
            }else if(fWeight>60&&fWeight<75){
                if (fValue<2.9){
                    result=0;
                }else if(fValue>2.9){
                    result=2;
                }
            }else{
                if(fValue<3.2){
                    result=0;
                }else if(fValue>3.2){
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
        case 0:
        {
            if (fWeight<45){
                if (fValue<1.8) {
                    result =@"偏低";
                }else if(fValue>1.8){
                    result=@"偏高";
                }
            }else if(fWeight>45&&fWeight<60){
                if (fValue<2.2){
                    result=@"偏低";
                }else if(fValue>2.2){
                    result=@"偏高";
                }
            }else{
                if(fValue<2.5){
                    result=@"偏低";
                }else if(fValue>2.5){
                    result=@"偏高";
                }
            }
            break;
        }
        default:{
            if (fWeight<60){
                if (fValue<2.5) {
                    result =@"偏低";
                }else if(fValue>2.5){
                    result=@"偏高";
                }
            }else if(fWeight>60&&fWeight<75){
                if (fValue<2.9){
                    result=@"偏低";
                }else if(fValue>2.9){
                    result=@"偏高";
                }
            }else{
                if(fValue<3.2){
                    result=@"偏低";
                }else if(fValue>3.2){
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
        case 0:
        {
            if (fWeight<45){
                if (fValue<1.8) {
                    result=0.25;
                }else if(fValue>1.8){
                    result=0.74;
                }
            }else if(fWeight>45&&fWeight<60){
                if (fValue<2.2){
                    result=0.28;
                }else if(fValue>2.2){
                    result=0.68;
                }
            }else{
                if(fValue<2.5){
                    result=0.22;
                }else if(fValue>2.5){
                    result=0.68;
                }
            }
            break;
        }
        default:{
            if (fWeight<60){
                if (fValue<2.5) {
                    result=0.28;
                }else if(fValue>2.5){
                    result=0.68;
                }
            }else if(fWeight>60&&fWeight<75){
                if (fValue<2.9){
                    result=0.28;
                }else if(fValue>2.9){
                    result=0.68;
                }
            }else{
                if(fValue<3.2){
                    result=0.28;
                }else if(fValue>3.2){
                    result=0.68;
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
    if (fValue>=24&&fValue<=28)
    {
        return 2;
    }else if(fValue>28){
        return 3;
    }else if(fValue<18.5){
        return 0;
    }
    return 1;
}

+(NSString*)getBMIStatusTitle:(double)fValue
{
    if (fValue>=24&&fValue<=28)
    {
        return @"轻度脂肪堆积";
    }else if(fValue>28){
        return @"严重脂肪堆积";
    }else if(fValue<18.5){
        return @"偏瘦";
    }
    return @"健康";
}

+(double)getBMIStatusValue:(double)fValue
{
    double result=0.50;
    if (fValue>=24&&fValue<=28){
        result=0.65;
    }else if(fValue>28){
        result=0.90;
    }else if(fValue<18.5){
        result=0.25;
    }
    return result;
}



@end
