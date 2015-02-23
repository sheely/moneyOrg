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
    self.title = @"投资注册";
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
    SHIntent * intent = [[SHIntent alloc]init:@"question" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:intent];
}
@end
