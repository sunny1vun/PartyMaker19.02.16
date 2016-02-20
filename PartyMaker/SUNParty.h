//
//  SUNParty.h
//  PartyMaker
//
//  Created by Vlad Sydorenko on 2/20/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUNParty : NSManagedObject
// Insert code here to declare functionality of your managed object subclass
- (instancetype) makePartyObjectWith:(NSDictionary *) parameters;
@end

NS_ASSUME_NONNULL_END

#import "SUNParty+CoreDataProperties.h"
