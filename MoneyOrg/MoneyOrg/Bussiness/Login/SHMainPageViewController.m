//
//  SHMainPageViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/18/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHMainPageViewController.h"
#import "SHLoginViewController.h"
@interface SHMainPageViewController ()

@end

@implementation SHMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    [self performSelector:@selector(loginSuc) afterNotification:@"notification_login_successful"];
    // Do any additional setup after loading the view from its nib.
}

- (void)loginSuc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
