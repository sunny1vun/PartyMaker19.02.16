//
//  SUNMenuPatryMakerVC.m
//  PartyMaker
//
//  Created by 2 on 2/13/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNAppDelegate.h"
#import "SUNMenuPatryMakerVC.h"
#import "SUNTableViewCell.h"
#import "SUNSaver.h"
#import "SUNDataStore.h"
#import "SUNParty.h"
#import "NSDate+Utility.h"
#import "SUNPartyInfoVC.h"
#import "SUNPartyMakerSDK.h"

@interface SUNMenuPatryMakerVC () <UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *usersPartyArray;

@end

@implementation SUNMenuPatryMakerVC


- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"TableView was first");
    self.context = [MyDelegate managedObjectContext];
    

  
//
//    SUNParty *sunPartyItem = [NSEntityDescription
//                                       insertNewObjectForEntityForName:@"SUNParty"
//                                       inManagedObjectContext:self.context];
//    sunPartyItem.comment = @"CoreDataWorke" ;
//
//
//    NSError *error;
//    if (![self.context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
//

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
#warning connectrion for network
//    [self getAllPartyRequest];
#warning connection for coreData
    [self getPartyFromCoreData];
    NSLog(@"mainContext was first");
    //Loading all parties from file all times when viewAppears (need to load all files ones and then save and edit only selected party)
   // self.dataArray = [SUNDataStore readFromPlist];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - Custom Methods CoreData
-(void) getPartyFromCoreData {
#warning how to make sorted fetchRequest, it works
    
    NSManagedObjectContext *context = self.context;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SUNParty"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"partyId"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error.
        NSLog(@"Something with sorting went wrong - %@", error);
    }else{
//        NSLog(@"%@",fetchedObjects[0]);
    }

    
#warning working before sort

    
    for (SUNParty *info in fetchedObjects) {
        [self.usersPartyArray addObject:info];
    }
    
    if( self.dataArray.count != fetchedObjects.count ){
        self.dataArray = [self.usersPartyArray copy];
        [self.partyTableView reloadData];
    }
    self.usersPartyArray = nil;
    NSLog(@"%lu", (unsigned long)self.dataArray.count);
    
#warning delete here if not works
    
    //    NSError *error;
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSEntityDescription *entity = [NSEntityDescription
    //                                   entityForName:@"SUNParty" inManagedObjectContext:self.context];
    //    [fetchRequest setEntity:entity];
    //
    //    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
}

#pragma mark - Custom Methods Networking
-(void) getAllPartyRequest{

    NSNumber *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [[SUNPartyMakerSDK sharedInstance] getPartyOfUserWithId:userID.stringValue callback:^(NSDictionary *response, NSError *error) {
        NSLog(@"%@",response);
        if ([[response objectForKey:@"statusCode"] isEqual:@(200)] ){
            if(![[response objectForKey:@"response"] isEqual:[NSNull null]]){
                NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
              
                
                
                for (NSDictionary *dictItem in [response objectForKey:@"response"]) {
                    
                    SUNParty *sunPartyItem = [NSEntityDescription
                                                       insertNewObjectForEntityForName:@"SUNParty"
                                                       inManagedObjectContext:self.context];
                     sunPartyItem = [sunPartyItem makePartyObjectWith:dictItem];

                    [parsedArray addObject:sunPartyItem];
                }
               // self.usersPartyArray = [parsedArray copy];
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    NSError *error;
                    if (![self.context save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    }
                    if (!error) {
                        self.dataArray = [parsedArray copy];
                        [self.partyTableView reloadData];
                        

                    }
                    
                    });

                
            } else {
                if( error != nil ){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                }else {
                    NSLog(@"No parties for now");
                }
            }}
    }];

    
    
    //
    //    SUNParty *sunPartyItem = [NSEntityDescription
    //                                       insertNewObjectForEntityForName:@"SUNParty"
    //                                       inManagedObjectContext:self.context];
    //    sunPartyItem.comment = @"CoreDataWorke" ;
    //
    //
    //    NSError *error;
    //    if (![self.context save:&error]) {
    //        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    //    }
    //
    //     NSError *error;
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSEntityDescription *entity = [NSEntityDescription
    //                                   entityForName:@"SUNParty" inManagedObjectContext:self.context];
    //    [fetchRequest setEntity:entity];
    //
    //    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //    for (SUNParty *info in fetchedObjects) {
    //        [self.usersPartyArray addObject:info];
    //    }
    //    NSLog(@"%lu",(unsigned long)[self.usersPartyArray count]);

}


