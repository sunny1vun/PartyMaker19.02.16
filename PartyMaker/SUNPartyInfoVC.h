//
//  SUNPartyInfoVC.h
//  PartyMaker
//
//  Created by 2 on 2/14/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSaver.h"
#import "SUNParty.h"

@interface SUNPartyInfoVC : UIViewController

@property (nonatomic, strong) SUNSaver  *selectedParty;
@property (nonatomic) NSInteger indexOfSelectedParty;

@end
