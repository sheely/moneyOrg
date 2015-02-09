//
//  SHMyWealthFinancial ViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHMyWealthFinancialViewController.h"

@interface SHMyWealthFinancialViewController ()

@end

@implementation SHMyWealthFinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的财富";
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetOrderList");
    [p.postArgs setValue:@"1" forKey:@"PageSize"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    [p start:^(SHTask *t) {
        self.labLevel.text = [t.result valueForKey:@"MyScore"];
        self.labMoney.text = [t.result valueForKey:@"Earned"];
        self.labMoney2.text = [t.result valueForKey:@"WillEarn"];
        [self.imgView setUrl:[t.result valueForKey:@"UserVPhoto"]];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)btnOrderListOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"order_list" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:i];
}
@end