#pragma mark - for coreData
//make from this method readmethod and write method in SUNDataStore
//- (void)insertNewObject:(id)sender {
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *party = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[party name] inManagedObjectContext:context];
//    
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
//    
////    [newManagedObject setValuesForKeysWithDictionary:@{@"comment":userEmail , @"endTime":password, @"startTime":userName}];
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}

//can be usefull
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *formatedDateWithTime = [NSDate formateToStringDate:savedParty.dateIsChosen startTime:savedParty.sliderTop endTime:savedParty.sliderBot];
//            NSString *imageName = [[NSString alloc] initWithFormat:@"PartyLogo_Small_%li", (long)savedParty.currentPage.currentPage];
//
//            //filling from model from coredata my cell
//                [cell configureWithName:savedParty.partyName dateAndTimeOfParty:formatedDateWithTime logo:[UIImage imageNamed: imageName]];
//        });
//    });

#pragma mark - UITableViewDataSourse methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
    //return self.usersPartyArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SUNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SUNTableViewCell reuseIdentifier] forIndexPath:indexPath];
    
    SUNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SUNTableViewCell reuseIdentifier]];
    if(cell == nil){
        cell = [[SUNTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[SUNTableViewCell reuseIdentifier]];
    }
    
    SUNParty *savedParty = [self.dataArray objectAtIndex:indexPath.row];//[NSKeyedUnarchiver
    
    NSString *imageName ;
    NSString *formatedDateWithTime = [NSDate formateToStringStartTime:@([savedParty startTime]) endTime:@([savedParty endTime])];
    imageName = [[NSString alloc] initWithFormat:@"PartyLogo_Small_%lld", savedParty.logo];

    [cell configureWithName:savedParty.partyName dateAndTimeOfParty:formatedDateWithTime logo:[UIImage imageNamed: imageName]];

    cell.selectedBackgroundView.backgroundColor = [[UIColor alloc] initWithRed:52/255.f green:56/255.f blue:66/255.f alpha:1.f];
    
   // cell.nameOfPartyLabel.text = [(SUNParty *)[self.usersPartyArray objectAtIndex:indexPath.row] comment];
    return cell;
}

#pragma mark - UITableViewDelegate methods
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    return indexPath;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"On row %ld was touched", (long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - segues methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if( [segue.identifier isEqualToString:@"toPartyInfo"] ){
        
        SUNPartyInfoVC *partyInfoVC = segue.destinationViewController;
         //        need to create instance of SUNSaver and then send it to instance of partyInfoVC
//          in dataArray stored instances of SUNSaver with has all property that i need cause it's model
        
        self.indexOfSelectedCell = [self.partyTableView indexPathForSelectedRow].row;
        
        SUNParty *selectedParty = self.dataArray[self.indexOfSelectedCell];
        
        
        
//        
//        NSManagedObjectID *objectIdSelectedParty = [((NSManagedObject *)self.dataArray[self.indexOfSelectedCell]).objectID copy];
//        selectedParty.objectID = objectIdSelectedParty;
//        
        
        
        
        NSLog(@"id of selectedParty = %lld", selectedParty.partyId);
        partyInfoVC.selectedParty = selectedParty;
        partyInfoVC.indexOfSelectedParty = self.indexOfSelectedCell;
        
        NSLog(@"going to party info %li", (long)self.indexOfSelectedCell);
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Accessors
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

-(NSMutableArray *) usersPartyArray{
    if (!_usersPartyArray) {
        _usersPartyArray = [NSMutableArray new];
    }
    return _usersPartyArray;
}

@end
