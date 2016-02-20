//
//  NSDate+Utility.m
//  PartyMaker
//
//  Created by 2 on 2/13/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate(Utility)

+(NSString*)formateToStringDate:(NSString*)dateIsChosen startTime:(UISlider*)sliderTop endTime:(UISlider*)sliderBottom{
    
    NSMutableString *formatedString = [[NSMutableString alloc] init];
    
    //nil вылетает вот здесь
    if( ![dateIsChosen isEqualToString:@""] ){
        
        [formatedString appendString:dateIsChosen];
        
    }
    CGFloat value = sliderTop.value;
    CGFloat hours = (int)value/60;
    CGFloat minutes = (value - hours * 60);
    
    [formatedString appendFormat:@"  %2d:%02d-", (int)hours, (int)minutes];
    
    value = sliderBottom.value;
    hours = (int)value/60;
    minutes = (value - hours * 60);
    
    [formatedString appendFormat:@"%2d:%02d", (int)hours, (int)minutes];
    
    
    
    return formatedString;
    
}

+(NSString*)formateToStringStartTime:(NSNumber*)startTime endTime:(NSNumber*)endTime{
    
    NSMutableString *formatedString = [[NSMutableString alloc] init];
    
    //    partId /seconds / minutes / hours / days = years
    //    1357234941 / 60 / 60 / 24 / 365 = 43.037637652207
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime.doubleValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Kiev"];
    [dateFormat setTimeZone:tz];
    
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSString *prettyDate = [dateFormat stringFromDate:date];

    [formatedString appendString:prettyDate];
    
    [dateFormat setDateFormat:@"  HH:mm-"];
    [formatedString appendString:[dateFormat stringFromDate:date]];
    
    date = [NSDate dateWithTimeIntervalSince1970:endTime.doubleValue];
    [dateFormat setDateFormat:@"HH:mm"];
    [formatedString appendString:[dateFormat stringFromDate:date]];
//    CGFloat value = startTime.doubleValue;
//    CGFloat hours = (int)value/60;
//    CGFloat minutes = (value - hours * 60);
    
//    [formatedString appendFormat:@"  %2d:%02d-", (int)hours, (int)minutes];
    
//    value = endTime.doubleValue;
//    hours = (int)value/60;
//    minutes = (value - hours * 60);
//    
//    [formatedString appendFormat:@"%2d:%02d", (int)hours, (int)minutes];
    
    
    
    return formatedString;
    
}


@end
