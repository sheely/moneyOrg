//
//  SHProductCell.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/31/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHTableViewCell.h"

@interface SHProductCell : SHTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labC1;
@property (weak, nonatomic) IBOutlet UILabel *labC2;
@property (weak, nonatomic) IBOutlet UILabel *labC3;
@property (weak, nonatomic) IBOutlet UILabel *labC4;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labCusNum;
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@end
