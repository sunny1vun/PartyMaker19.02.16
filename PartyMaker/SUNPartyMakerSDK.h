//
//  SUNPartyMakerSDK.h
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUNPartyMakerSDK : NSObject

@property (nonatomic, strong) NSURLSession *defaultSession;

+(SUNPartyMakerSDK*) sharedInstance;

-(NSMutableURLRequest *) request: (NSString *)method withMethod:(NSString*)methodApi headers:(NSDictionary*)headers parameters: (NSDictionary*)parameters;

-(void) loginWithUserName:(NSString *) userName andPassword:(NSString *) password callback:(void (^) (NSDictionary *response, NSError *error))block;

-(void) registerWithUserEmail:(NSString *) userEmail andPassword:(NSString *) password andName:(NSString*) userName callback:(void (^) (NSDictionary *response, NSError *error))block;

-(void) getPartyOfUserWithId:(NSString *) creatorId callback:(void (^) (NSDictionary *response, NSError *error))block;

-(void) addPartyWithId:(NSString *) partyId name:(NSString *) name startTime:(NSString *) startTime endTime:(NSString *) endTime logoId:(NSString *) logoNumber comment:(NSString *) partyDiscription creatorId:(NSString *) creatorId latitude:(NSString *) latitude longitude:(NSString *) longitude callback:(void (^) (NSDictionary *response, NSError *error))block;

-(void) deletePartyWithId:(NSString *) partyId callback:(void (^) (NSDictionary *response, NSError *error))block;

-(void) allUsers:(NSString *) allUsers callback:(void (^) (NSDictionary *response, NSError *error))block;

@end
