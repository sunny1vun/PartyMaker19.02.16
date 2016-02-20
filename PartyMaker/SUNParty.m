//
//  SUNParty.m
//  PartyMaker
//
//  Created by Vlad Sydorenko on 2/20/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNParty.h"

@implementation SUNParty

// Insert code here to add functionality to your managed object subclass
- (instancetype) makePartyObjectWith:(NSDictionary *) parameters{
    
    self.creatorId = [[parameters objectForKey:@"creator_id"] intValue];
    self.partyId = [[parameters objectForKey:@"id"] intValue];
    self.startTime = [[parameters objectForKey:@"start_time"] intValue];
    self.endTime = [[parameters objectForKey:@"end_time"] intValue];
    self.latitude = [[parameters objectForKey:@"latitude"] doubleValue];
    self.longitude = [[parameters objectForKey:@"longitude"] doubleValue];
    self.comment = [parameters objectForKey:@"comment"];
    self.partyName = [parameters objectForKey:@"name"];
    self.logo = [[parameters objectForKey:@"logo_id"] intValue];
    
    return self;
}


@end
