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

- (void)loadSkin
{
    [super loadSkin];
    self.btnShare.layer.cornerRadius = 5;
    self.btnTuijian.layer.cornerRadius = 5;
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

- (IBAction)btnShareOnTouch:(id)sender {
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:nil
                                                title:@"TEST"
                                                  url:@"TEST"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (IBAction)btnTuijianOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
    [i.args setValue:@"2" forKey:@"type"];
    [i.args setValue:[self.intent.args valueForKey:@"id"] forKey:@"product_id"];
    [i.args setValue:[self.intent.args valueForKey:@"title"] forKey:@"product_name"];
    [i.args setValue:@"true" forKey:@"sms"];
    [[UIApplication sharedApplication]open:i];

}
@end
