//
//  MyCustomerListViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/9/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "MyCustomerListViewController.h"
#import "SHMyCustomerCell.h"
#import <MessageUI/MessageUI.h>

@interface MyCustomerListViewController ()
{
    NSString * type ;
    BOOL sms ;
    NSMutableArray * mListSelecteds;
}
@end

@implementation MyCustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mListSelecteds = [[NSMutableArray alloc]init];
    type = @"1";
    if([self.intent.args valueForKey:@"type"]){
        type = [self.intent.args valueForKey:@"type"];
    }
    if([self.intent.args valueForKey:@"sms"]){
        sms = YES;
    }
    if([type caseInsensitiveCompare:@"1"] == NSOrderedSame){
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage: [SHSkin.instance image:@"ic_chat"] target:self action:@selector(btnAddAssmeble:)];
        self.title = @"我的客户";
    }else if ([type caseInsensitiveCompare:@"2"] == NSOrderedSame){
        self.title = [self.intent.args valueForKey:@"product_name"];
        if(sms){
            self.title = [NSString stringWithFormat:@"%@-短信推荐",self.title];
        }
        
    }else if ([type caseInsensitiveCompare:@"3"] == NSOrderedSame){
        self.title = @"组合匹配客户";
    }
    if (sms) {
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage: [SHSkin.instance image:@"ic_ok"] target:self action:@selector(btnSendSMS:)];
    }
   
    // Do any additional setup after loading the view from its nib.
}

- (void)btnSendSMS:(UIButton*)b{
    [self sendmsg];
}

- (void)btnAddAssmeble:(NSObject *)s
{
    SHIntent * i = [[SHIntent alloc]init:@"customer_add" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:i];
}


