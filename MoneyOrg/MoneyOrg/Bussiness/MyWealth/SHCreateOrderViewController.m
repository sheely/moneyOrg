//
//  SHCreateOrderViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/13/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHCreateOrderViewController.h"

@interface SHCreateOrderViewController ()

@end

@implementation SHCreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建订单";
    self.labTitle.text = [self.intent.args valueForKey:@"product_name"];
    self.txtUser.text = [[self.intent.args valueForKey:@"user"] valueForKey:@"UserName"];
    if([[[self.intent.args valueForKey:@"user"] valueForKey:@"UserCode"] length] > 0){
        self.txtUser.text = [[self.intent.args valueForKey:@"user"] valueForKey:@"UserName"];

    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ok"]  target:self action:@selector(btnOK:)];

    // Do any additional setup after loading the view from its nib.
}

- (void)btnOK:(UIButton*)b
{
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"CreateOrder");
    if([[[self.intent.args valueForKey:@"user"] valueForKey:@"UserCode"] length] > 0){
         [p.postArgs setValue: [[self.intent.args valueForKey:@"user"] valueForKey:@"UserCode"]forKey:@"CustomerUserCode"] ;
        [p.postArgs setValue: @"" forKey:@"CustomerPhone"] ;

    }else{
        [p.postArgs setValue: self.txtUser.text forKey:@"CustomerPhone"] ;
        [p.postArgs setValue: @"" forKey:@"CustomerUserCode"] ;
        
    }
   
    
    
    
    [p.postArgs setValue: [self.intent.args valueForKey:@"product_id"]forKey:@"ProductID"];
    [p.postArgs setValue: self.txtField.text forKey:@"ApplyMoney"];

    [p start:^(SHTask * t) {
        [t.respinfo show];
        [self.navigationController popViewControllerAnimated:YES];
    } taskWillTry: nil taskDidFailed:^(SHTask * t) {
        [t.respinfo show];
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
