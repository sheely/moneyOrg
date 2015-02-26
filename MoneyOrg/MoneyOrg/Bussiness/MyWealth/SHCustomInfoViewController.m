//
//  SHCustomInfoViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/25/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHCustomInfoViewController.h"
#import "SHCustonInfoDetailCell.h"

@interface SHCustomInfoViewController ()

{
    NSDictionary * dic ;
}
@end

@implementation SHCustomInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详情";
    dic = [self.intent.args valueForKey:@"user_info"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHCustonInfoDetailCell * cell  = [[[NSBundle mainBundle]loadNibNamed:@"SHCustonInfoDetailCell" owner:nil options:nil] objectAtIndex:0];
    switch (indexPath.row) {
        case 0:
            cell.labTitle.text = @"姓名";
            cell.labContent.text  = [dic valueForKey:@"UserName"] ;
            break;
        case 1:
            cell.labTitle.text = @"年龄";
            cell.labContent.text  = [[dic valueForKey:@"UserAge"] description] ;
            break;
        case 2:
            cell.labTitle.text = @"家庭年收入";
            cell.labContent.text  = [[dic valueForKey:@"FamilyIncome"] description] ;
            break;
        case 3:
            cell.labTitle.text = @"可用于投资理财的金额";
            cell.labContent.text  = [[dic valueForKey:@"InvestmentMoney"] description] ;
            break;
        case 4:
            cell.labTitle.text = @"期望回收的周期";
            cell.labContent.text  = [[dic valueForKey:@"RecoveryCycle"] description] ;
            break;
        case 5:
            cell.labTitle.text = @"可承受的风险波动";
            cell.labContent.text  = [[dic valueForKey:@"RiskBearing"] description] ;
            break;
        case 6:
            cell.labTitle.text = @"期望收益";
            cell.labContent.text  = [[dic valueForKey:@"ExpectedProfit"] description] ;
            break;
        case 7:
            cell.labTitle.text = @"投资风格";
            cell.labContent.text  = [[dic valueForKey:@"InvestmentType"] description] ;
            break;

        default:
            break;
    }
    return cell;
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
