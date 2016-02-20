//
//  NSDate+Utility.h
//  PartyMaker
//
//  Created by 2 on 2/13/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate(Utility)

+(NSString*)formateToStringDate:(NSString*)dateIsChosen startTime:(UISlider*)sliderTop endTime:(UISlider*)sliderBottom;

+(NSString*)formateToStringStartTime:(NSNumber*)startTime endTime:(NSNumber*)endTime;


@end