- (void)loadNext
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"SearchCustomerList");
    [p.postArgs setValue:@"2500" forKey:@"PageSize"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    if([type caseInsensitiveCompare:@"1"] == NSOrderedSame){
    }else if ([type caseInsensitiveCompare:@"2" ] == NSOrderedSame){
        [p.postArgs setValue:[self.intent.args valueForKey:@"product_id"] forKey:@"ProductID"];
    }else if ([type caseInsensitiveCompare:@"3"] == NSOrderedSame){
        [p.postArgs setValue:[self.intent.args valueForKey:@"group_id"] forKey:@"GroupID"];
    }
    [p.postArgs setValue:type forKey:@"SearchType"];
    [p start:^(SHTask *t) {
        mList = [t.result mutableCopy];
        mIsEnd = YES;
        [self.tableView reloadData];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        mIsEnd = YES;
        [self.tableView reloadData];
        [self dismissWaitDialog];
    }];
    //"UserID": "f1b98876-2222-48da-b295-02dd992b172a",
    //"SessionID": "9054f537-f46c-466a-a1b0-eefd99a6df71",
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float) tableView:(UITableView *)tableView heightForGeneralRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell*) tableView:(UITableView *)tableView dequeueReusableStandardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHMyCustomerCell * cell =  [[[NSBundle mainBundle]loadNibNamed:@"SHMyCustomerCell" owner:nil options:nil]objectAtIndex:0];
    [cell.imgView setUrl: [dic valueForKey:@"UserVPhoto"]];
    cell.labTitle.text = [dic valueForKey:@"UserName"];
    cell.labContent.text = [dic valueForKey:@"UserCode"];
    if([type caseInsensitiveCompare:@"1"] == NSOrderedSame){
        cell.btnDelete.hidden = YES;
    }else if([type caseInsensitiveCompare:@"2"] == NSOrderedSame){
        if(sms){
            cell.switch_sms.hidden = NO;
            cell.switch_sms.tag = indexPath.row;
            [cell.switch_sms addTarget:self action:@selector(switch_sms:) forControlEvents:UIControlEventValueChanged];
        }else{
            cell.btnOrder.hidden = NO;
            cell.btnOrder.tag = indexPath.row;
            [cell.btnOrder addTarget:self action:@selector(btnOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
       
    }else if([type caseInsensitiveCompare:@"3"] == NSOrderedSame){
        if(sms){
            cell.switch_sms.hidden = NO;
            cell.switch_sms.tag = indexPath.row;
            [cell.switch_sms addTarget:self action:@selector(switch_sms:) forControlEvents:UIControlEventValueChanged];

        }else{
            cell.btnDelete.hidden = YES;
        }
    }
    return cell;
}

- (void)switch_sms:(UISwitch*)b
{
    NSDictionary * dic = [mList objectAtIndex:b.tag];
    NSString * phone = [dic valueForKey:@"UserName"];
    if([phone length] > 0){
        if(b.on){
            [mListSelecteds addObject:phone];
        }else {
            [mListSelecteds removeObject:phone];
        }
    }

}

- (void)btnOrder:(UIButton*)b
{
    NSDictionary * dic = [mList objectAtIndex:b.tag];
    SHIntent * i = [[SHIntent alloc]init:@"order_create" delegate:nil containner:self.navigationController];
    [i.args setValue: dic forKey:@"user"];
    [i.args setValue: [self.intent.args valueForKey:@"product_name"] forKey:@"product_name"];
    [i.args setValue: [self.intent.args valueForKey:@"product_id"] forKey:@"product_id"];

    [[UIApplication sharedApplication]open:i];
}
- (void)sendmsg
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        
        if(mListSelecteds.count ==0){
            [self showAlertDialog:@"需要选择投资者"];
            return;
        }
        SHPostTaskM * post = [[SHPostTaskM alloc ]init ];
        post.URL = URL_FOR(@"RecommendProduct");
        if ([type caseInsensitiveCompare:@"2"] == NSOrderedSame){
            [post.postArgs setValue:@"1" forKey:@"RecommendType"];
            [post.postArgs setValue:[self.intent.args valueForKey:@"product_id"] forKey:@"RecommendObjPKID"];
 
        }else{
            [post.postArgs setValue:@"2" forKey:@"RecommendType"];
            [post.postArgs setValue:[self.intent.args valueForKey:@"group_id"] forKey:@"RecommendObjPKID"];

        }
        NSMutableString * msgstr = [[NSMutableString alloc]init];
        for (NSString *phone in mListSelecteds) {
            [msgstr appendFormat:@"%@,",phone];
            
        }
        [post.postArgs setValue:msgstr forKey:@"InvestorIDs"];
        [post start:^(SHTask * t) {
            
        } taskWillTry:nil taskDidFailed:^(SHTask *t) {
            
        }];
        
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            [self showAlertDialog:@"设备没有短信功能"];
        }
    }
    else {
        
        [self showAlertDialog:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = mListSelecteds;
    //    NSMutableString* absUrl = [[NSMutableString alloc] initWithString:web.request.URL.absoluteString];
    //    [absUrl replaceOccurrencesOfString:@"http://i.aizheke.com" withString:@"http://m.aizheke.com"
    //                               options:NSCaseInsensitiveSearch range:NSMakeRange(0, [absUrl length])];
    //
    //    picker.body=[NSString stringWithFormat:@"我在爱折客上看到：%@ 可能对你有用，推荐给你！link：%@"
    //                 ,[web stringByEvaluatingJavaScriptFromString:@"document.title"]
    //                 ,absUrl];
    picker.body= @"欢迎使用财富导航";
    [self showWaitDialog:@"请稍候" state:@"正在启动"];
    [self presentViewController:picker animated:YES completion:^{
        [self dismissWaitDialog];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            //LOG_EXPR(@"Result: SMS sending canceled");
            
        case MessageComposeResultSent:
            //LOG_EXPR(@"Result: SMS sent");
        {
            
            
        }
            break;
        case MessageComposeResultFailed:
            [ self showAlertDialog:@"短信发送失败"];
            break;
        default:
            //LOG_EXPR(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(mList.count == 0){
        return;
    }
    SHIntent * intent = [[SHIntent alloc]init:@"user_detail" delegate:nil containner:self.navigationController];
    [intent.args setValue:[mList objectAtIndex:indexPath.row] forKey:@"user_info"];
    [[UIApplication sharedApplication]open:intent];
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
