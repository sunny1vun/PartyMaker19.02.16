//
//  SUNUniversalView.h
//  PartyMaker
//
//  Created by 2 on 2/10/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNMakingPartyByxibVC.h"
@class SUNUniversalView;

@protocol SUNUniversalViewDelegate<NSObject>
@required

-(void)cancelWasClicked: (SUNUniversalView *) datePickerView;
-(void)doneWasClicked: (SUNUniversalView *) datePickerView;

@end

@interface SUNUniversalView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) id delegate;
- (IBAction)onCancelClicked:(id)sender;
- (IBAction)onDoneClicked:(id)sender;

@end
