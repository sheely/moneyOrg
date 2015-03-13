//
//  SHRegViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/18/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHRegViewController : SHViewController
- (IBAction)btnValidOnTouch:(id)sender;
- (IBAction)btnRegistOnTouch:(id)sender;
- (IBAction)btnLicenceOnTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtValidCode;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *switch_new;

@end
