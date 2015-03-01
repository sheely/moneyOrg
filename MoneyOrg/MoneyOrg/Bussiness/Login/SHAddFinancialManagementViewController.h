//
//  SHAddFinancialManagementViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHAddFinancialManagementViewController : SHViewController
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch2;
- (IBAction)btnCode:(id)sender;
- (IBAction)btnMobile:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;

@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
- (IBAction)btnSearchOnTouch:(id)sender;
@end
