//
//  SUNParty+CoreDataProperties.h
//  PartyMaker
//
//  Created by Vlad Sydorenko on 2/20/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SUNParty.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUNParty (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comment;
@property (nonatomic) int64_t creatorId;
@property (nonatomic) int64_t endTime;
@property (nonatomic) double latitude;
@property (nonatomic) int64_t logo;
@property (nonatomic) double longitude;
@property (nonatomic) int64_t partyId;
@property (nullable, nonatomic, retain) NSString *partyName;
@property (nonatomic) int64_t startTime;

@end

NS_ASSUME_NONNULL_END
