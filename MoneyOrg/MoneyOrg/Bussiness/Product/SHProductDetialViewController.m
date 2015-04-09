//
//  SHProductDetialViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHProductDetialViewController.h"

@interface SHProductDetialViewController ()
{
    NSMutableDictionary * dic;
}
@end

@implementation SHProductDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.intent.args valueForKey:@"id"]){
        self.title = [self.intent.args valueForKey:@"title"];
        [self showWaitDialogForNetWork];
        SHPostTaskM * post = [[SHPostTaskM alloc]init];
        post.URL = URL_FOR(@"GetProductDetail");
        [post.postArgs setValue:[self.intent.args valueForKey:@"id"] forKey:@"ProductID"];
        [post.postArgs setValue: @"" forKey:@"ProductCode"];
        [post start:^(SHTask * t) {
            dic = [t.result mutableCopy];
            self.labCustomer.text = [[dic valueForKey:@"CustomerNum"] description];
            if([[dic valueForKey:@"HasCollect"] boolValue]){
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_collection_sel"] target:self action:@selector(btnCollect:)];
            }else{
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_collection_nom"] target:self action:@selector(btnCollect:)];
            }
        } taskWillTry:nil taskDidFailed:^(SHTask * t) {
            
        }];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ProductDetail.aspx?ProductID=%@&AccountID=%@",URL_HEADER_WEB_URL,[self.intent.args valueForKey:@"id"],  [[[NSUserDefaults standardUserDefaults]valueForKey :@"User"] valueForKey:@"AccountID"] ]]]];
        
        self.labCustomer.text = [[ [self.intent.args valueForKey:@"dic" ]valueForKey:@"CustomerNum"] description];
    }
    
    //if (USER_TYPE == 1)
    
    if(!INVESTOR){
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    }
// Do any additional setup after loading the view from its nib.
}

- (void)btnCollect:(UIButton*)b
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"CollectProduct");
    [p.postArgs setValue:[self.intent.args valueForKey:@"id"] forKey:@"ProductID"];

    if([[dic valueForKey:@"HasCollect"] boolValue]){
        [p.postArgs setValue:@"2" forKey:@"OpType"];
    }else{
        [p.postArgs setValue:@"1" forKey:@"OpType"];
    }
    [p start:^(SHTask *t) {
        [dic setValue:[NSNumber numberWithBool:![[dic valueForKey:@"HasCollect"] boolValue]] forKey:@"HasCollect"];
        if([[dic valueForKey:@"HasCollect"] boolValue]){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_collection_sel"] target:self action:@selector(btnCollect:)];
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_collection_nom"] target:self action:@selector(btnCollect:)];
        }
        [self dismissWaitDialog];
        [t.respinfo show];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];
   }

- (void)loadSkin
{
    [super loadSkin];
    self.btnShare.layer.cornerRadius = 5;
    self.btnTuijian.layer.cornerRadius = 5;
    self.btnOrder.layer.cornerRadius = 5;
    self.btnDoc.layer.cornerRadius = 5;
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
    id<ISSContent> publishContent = [ShareSDK content:[self.intent.args valueForKey:@"text"]
                                       defaultContent:@"我的分享"
                                                image:nil
                                                title:@"我的分享"
                                                  url:[NSString stringWithFormat:@"%@/ProductDetail.aspx?ProductID=%@",URL_HEADER_WEB_URL,[self.intent.args valueForKey:@"id"] ]
                                          description:[self.intent.args valueForKey:@"text"]
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
    [i.args setValue:[self.intent.args valueForKey:@"text"] forKey:@"text"];
    [i.args setValue:@"true" forKey:@"sms"];
    [[UIApplication sharedApplication]open:i];

}

- (IBAction)btnOrderOnTouch:(id)sender {
    
    if(INVESTOR){
        SHIntent * i = [[SHIntent alloc]init:@"order_create" delegate:nil containner:self.navigationController];
        [i.args setValue:  [[NSUserDefaults standardUserDefaults]valueForKey:@"User"] forKey:@"user"];
        [i.args setValue: [dic valueForKey:@"ProductName"]forKey:@"product_name"];
        [i.args setValue: [self.intent.args valueForKey:@"id"] forKey:@"product_id"];
        
        [[UIApplication sharedApplication]open:i];
        
    }else{
        
        SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
        [i.args setValue:@"2" forKey:@"type"];
        [i.args setValue:[self.intent.args valueForKey:@"id"] forKey:@"product_id"];
        [i.args setValue:[dic valueForKey:@"ProductName"] forKey:@"product_name"];
        [[UIApplication sharedApplication]open:i];
    }

}

- (IBAction)btnDocOnTouch:(id)sender {
    if([[dic valueForKey:@"PublishPlanUrl"] length]> 0){
        SHIntent * i = [[SHIntent alloc]init:@"webview" delegate:nil containner:self.navigationController];
        [i.args setValue:[dic valueForKey:@"PublishPlanUrl"] forKey:@"url"];
        [i.args setValue:@"发型方案" forKey:@"title"];
        [[UIApplication sharedApplication]open:i];
    }else{
        [self showAlertDialog:@"暂无发型方案"];
    }
}
@end
