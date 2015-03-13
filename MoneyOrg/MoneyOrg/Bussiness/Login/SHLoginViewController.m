//
//  SHLoginViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/18/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHLoginViewController.h"


@interface SHLoginViewController ()

@end

@implementation SHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";//15900706082
    if(  [[NSUserDefaults standardUserDefaults] valueForKey:@"User"] ){
        self.txtLogin.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"User"] valueForKey:@"AccountID"];
    }
    self.navigationItem.leftBarButtonItem = nil;
    self.autoKeyboard = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)__GET_PRE_ACTION_STATE:(NSError*)t
{
    if(SHEntironment.instance.loginName.length > 0){
        return YES;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnInvestorOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"register" delegate:nil containner:self.navigationController];
    [i.args setValue:@"2" forKey:@"type"];

    [[UIApplication sharedApplication]open:i];
}

- (IBAction)btnSumbitOnTouch:(id)sender {
    SHEntironment.instance.loginName = self.txtLogin.text;
    SHEntironment.instance.password = self.txtPassword.text;
    
    SHPostTaskM * p= [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"Login");
    [self showWaitDialogForNetWork];
    [p start:^(SHTask *t) {
        [self.txtPassword resignFirstResponder];
        [self.txtLogin resignFirstResponder];
        [[NSUserDefaults standardUserDefaults]setValue:[ t.result valueForKey:@"UserType"] forKey:@"UserType"];
        [[NSUserDefaults standardUserDefaults]setValue:t.result forKey:@"User"];

        [self dismissWaitDialog];
           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESSFUL object:nil];
    } taskWillTry:^(SHTask *t) {
        
    } taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];

    }];
}

- (IBAction)btnManageMoneyOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"register" delegate:nil containner:self.navigationController];
    [i.args setValue:@"1" forKey:@"type"];
    [[UIApplication sharedApplication]open:i];
}
@end
