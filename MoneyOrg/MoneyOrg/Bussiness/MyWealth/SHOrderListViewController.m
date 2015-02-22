//
//  SHOrderListViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//
#import "SHOrderCell.h"
#import "SHOrderListViewController.h"

@interface SHOrderListViewController ()

@end

@implementation SHOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单列表";
   
    // Do any additional setup after loading the view from its nib.
}

- (void)loadNext
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetOrderList");
    [p.postArgs setValue:@"2000" forKey:@"PageSize"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    [p start:^(SHTask *t) {
        mList = [t.result valueForKey:@"Content" ];
        mIsEnd = YES;
        [self dismissWaitDialog];
        [self.tableView reloadData];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [self dismissWaitDialog];
        
    }];
}

- (UITableViewCell*) tableView:(UITableView *)tableView dequeueReusableStandardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHOrderCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHOrderCell" owner:nil options:nil]objectAtIndex:0];
    cell.labName.text =  [dic valueForKey:@"ProductName"];
    cell.labMoney.text = [NSString stringWithFormat:@"金额:%@",[dic valueForKey:@"ApplyMoney"]];
    cell.labCommission.text = [NSString stringWithFormat:@"反佣:%@",[dic valueForKey:@"Bonuses"]];
    switch ([[dic valueForKey:@"OrderStatus"] intValue]) {
        case 10:
            cell.labState.text = @"新生成";
            
            break;
        case 20:
            cell.labState.text = @"待审核";
            
            break;
        case 30:
            cell.labState.text = @"已审核";
            
            break;
        case 40:
            cell.labState.text = @"已完成";
            
            break;
        case 50:
            cell.labState.text = @"已撤销";
            
            break;
            
        default:
            break;
    }
    //“OrderStatus”:”订单状态（10-新生成；20-待审核；30-已审核；40-已完成；90-已撤销
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForGeneralRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHIntent * i = [[SHIntent alloc]init:@"order_detail" delegate:nil containner:self.navigationController];
    [i.args setValue:[dic valueForKey:@"OrderID"] forKey:@"OrderID"];
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
