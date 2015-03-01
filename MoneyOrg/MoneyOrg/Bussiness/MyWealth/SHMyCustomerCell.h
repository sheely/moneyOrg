//
//  SHMyCustomerCell.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/11/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHTableViewCell.h"

@interface SHMyCustomerCell : SHTableViewTitleContentCell
@property (weak, nonatomic) IBOutlet SHImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;
@property (weak, nonatomic) IBOutlet UISwitch *switch_sms;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)btnOrderOnTouch:(id)sender;
- (IBAction)btnDeleteOnTouch:(id)sender;

@end
