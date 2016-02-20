//
//  SUNUniversalView.m
//  PartyMaker
//
//  Created by 2 on 2/10/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNUniversalView.h"

@implementation SUNUniversalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)onCancelClicked:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector: @selector(cancelWasClicked:)]) {
        
        [self.delegate performSelector:@selector(cancelWasClicked:) withObject:self];
    }
    
    
}

- (IBAction)onDoneClicked:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector: @selector(doneWasClicked:)]) {
        
        [self.delegate performSelector:@selector(doneWasClicked:) withObject:self];
    }
    
    
}

@end
