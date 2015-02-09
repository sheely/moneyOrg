//
//  SHAssembleViewCell.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/8/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHTableViewCell.h"

@interface SHAssembleViewCell : SHTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labLevel;
@property (weak, nonatomic) IBOutlet UILabel *labCusNum;

@end
