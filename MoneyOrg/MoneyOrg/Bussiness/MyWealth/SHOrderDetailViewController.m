//
//  SHOrderDetailViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/2/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHOrderDetailViewController.h"

@interface SHOrderDetailViewController ()

@end

@implementation SHOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"order_state_changed" object:nil];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}


- (void)loadData
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetOrderDetail");
    [p.postArgs setValue:[self.intent.args valueForKey:@"OrderID"] forKey:@"OrderID"];
    [p.postArgs setValue:@"" forKey:@"OrderCode"];
    [p start:^(SHTask *t) {
        
        self.labLicaiId.text = [t.result valueForKey:@"AccountantAccID"];
        self.labKehuId.text = [t.result valueForKey:@"CustomerAccID"];
        self.labTradeType.text = [t.result valueForKey:@"TradeType"];
        self.labProdId.text= [t.result valueForKey:@"ProductCode"];
        self.labOrderId.text = [t.result valueForKey:@"OrderCode"];
        self.labApplyFene.text = [t.result valueForKey:@"ApplyNum"];
        self.labApplyMoney.text = [t.result valueForKey:@"ApplyMoney"];
        self.labOrderTime.text = [t.result valueForKey:@"CreateTime"];
        switch ([[t.result valueForKey:@"OrderStatus"] intValue]) {
            case 10:
            {
                self.labTradeState.text = @"已提交";
                
                if(!INVESTOR){
                    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
                                                               [[UIBarButtonItem alloc]initWithTitle:@"撤销" target:self action:@selector(btnCancel:)],
                                                               
                                                               [[UIBarButtonItem alloc]initWithTitle:@"合同" target:self action:@selector(btnAgreement:)],nil];
                }
            }
            break;
            case 20:
            {
                self.labTradeState.text = @"待审核";
                self.navigationItem.rightBarButtonItems  = nil;
            }
                break;
            case 30:
                self.labTradeState.text = @"待结算";
                
                break;
            case 40:
                self.labTradeState.text = @"已完成";
                
                break;
            case 50:
                self.labTradeState.text = @"已驳回";
                
                break;
            case 90:
                self.labTradeState.text = @"已撤销";
                
                break;

                
            default:
                break;
        }
        
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [self dismissWaitDialog];
        
    }];
}
- (void)btnCancel:(UIButton*)b
{
    UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认撤销订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤销", nil];
    [a show];

   

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        SHPostTaskM * post = [[SHPostTaskM alloc]init];
        post.URL = URL_FOR(@"ChangeOrderStatus");
        [post.postArgs setValue:@"90" forKey:@"TargetOrderStatus"];
        [post.postArgs setValue:@"" forKey:@"ContractPhoto"];
        [post.postArgs setValue:[self.intent.args valueForKey:@"OrderID"] forKey:@"OrderID"];
        [post start:^(SHTask * t) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"order_state_changed" object:nil];
        } taskWillTry:nil taskDidFailed:^(SHTask * t) {
            [t.respinfo show];
        }];
    }
}

- (void)btnAgreement:(UIButton*)b
{
    SHIntent * i = [[SHIntent alloc]init:@"agreement" delegate:nil containner:self.navigationController];
    [i.args setValue:[self.intent.args valueForKey:@"OrderID"] forKey:@"OrderID"];

    [[UIApplication sharedApplication]open:i];
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
