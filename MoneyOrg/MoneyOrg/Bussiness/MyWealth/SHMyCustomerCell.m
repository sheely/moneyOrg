//
//  SHMyCustomerCell.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/11/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHMyCustomerCell.h"

@implementation SHMyCustomerCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadSkin
{
    [super loadSkin];
    self.imgView.layer.cornerRadius = 5;
    self.imgView.layer.masksToBounds = YES;
    self.btnDelete.layer.cornerRadius = 5;
    self.btnOrder.layer.cornerRadius = 5;
    self.btnAdd.layer.cornerRadius = 5;
}



- (IBAction)btnOrderOnTouch:(id)sender{
}

- (IBAction)btnDeleteOnTouch:(id)sender {
}
@end
