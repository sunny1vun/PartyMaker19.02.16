//
//  SUNParty.m
//  PartyMaker
//
//  Created by Tony on 2/20/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNParty.h"
#import "SUNAppDelegate.h"
@implementation SUNParty

// Insert code here to add functionality to your managed object subclass

@synthesize backgroundThreadContext= _backgroundThreadContext;
@synthesize hasChanged = _hasChanged;
@synthesize objectID = _objectID;

-(NSManagedObjectContext *)backgroundThreadContext{

    if(_backgroundThreadContext != nil){
        return _backgroundThreadContext;
    }
    
//    if(_hasChanged){
//        NSLog(@"party in coreData hasChanges");
//    }
    
    _backgroundThreadContext = [MyDelegate backgroundThreadContext];
    return _backgroundThreadContext;
}

-(BOOL)hasChanged{
    
    return _hasChanged;
}

-(NSManagedObjectID *)objectID{
    
    return _objectID;
}
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
