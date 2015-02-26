//
//  SHMyAssembleViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/7/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHMyAssembleViewController.h"
#import "SHAssembleViewCell.h"

@interface SHMyAssembleViewController ()

@end

@implementation SHMyAssembleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的组合";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage: [SHSkin.instance image:@"ic_chat"] target:self action:@selector(btnAddAssmeble:)];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= 50;
    self.navigationController.view.frame =rect;
    [self loadNext];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.navigationController.view.frame =rect;
    [super viewWillDisappear:animated];
}
- (void)btnAddAssmeble:(NSObject*)o
{
    SHIntent * intent  = [[SHIntent alloc]init:@"create_assemble" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:intent];
}

- (void)loadNext
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"SearchGroup");
    [p start:^(SHTask *t) {
        mIsEnd = YES;
        mList = t.result;
        [self.tableView reloadData];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [self dismissWaitDialog];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView dequeueReusableStandardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHAssembleViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHAssembleViewCell" owner:nil options:nil] objectAtIndex:0];
    cell.labName.text = [dic valueForKey:@"GroupName"];
    cell.labName.textColor = [SHSkin.instance colorOfStyle:@"ColorTextBlue"];
    cell.labCusNum.text = [[dic valueForKey:@"CustomerNum"] stringValue];
    cell.labCusNum.textColor = [UIColor orangeColor];
    NSNumber *num = [dic valueForKey:@"RiskLevel"];
    cell.labLevel.text = [num stringValue];
    if(num.intValue == 0){
        cell.labLevel.textColor = [UIColor lightGrayColor];
        cell.labLevel.text = @"无";
    }else if (num.intValue == 1){
        cell.labLevel.textColor =  [SHSkin.instance colorOfStyle:@"ColorTextBlue"];
        cell.labLevel.text = @"低";
    }else if (num.intValue == 2){
        cell.labLevel.textColor =  [UIColor orangeColor];
        cell.labLevel.text = @"中";
    }else {
        cell.labLevel.textColor =  [UIColor redColor];
        cell.labLevel.text = @"高";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHIntent * i = [[SHIntent alloc]init:@"product_list" delegate:nil containner:self.navigationController];
    [i.args setValue:[dic valueForKey:@"GroupID"] forKey:@"group_id"];
    [i.args setValue:[dic valueForKey:@"GroupName"] forKey:@"group_name"];
    [[UIApplication sharedApplication]open:i];
}

@end
