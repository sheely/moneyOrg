//
//  SHCustomInfoViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/25/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHTableViewController.h"

@interface SHCustomInfoViewController : SHViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
