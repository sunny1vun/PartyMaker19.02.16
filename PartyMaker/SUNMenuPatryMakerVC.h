//
//  SUNMenuPatryMakerVC.h
//  PartyMaker
//
//  Created by 2 on 2/13/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SUNMenuPatryMakerVC : UIViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *partyTableView;

//for table by plist
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) NSInteger indexOfSelectedCell;

//for table by CoreData
@property (nonatomic) NSArray *partiesArray;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
