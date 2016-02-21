//
//  SUNDataStore.m
//  PartyMaker
//
//  Created by 2 on 2/12/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNDataStore.h"
#import "SUNPartyMakerSDK.h"

@interface SUNDataStore()

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDictionary *senderDictionary;
@property (nonatomic, strong) NSDictionary *responseDictionary;

@property (nonatomic) NSInteger count;

@end

@implementation SUNDataStore

#pragma mark - singlton

+(instancetype) sharedInstance{
    
    static SUNDataStore *instance = nil;
    static dispatch_once_t oncedbExchange;
    dispatch_once(&oncedbExchange, ^{
        instance = [[self alloc] init];
        //call method below only setup instance of datacore (logic like in networkingControl)
        //it not make any change to plist-Logic
//        [instance initializeCoreDataFor];
        NSLog(@"DataStore initialised in singlton");

    });
    
    return instance;
}

#pragma mark - need to make from methods below new db methods


#pragma mark - saving reading

+(NSMutableArray *)readFromPlist{
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    NSString *partiesFilePathInDocuments = [documentPath stringByAppendingPathComponent:@"myLogs.plist"];
    
    NSMutableArray *dataFromFile = [[NSMutableArray alloc] init];
    if([filemanager fileExistsAtPath:partiesFilePathInDocuments]){
        
        dataFromFile = [NSMutableArray arrayWithContentsOfFile:partiesFilePathInDocuments];
//        NSLog(@"from here was readed: %@", partiesFilePathInDocuments );
        
    }else {
        NSLog(@"File is not exist at path: %@", partiesFilePathInDocuments);
    }
    
    return dataFromFile;
}

+(BOOL)saveToPlist:(NSMutableArray*) dataFromFile{
    
    BOOL wasSaved = NO;
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    NSString *partiesFilePathInDocuments = [documentPath stringByAppendingPathComponent:@"myLogs.plist"];
    NSString *partiesFilePathInBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/myLogs.plist"];
//        NSLog(@"%@",partiesFilePathInDocuments);
//    NSMutableArray *dataFromFile = [[NSMutableArray alloc] init];
    
    if( ![filemanager fileExistsAtPath: partiesFilePathInDocuments] ){
        
        NSError *error;
        [filemanager copyItemAtPath:partiesFilePathInBundle toPath:partiesFilePathInDocuments error:&error];
        
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
//        [dataFromFile addObject:data];
        NSArray *dataToWrite = [NSArray arrayWithArray:dataFromFile];
        [dataToWrite writeToFile:partiesFilePathInDocuments atomically:YES];
        wasSaved =  YES;
        
        if ( !error ) {
            
            wasSaved = NO;
            NSLog(@"%@", error);
            
        }
        
    }else {
        
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
//
//        //i need checking if i'm storing a new party or i'm storing edited party
//        [dataFromFile addObject:data];
//        checking was made on click of save button in my creating\editing view SUNMakingPartyByxibVC
        
        NSArray *dataToWrite = [NSArray arrayWithArray:dataFromFile];
        
        [dataToWrite writeToFile:partiesFilePathInDocuments atomically:YES];
        
        wasSaved = YES;
        
    }
    
    return wasSaved;
    
}

@end
