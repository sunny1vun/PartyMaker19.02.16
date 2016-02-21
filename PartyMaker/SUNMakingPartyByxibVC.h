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

@interface SUNMakingPartyByxibVC : UIViewController <NSFetchedResultsControllerDelegate>

//@property (nonatomic, strong) SUNSaver *partyToChange;
@property (nonatomic, strong) SUNParty *partyToChange;
@property (nonatomic) NSInteger indexOfPartyToChange;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObjectContext *backgroundContext;


-(NSString *)textFromValueOfSlider:(UISlider*)slider;
-(CGFloat)numberOfMinutesInHoursAndMinutes:(NSString *) time;

@end
