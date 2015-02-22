//
//  SHMyWealthFinancial ViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHMyWealthFinancialViewController : SHViewController
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labLevel;
@property (weak, nonatomic) IBOutlet SHImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labMoney2;
- (IBAction)btnOrderListOnTouch:(id)sender;
- (IBAction)btnCusOnTouch:(id)sender;
- (IBAction)btnQualificationOnTouch:(id)sender;

@end
