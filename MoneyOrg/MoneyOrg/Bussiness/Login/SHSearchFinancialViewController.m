//
//  SHSearchFinancialViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHSearchFinancialViewController.h"
#import "SHMyCustomerCell.h"

@interface SHSearchFinancialViewController ()

@end

@implementation SHSearchFinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找理财师";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNext
{
    SHPostTaskM * p =[[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"SearchAccountant");
    [p.postArgs setValue:[self.intent.args valueForKey:@"UserCode"] forKey:@"UserCode"];
    [p.postArgs setValue:[self.intent.args valueForKey:@"Mobile"]  forKey:@"Mobile"];
    [p.postArgs setValue:[self.intent.args valueForKey:@"Speciality"]  forKey:@"Speciality"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    [p.postArgs setValue:@"200" forKey:@"PageSize"];
    [p start:^(SHTask * t ) {
        mIsEnd = YES;
        mList = t.result;
        [self.tableView reloadData];
    } taskWillTry:nil taskDidFailed:^(SHTask * t) {
        
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    cell.btnAdd.hidden = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.btnAdd.tag = indexPath.row;
    [cell.btnAdd addTarget:self action:@selector(btnAdd:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) btnAdd:(UIButton*)b
{
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"AddAccountant");
    [p.postArgs setValue:[[mList objectAtIndex:b.tag] valueForKey:@"AccountID"] forKey:@"AccountantAccIds"];
    [p start:^(SHTask * t) {
        SHIntent * i = [[SHIntent alloc]init:@"question" delegate:nil containner:self.navigationController];
        [[UIApplication sharedApplication]open:i];
    } taskWillTry:nil taskDidFailed:^(SHTask * t) {
        [t.respinfo show];
    }];
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
