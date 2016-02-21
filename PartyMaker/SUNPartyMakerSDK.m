//
//  SUNPartyMakerSDK.m
//  PartyMaker
//
//  Created by 2 on 2/16/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNPartyMakerSDK.h"
#import "SUNSaver.h"

@interface SUNURLSession : NSURLSession

@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation SUNPartyMakerSDK

NSString *APIURLLink = @"http://itworksinua.km.ua/party";


+(SUNPartyMakerSDK*) sharedInstance{
    
    static SUNPartyMakerSDK *instance = nil;
    static dispatch_once_t onceSUNDataExchange;
    dispatch_once(&onceSUNDataExchange, ^{
        instance = [[SUNPartyMakerSDK alloc] init];
        [instance configureSessionAndAPI];
    });
    
    return instance;
}

-(void) configureSessionAndAPI{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    //
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.allowsCellularAccess = NO;
    self.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig];
    
}


//тут дикшнари, в нем нейм и пароль
-(NSMutableURLRequest *) request: (NSString *)method withMethod:(NSString*)methodApi headers:(NSDictionary*)headers parameters: (NSDictionary*)parameters{
    
    NSString * concatenatedURL = [APIURLLink stringByAppendingString:methodApi];
    concatenatedURL = [concatenatedURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:concatenatedURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"GET"]) {
        concatenatedURL = [concatenatedURL stringByAppendingString:@"?"];
        for (NSString* key in parameters.allKeys) {
            concatenatedURL = [concatenatedURL stringByAppendingString:key];
            concatenatedURL = [concatenatedURL stringByAppendingString:@"="];
            concatenatedURL = [concatenatedURL stringByAppendingString:[parameters objectForKey:key]];
            concatenatedURL = [concatenatedURL stringByAppendingString:@"&"];
        }
        concatenatedURL = [concatenatedURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        request.URL = [NSURL URLWithString:concatenatedURL];
        
    }
    else if ([method isEqualToString:@"POST"]){
//        NSString *secondConcatenatedURl = [ concatenatedURL stringByAppendingString:@"?"];
        NSString *secondConcatenatedURL = @"";
//        NSLog(@"%@",concatenatedURL);
        for (NSString* key in parameters.allKeys) {
            secondConcatenatedURL = [secondConcatenatedURL stringByAppendingString:key];
            secondConcatenatedURL = [secondConcatenatedURL stringByAppendingString:@"="];
            secondConcatenatedURL = [secondConcatenatedURL stringByAppendingString:[parameters objectForKey:key]];
            secondConcatenatedURL = [secondConcatenatedURL stringByAppendingString:@"&"];
        }
        secondConcatenatedURL = [secondConcatenatedURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSLog(@"%@",secondConcatenatedURL);
        NSData *reqData = [secondConcatenatedURL dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:reqData];
        
    }
    return request;
    

}

- (void) loginWithUserName:(NSString *) userName andPassword:(NSString *) password callback:(void (^) (NSDictionary *response, NSError *error))block{
    
    NSURLRequest * request = [self request:@"GET" withMethod:@"/login" headers:nil parameters:@{@"name":userName, @"password":password}];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (block)
              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
      }] resume];
    
}

- (void) registerWithUserEmail:(NSString *) userEmail andPassword:(NSString *) password andName:(NSString*) userName callback:(void (^) (NSDictionary *response, NSError *error))block{
    
    NSURLRequest * request = [self request:@"POST" withMethod:@"/register" headers:nil parameters:@{@"email":userEmail , @"password":password, @"name":userName}];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (block)
              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
      }] resume];
    
}

//get all perty of user
-(void)getPartyOfUserWithId:(NSString *)creatorId callback:(void (^)(NSDictionary *, NSError *))block{
    NSDictionary *parameters = @{@"creator_id": creatorId};
    
    
    NSURLRequest * request = [self request:@"GET" withMethod:@"/party" headers:nil parameters:parameters];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (block)
              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
      }] resume];
    
}


-(void) addPartyWithId:(NSString *)partyId name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime logoId:(NSString *)logoNumber comment:(NSString *)partyDiscription creatorId:(NSString *)creatorId latitude:(NSString *)latitude longitude:(NSString *)longitude callback:(void (^) (NSDictionary *response, NSError *error))block{
    //that block will be runned here not in class-caller (class who calls)
    NSDictionary *parameter_ = @{@"name": name,
                                 @"start_time": startTime,
                                 @"end_time": endTime,
                                 @"logo_id": logoNumber,
                                 @"comment": partyDiscription,
                                 @"creator_id": creatorId,
                                 @"latitude": latitude,
                                 @"longitude": longitude
                                 };
    
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameter_];
    
    if (partyId || ![partyId isEqualToString:@""]) {
        [mutableParameters setValue:partyId forKey:@"party_id"];
        NSLog(@"party is going to edit server party with id %@", partyId);
    }
    
    
    NSURLRequest * request = [self request:@"POST" withMethod:@"/addParty" headers:nil parameters:mutableParameters
  ];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {//<- that block is anonim and will be used by resume method someWhere in runTime
          if (block)
              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
      }] resume];
    
}

-(void) deletePartyWithId:(NSString *) partyId callback:(void (^) (NSDictionary *response, NSError *error))block{
    
    NSURLRequest * request = [self request:@"GET" withMethod:@"/deleteParty" headers:nil parameters:@{@"party_id": partyId}];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (block)
              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
      }] resume];
    
}

-(void) allUsers:(NSString *) allUsers callback:(void (^) (NSDictionary *response, NSError *error))block{
    
    NSURLRequest * request = [self request:@"GET" withMethod:@"/allUsers" headers:nil parameters:@{@"allUsers": allUsers}];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (block)
              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
      }] resume];
    
}

//- (void) addPartyWithUser:(NSString *) userEmail andPassword:(NSString *) password andName:(NSString*) userName callback:(void (^) (NSDictionary *response, NSError *error))block{
//    
//    NSURLRequest * request = [self request:@"POST" withMethod:@"/register" headers:nil parameters:@{@"email":userEmail , @"password":password, @"name":userName}];
//    
//    [[self.defaultSession dataTaskWithRequest:request completionHandler:
//      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//          if (block)
//              block([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
//      }] resume];
//    
//}

- (NSDictionary* ) serialize:(NSData *) _data statusCode:(NSNumber *) _statusCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_statusCode)
        [dict setValue:_statusCode forKey:@"statusCode"];
    else
        [dict setValue:@505 forKey:@"statusCode"];
    
    id jsonArray;
    if (_data)
        jsonArray = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:nil];
    
    if (!jsonArray)
        jsonArray = [NSNull null];
    
    [dict setValue:jsonArray forKey:@"response"];
    
    return dict;
    
}

@end
