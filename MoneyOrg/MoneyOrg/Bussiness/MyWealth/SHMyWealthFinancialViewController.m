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
- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= 50;
    self.navigationController.view.frame =rect;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.navigationController.view.frame =rect;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的财富";
    if(INVESTOR){
        self.viewMoney.hidden = YES;
        self.btnMoneyManager.hidden = NO;
        self.imgArrowZhiye.hidden = YES;
    }else{
        self.labZhiye.hidden = NO;
        self.labZhiyeState.hidden = NO;
        self.viewMyCustomer.hidden = NO;
    }
    
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetUserDetail");
    [p start:^(SHTask *t) {
        
        [self.btnMoneyManager setTitle:[ NSString stringWithFormat:@"我的理财师  :  %@",[t.result valueForKey:@"MyAccountants" ]] forState: UIControlStateNormal   ];
        self.labZhiyeState.text = [[t.result valueForKey:@"HasConfirm"] boolValue]? @"[已认证]":@"[未认证]";
        self.labLevel.text = [NSString stringWithFormat:@"等级:%d",[[t.result valueForKey:@"Score"] intValue]/100];
        self.labMoney.text = [[t.result valueForKey:@"Earned"] stringValue];
        self.labMoney2.text = [[t.result valueForKey:@"WillEarn"] stringValue];
        self.labName.text = [t.result valueForKey:@"UserName"];
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

- (IBAction)btnCusOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:i];

}

- (IBAction)btnQualificationOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"qualification_examination" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:i];

}
@end
