//
//  SHQuestionnairesurveyViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/23/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHQuestionnairesurveyViewController : SHViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtMoney;
- (IBAction)btnAgeOnTouch:(id)sender;
- (IBAction)btnMoneyOnTouch:(id)sender;
- (IBAction)btnYearOnTouch:(id)sender;
- (IBAction)btnDangerOnTouch:(id)sender;
- (IBAction)btnInComeOnTouch:(id)sender;
- (IBAction)btnTypeOnTouch:(id)sender;

@end
