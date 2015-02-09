//
//  SHProductListViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/26/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHTableViewController.h"

@interface SHProductListViewController : SHTableViewController<UITableViewDataSource>
- (IBAction)btnT1OnTouch:(id)sender;
- (IBAction)btnT2OnTouch:(id)sender;
- (IBAction)btnT3OnTouch:(id)sender;
- (IBAction)btnT4OnTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnT1;

@end
