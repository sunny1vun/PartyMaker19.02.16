//
//  SUNMakingPartyByxibVC.h
//  PartyMaker
//
//  Created by 2 on 2/8/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNPartyInfoVC.h"
#import "SUNParty.h"

@interface SUNMakingPartyByxibVC : UIViewController 

@property (nonatomic, strong) SUNSaver *partyToChange;
@property (nonatomic) NSInteger indexOfPartyToChange;

-(NSString *)textFromValueOfSlider:(UISlider*)slider;
-(CGFloat)numberOfMinutesInHoursAndMinutes:(NSString *) time;

@end
