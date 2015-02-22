//
//  SHQualificationExaminationViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/21/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHQualificationExaminationViewController : SHViewController
@property (weak, nonatomic) IBOutlet SHImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextField *txtCardID;
- (IBAction)btnUploadImageOnTouch:(id)sender;

@end
