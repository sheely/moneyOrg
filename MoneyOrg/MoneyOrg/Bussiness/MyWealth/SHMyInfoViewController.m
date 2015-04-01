//
//  SHMyInfoViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/27/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHMyInfoViewController.h"

@interface SHMyInfoViewController ()

@end

@implementation SHMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" target:self action:@selector(btnEdit:)];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetUserDetail");
    [p start:^(SHTask *t) {
        self.txtUserName.text = [t.result valueForKey:@"CNUserName"];
        self.txtCard.text = [t.result valueForKey:@"IDCardSN"];
        self.txtMoneyCard.text = [t.result valueForKey:@"BankCardSN"];
        self.txtMail.text = [t.result valueForKey:@"Email"];
        self.labAccount.text = [t.result valueForKey:@"AccountID"];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];

    // Do any additional setup after loading the view from its nib.
}

- (void)btnEdit:(UIButton*)b
{
    self.txtCard.enabled = YES;
    self.txtCard.borderStyle = UITextBorderStyleRoundedRect;

    self.txtMail.enabled = YES;
    self.txtMail.borderStyle = UITextBorderStyleRoundedRect;

    self.txtMoneyCard.enabled = YES;
    self.txtMoneyCard.borderStyle = UITextBorderStyleRoundedRect;

    self.txtUserName.enabled = YES;
    self.txtUserName.borderStyle = UITextBorderStyleRoundedRect;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" target:self action:@selector(btnSubmit:)];

}

-(void)btnSubmit:(UIButton*)b
{
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"SettingUserDetail");
 
    [p.postArgs setValue:@"" forKey:@"UserPhoto"];
    [p.postArgs setValue:self.txtUserName.text forKey:@"CNUserName"];
    [p.postArgs setValue:self.txtCard.text forKey:@"IDCardSN"];
    [p.postArgs setValue:self.txtMoneyCard.text forKey:@"BankCardSN"];
    [p.postArgs setValue:self.txtMail.text forKey:@"Email"];
    [p.postArgs setValue:self.txtMail.text forKey:@"Email"];

    [p start:^(SHTask *t) {
        
        [self dismissWaitDialog];
        [t.respinfo show];

    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];
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
