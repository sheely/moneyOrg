//
//  SHOrderCell.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/2/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHTableViewCell.h"

@interface SHOrderCell : SHTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labState;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labCommission;

@end
