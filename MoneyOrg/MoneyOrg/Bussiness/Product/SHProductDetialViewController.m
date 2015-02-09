//
//  SHProductDetialViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHProductDetialViewController.h"

@interface SHProductDetialViewController ()

@end

@implementation SHProductDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.intent.args valueForKey:@"id"]){
        self.title = [self.intent.args valueForKey:@"title"];
        [self showWaitDialogForNetWork];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ProductDetail.aspx?ProductID=%@",URL_HEADER_WEB_URL,[self.intent.args valueForKey:@"id"]]]]];
        
    }
      // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissWaitDialog];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self dismissWaitDialog];
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
