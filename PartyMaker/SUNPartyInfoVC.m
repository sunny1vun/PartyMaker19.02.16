//
//  SUNPartyInfoVC.m
//  PartyMaker
//
//  Created by 2 on 2/14/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNAppDelegate.h"
#import "SUNPartyInfoVC.h"
#import "SUNMakingPartyByxibVC.h"
#import "SUNDataStore.h"
#import <UIKit/UIKit.h>
//#import "SUNSaver.h"

@interface SUNPartyInfoVC ()

//info about party
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *nameParty;
@property (weak, nonatomic) IBOutlet UILabel *descriptionParty;
@property (weak, nonatomic) IBOutlet UILabel *dateParty;
@property (weak, nonatomic) IBOutlet UILabel *timeStartParty;
@property (weak, nonatomic) IBOutlet UILabel *timeEndParty;
@property (weak, nonatomic) IBOutlet UIView *logoContainerView;

//for actions with window
@property (weak, nonatomic) IBOutlet UIButton *deleteParty;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoParty;
@property (weak, nonatomic) IBOutlet UIButton *editParty;


@end

@implementation SUNPartyInfoVC

-(void)viewWillAppear:(BOOL)animated{
    self.context = [MyDelegate backgroundThreadContext];

    [super viewWillAppear:animated];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateOfParty = [NSDate dateWithTimeIntervalSince1970:self.selectedParty.startTime];
    NSString *dateOfSelectedParty = [dateFormat stringFromDate:dateOfParty];
    
    NSString *nameOfSelectedParty = self.selectedParty.partyName;
    
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *startTime = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970: self.selectedParty.startTime]];
    NSString *endTime = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.selectedParty.endTime]];
    
    NSString *comment = self.selectedParty.comment;
    UIImage *logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%lld", self.selectedParty.logo]];
    
    //filing UI with new model for coreData and network

    [self.dateParty setText:dateOfSelectedParty];
    [self.nameParty setText:nameOfSelectedParty];
    [self.timeStartParty setText:startTime];
    [self.timeEndParty setText:endTime];
    [self.descriptionParty setText:comment];
    [self.logoView setImage: logoImage];
    
    
    self.addPhotoParty.layer.cornerRadius =
    self.editParty.layer.cornerRadius =
    self.deleteParty.layer.cornerRadius = 5.f;
    [self.navigationItem.backBarButtonItem setTintColor:[[UIColor alloc] initWithRed:21/255.f green:22/255.f blue:26/255.f alpha:1.f]];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem.backBarButtonItem setTintColor:[[UIColor alloc] initWithRed:21/255.f green:22/255.f blue:26/255.f alpha:1.f]];
    
}

#pragma mark - delete party

- (IBAction)deleteParty:(id)sender {
    
    
    
    
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
    }
    
    [context deleteObject:fetchedObjects[self.indexOfSelectedParty]];
    
    if(![context save:&error]){
        NSLog(@"%@",error);
    }
    
    
    
    
    self.deleteParty.enabled = NO;
//    NSMutableArray *parties = [SUNDataStore readFromPlist];
//    [parties removeObjectAtIndex:self.indexOfSelectedParty];
//    NSLog(@"data of party was deleted from parties");
//    [SUNDataStore saveToPlist:parties];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if( [segue.identifier isEqualToString:@"toEditParty"] ){
        
        NSLog(@"going to edit party %@ %li", self.selectedParty.partyName, (long)self.indexOfSelectedParty);
        
        SUNMakingPartyByxibVC *editParty = segue.destinationViewController;
        
        editParty.partyToChange = self.selectedParty;
        editParty.indexOfPartyToChange = self.indexOfSelectedParty;
        
        
    }
    
}

@end
