//
//  SUNSaver.m
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNSaver.h"

@interface SUNSaver()

@end

@implementation SUNSaver

+(SUNSaver*) sharedInstance{
    
    static SUNSaver *instance = nil;
    static dispatch_once_t oncedbExchange;
    dispatch_once(&oncedbExchange, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - init fits to coreData model and plist

-(instancetype) initWithCreatorId:(NSNumber *)creatorId   startTime:(NSNumber *)startTime
                          endTime: (NSNumber *)endTime logo:(NSNumber *)currentPage  partyId:(NSNumber*)partyId latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude description:(NSString *)description partyName:(NSString *)partyName{
    
    //for now creatorId = 64 (when remember user localy then change here to
    //   self.creatorId = creatorId;
    self.creatorId = [[NSNumber alloc] initWithInt:64];
    self.startTime = startTime;
    self.endTime = endTime;
    self.logo = currentPage;
    self.partyId = partyId;
    //for now latitude and longitude are static
    //    self.latitude = latitude;
    //    self.longitude = longitude;
    self.latitude = [[NSNumber alloc] initWithInt:100];
    self.longitude = [[NSNumber alloc] initWithInt: 100];
    self.comment = description;
    self.nameOfParty = partyName;
    
    //    self.uniqueID =
    return self;
}


#pragma mark- init fits to plist

-(instancetype) initWithName:(NSString *)name   date:(NSString *)date
                   sliderTop: (UISlider *)sliderTop     sliderBot:(UISlider *)sliderBot
                 description:(NSString *)description    pageControl:(UIPageControl *)pageControl{
    self = [super init];
    self.partyName = name;
    self.dateIsChosen = date;
    self.sliderTop = sliderTop;
    self.sliderBot = sliderBot;
    self.descriptionOfParty = description;
    self.currentPage = pageControl;
//    self.uniqueID = 
    
    return self;
}

#pragma mark- coding encoding fits both

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if( self ){
        if ( self.dateIsChosen != nil ) {
            //for plist without networking instance
            self.dateIsChosen = [aDecoder decodeObjectForKey:@"dateIsChosen"];
            self.partyName = [aDecoder decodeObjectForKey:@"partyName"];
            self.sliderTop = [aDecoder decodeObjectForKey:@"sliderTop"];
            self.sliderBot = [aDecoder decodeObjectForKey:@"sliderBot"];
            self.currentPage = [aDecoder decodeObjectForKey:@"currentPage"];
            self.descriptionOfParty = [aDecoder decodeObjectForKey:@"descriptionOfParty"];
            
            
        }else{
            //for plist with networking instance withot partyId it will be given by server
            self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
            self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
            self.logo = [aDecoder decodeObjectForKey:@"logo"];
            self.comment = [aDecoder decodeObjectForKey:@"comment"];
            self.creatorId = [aDecoder decodeObjectForKey:@"creatorId"];
            self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
            self.longitude =  [aDecoder decodeObjectForKey:@"longitude"];
            self.partyId = [aDecoder decodeObjectForKey:@"partyId"];
            self.nameOfParty = [aDecoder decodeObjectForKey:@"nameOfParty"];
        }
}

    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{

    if( self ){
        if ( self.dateIsChosen != nil ) {
            [aCoder encodeObject:self.dateIsChosen forKey:@"dateIsChosen"];
            [aCoder encodeObject:self.partyName forKey:@"partyName"];
            [aCoder encodeObject:self.sliderTop forKey:@"sliderTop"];
            [aCoder encodeObject:self.sliderBot forKey:@"sliderBot"];
            [aCoder encodeObject:self.currentPage forKey:@"currentPage"];
            [aCoder encodeObject:self.descriptionOfParty forKey:@"descriptionOfParty"];
        }else{
            [aCoder encodeObject:self.startTime forKey:@"startTime"];
            [aCoder encodeObject:self.endTime forKey:@"endTime"];
            [aCoder encodeObject:self.logo forKey:@"logo"];
            [aCoder encodeObject:self.comment forKey:@"comment"];
            [aCoder encodeObject:self.creatorId forKey:@"creatorId"];
            [aCoder encodeObject:self.latitude forKey:@"latitude"];
            [aCoder encodeObject:self.longitude forKey:@"longitude"];
            [aCoder encodeObject:self.partyId forKey:@"partyId"];
            [aCoder encodeObject:self.nameOfParty forKey:@"nameOfParty"];
        }}
}




@end
