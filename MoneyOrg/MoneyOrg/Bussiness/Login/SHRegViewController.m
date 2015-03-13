//
//  SHRegViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/18/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHRegViewController.h"

@interface SHRegViewController ()

@end

@implementation SHRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[self.intent.args valueForKey:@"type"] isEqualToString:@"1"]){
        self.title = @"理财师注册";

    }else{
        self.title = @"投资者注册";
    }
    self.autoKeyboard = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnValidOnTouch:(id)sender {
    
    if([self.txtName.text length] >= 11){
        SHPostTaskM * post = [[SHPostTaskM alloc]init];
        [post.postArgs setValue:self.txtName.text forKey:@"Mobile"];
        post.URL = URL_FOR(@"SendCode");
        [post start:^(SHTask *t) {
            [t.respinfo show];
        } taskWillTry:nil taskDidFailed:^(SHTask *t) {
            [t.respinfo show];
        }];
        
    }
}

- (IBAction)btnRegistOnTouch:(id)sender {
    if(!self.switch_new.on){
        [self showAlertDialog:@"请先同意用户使用协议."];
        return;
    }
    [self showWaitDialogForNetWork];
    SHEntironment.instance.loginName = self.txtName.text;
    SHEntironment.instance.password = self.txtPassword.text;
    
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"CheckCode");
    [p.postArgs setValue:self.txtName.text forKey:@"Mobile"];
    [p.postArgs setValue:[self.intent.args valueForKey:@"type"] forKey:@"UserType"];
    [p.postArgs setValue:self.txtValidCode.text forKey:@"Code"];
    [p.postArgs setValue:@"1" forKey:@"SmsType"];
    //[p.postArgs setValue:self.txtPassword.text forKey:@"Password"];
    
    [p start:^(SHTask * t) {
        [[NSUserDefaults standardUserDefaults]setValue:[ t.result valueForKey:@"UserType"] forKey:@"UserType"];
        [[NSUserDefaults standardUserDefaults]setValue:t.result forKey:@"User"];
        
        //[t.respinfo show];
        [self dismissWaitDialog];
        if(INVESTOR){//question//
            SHIntent * intent = [[SHIntent alloc]init:@"add_financial" delegate:nil containner:self.navigationController];
            [intent.args setValue:@"YES" forKey:@"reg"];
            [[UIApplication sharedApplication]open:intent];


        }else{
            SHIntent * intent = [[SHIntent alloc]init:@"qualification_examination" delegate:nil containner:self.navigationController];
            [intent.args setValue:@"YES" forKey:@"reg"];
            [[UIApplication sharedApplication]open:intent];


        }
    } taskWillTry:nil taskDidFailed:^(SHTask * t) {
        [t.respinfo show];
        [self dismissWaitDialog];

    }];
    

}

- (IBAction)btnLicenceOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"webview" delegate:nil containner:self.navigationController];
    [i.args setValue:@"http://121.41.75.122:8088/RegisterProtocal.aspx" forKey:@"url"];
    [i.args setValue:@"用户注册协议" forKey:@"title"];
    [[UIApplication sharedApplication]open:i];
}
@end
