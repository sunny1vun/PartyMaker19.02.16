//
//  SUNSaver.h
//  PartyMaker
//
//  Created by 2 on 2/9/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN


@interface SUNSaver : NSObject <NSCoding>


@property (nonatomic, strong) NSString *partyName;
@property (nonatomic, strong) NSString *dateIsChosen;
@property (nonatomic, strong) UISlider *sliderTop;
@property (nonatomic, strong) UISlider *sliderBot;
@property (nonatomic, strong) NSString *descriptionOfParty;
@property (nonatomic, strong) UIPageControl * currentPage;
//запилить уникальный айди для каждой сохраняемой пати
@property (nonatomic) int uniqueID;
//@property (nonatomic, strong) NSData 

-(instancetype) initWithName:(NSString *)name   date:(NSString *)date
                   sliderTop: (UISlider *)sliderTop     sliderBot:(UISlider *)sliderBot
                 description:(NSString *)description    pageControl:(UIPageControl *)pageControl;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSNumber *partyId;
@property (nullable, nonatomic, strong) NSString *nameOfParty;
@property (nonatomic) NSNumber* startTime;
@property (nonatomic) NSNumber* endTime;
@property (nullable, nonatomic, strong) NSString *comment;
@property (nonatomic) NSNumber* logo;
@property (nonatomic) NSNumber* creatorId;
@property (nonatomic) NSNumber* latitude;
@property (nonatomic) NSNumber* longitude;

+(SUNSaver *) sharedInstance;


-(instancetype) initWithCreatorId:(NSNumber *)creatorId   startTime:(NSNumber *)startTime
                  endTime: (NSNumber *)endTime logo:(NSNumber *)currentPage  partyId:(NSNumber*)partyId latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude description:(NSString *)description partyName:(NSString *)partyName;



@end

NS_ASSUME_NONNULL_END
