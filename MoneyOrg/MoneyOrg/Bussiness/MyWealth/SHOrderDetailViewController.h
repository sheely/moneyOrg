//
//  SHOrderDetailViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/2/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHOrderDetailViewController : SHViewController
@property (weak, nonatomic) IBOutlet UILabel *labLicaiId;
@property (weak, nonatomic) IBOutlet UILabel *labKehuId;
@property (weak, nonatomic) IBOutlet UILabel *labOrderId;
@property (weak, nonatomic) IBOutlet UILabel *labProdId;
@property (weak, nonatomic) IBOutlet UILabel *labTradeType;
@property (weak, nonatomic) IBOutlet UILabel *labApplyFene;
@property (weak, nonatomic) IBOutlet UILabel *labApplyMoney;
@property (weak, nonatomic) IBOutlet UILabel *labOrderDay;
@property (weak, nonatomic) IBOutlet UILabel *labOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *labTradeState;

@end
