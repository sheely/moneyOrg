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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改状态" target:self action:nil];
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetOrderDetail");
    [p.postArgs setValue:[self.intent.args valueForKey:@"OrderID"] forKey:@"OrderID"];
    [p start:^(SHTask *t) {
//        OrderID”:”订单主键”
//        “OrderCode”:”订单代码”
//        “ProductID”:”产品ID”
//        “ProductCode”:”产品代码”
//        “ProductName”:”产品名称”
//        “AccountantUserID”:”理财师ID（Guid）”
//        “AccountantAccID”:”理财师ID（手机号）”
//        “CustomerUserID”:”客户ID（Guid）”
//        “CustomerAccID”:”客户ID（手机号）
//        “TradeType”:”交易类型”
//        “ApplyNum”:”申请份额”
//        “ApplyMoney”:”申请金额”
//        “Bonuses”:”返佣（理财师使用，计算出已赚取和预计赚取）”
//        “OrderStatus”:”订单状态（10-新生成；20-待审核；30-已审核；40-已完成；90-已撤销）”
        
        self.labLicaiId.text = [t.result valueForKey:@"AccountantAccID"];
        self.labKehuId.text = [t.result valueForKey:@"CustomerAccID"];
        self.labTradeType.text = [t.result valueForKey:@"TradeType"];
        self.labProdId.text= [t.result valueForKey:@"ProductCode"];
        self.labOrderId.text = [t.result valueForKey:@"OrderCode"];
        self.labApplyFene.text = [t.result valueForKey:@"ApplyNum"];
        self.labApplyMoney.text = [t.result valueForKey:@"ApplyMoney"];
        switch ([[t.result valueForKey:@"OrderStatus"] intValue]) {
            case 10:
                self.labTradeState.text = @"新生成";
                
                break;
            case 20:
                self.labTradeState.text = @"待审核";
                
                break;
            case 30:
                self.labTradeState.text = @"已审核";
                
                break;
            case 40:
                self.labTradeState.text = @"已完成";
                
                break;
            case 50:
                self.labTradeState.text = @"已撤销";
                
                break;
                
            default:
                break;
        }

        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [self dismissWaitDialog];
        
    }];
    // Do any additional setup after loading the view from its nib.
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
