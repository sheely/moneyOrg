//
//  SHLoginViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/18/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHLoginViewController : SHViewController
- (IBAction)btnInvestorOnTouch:(id)sender;
- (IBAction)btnSumbitOnTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
