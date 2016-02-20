//
//  SUNLogoImageV.m
//  PartyMaker
//
//  Created by 2 on 2/15/16.
//  Copyright © 2016 TonyStar. All rights reserved.
//

#import "SUNLogoImageV.h"

@implementation SUNLogoImageV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    self.viewForFirstBaselineLayout.layer.cornerRadius = self.viewForFirstBaselineLayout.frame.size.height/2;
    [self.viewForFirstBaselineLayout.layer setBorderColor:[[UIColor alloc] initWithRed:31/255.f green:34/255.f blue:39/255.f alpha:1.f].CGColor];
    [self.viewForFirstBaselineLayout.layer setBorderWidth:3.0];
}

@end
