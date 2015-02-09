//
//  SHProductListViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 1/26/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHProductListViewController.h"
#import "SHProductCell.h"
#import "SHProductTitleView.h"
#import "SHProductAssembleView.h"

@interface SHProductListViewController ()
{
    SHProductTitleView * titleview;
    NSString * poductType ;
    NSString * pdsubtype;
    UIButton * selectButton;
    NSString * SearchType;
    NSString * GroupID;
}
@end

@implementation SHProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品列表";
    poductType = @"1";
    pdsubtype = @"1";
    SearchType = @"1";
    GroupID = @"";
    if ([self.intent.args valueForKey:@"group_id"]) {
        GroupID = [self.intent.args valueForKey:@"group_id"];
        SearchType = @"3";
        SHProductAssembleView * view = [[[NSBundle mainBundle]loadNibNamed:@"SHProductAssembleView" owner:nil options:nil]objectAtIndex:0];
        view.labTitle.text = [self.intent.args valueForKey:@"group_name"];
        view.frame = CGRectMake(0, 0, 320, 44);
        [self.view addSubview:view];
    }
    titleview = [[[NSBundle mainBundle]loadNibNamed:@"SHProductTitleView" owner:nil options:nil]objectAtIndex:0];
    selectButton = self.btnT1;
    [self performSelector:@selector(loginSuc) afterNotification:@"notification_login_successful"];

    // Do any additional setup after loading the view from its nib.
}

- (void)loginSuc
{
    [self loadNext];
}

- (void)loadNext
{
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetProductList");
    [p.postArgs setValue:SearchType forKey:@"SearchType"];
    [p.postArgs setValue:poductType forKey:@"ProductType"];
    [p.postArgs setValue:pdsubtype forKey:@"ProductSubType"];
    [p.postArgs setValue:GroupID forKey:@"GroupID"];
    [p.postArgs setValue:@"25" forKey:@"PageSize"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    [p.postArgs setValue:@"Column1" forKey:@"OrderFiled"];
    [p.postArgs setValue:@"1" forKey:@"OrderDirect"];
    //"UserID": "f1b98876-2222-48da-b295-02dd992b172a",
    //"SessionID": "9054f537-f46c-466a-a1b0-eefd99a6df71",
    [self showWaitDialogForNetWork];
    [p start:^(SHTask * t) {
        mList = [t.result valueForKey:@"Content"];
        [titleview.btnC1 setTitle:[t.result valueForKey:@"ColumnName1"] forState:UIControlStateNormal];
        [titleview.btnC2 setTitle:[t.result valueForKey:@"ColumnName2"]  forState:UIControlStateNormal];
        [titleview.btnC3 setTitle:[t.result valueForKey:@"ColumnName3"]  forState:UIControlStateNormal];
        [titleview.btnC4 setTitle:[t.result valueForKey:@"ColumnName4"]  forState:UIControlStateNormal];
        mIsEnd = YES;
        [self.tableView reloadData];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t ) {
        //[t.respinfo show];
        [self dismissWaitDialog];
    }];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return titleview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*) tableView:(UITableView *)tableView dequeueReusableStandardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [mList objectAtIndex:indexPath.row];
    SHProductCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHProductCell" owner:nil options:nil] objectAtIndex:0];
    cell.labC1.text = [dic valueForKey:@"Column1"];
    cell.labC2.text = [dic valueForKey:@"Column2"];
    cell.labC3.text = [dic valueForKey:@"Column3"];
    cell.labC4.text = [dic valueForKey:@"Column4"];
    cell.labNum.text = [dic valueForKey:@"ProductCode"];
    cell.labName.text = [dic valueForKey:@"ShortProductName"];
    cell.labCusNum.text = [[dic valueForKey:@"CustomerNum"] stringValue];

    return cell;
}

- (float) tableView:(UITableView *)tableView heightForGeneralRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHIntent * intent = [[SHIntent alloc]init:@"prod_detail" delegate:nil containner:self.navigationController];
    [intent.args setValue:[dic valueForKey:@"ProductID"] forKey:@"id"];
    [intent.args setValue:[dic valueForKey:@"ProductName"] forKey:@"title"];
    [[UIApplication sharedApplication]open:intent];
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)reSet
{
    [mList removeAllObjects];
    [self loadNext];
}

- (IBAction)btnT1OnTouch:(UIButton*)sender {
    
    
    NSArray * array = @[ [KxMenuItem menuItem:@"货币基金" image:nil target:self action:@selector(btn1ArrayOnTouch:)],
                          [KxMenuItem menuItem:@"股票基金" image:nil target:self action:@selector(btn1ArrayOnTouch:)],
                          [KxMenuItem menuItem:@"混合基金" image:nil target:self action:@selector(btn1ArrayOnTouch:)],
                          [KxMenuItem menuItem:@"债券基金" image:nil target:self action:@selector(btn1ArrayOnTouch:)],
                          [KxMenuItem menuItem:@"其它" image:nil target:self action:@selector(btn1ArrayOnTouch:)]];
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:array];
}

- (void)btn1ArrayOnTouch:(KxMenuItem*)sender
{
    
    selectButton.selected = NO;
    selectButton = self.btnT1;
    self.btnT1.selected = YES;
    poductType = @"1";
    [self reSet];

}

- (IBAction)btnT2OnTouch:(UIButton*)sender {
    selectButton.selected = NO;
    selectButton = sender;
    sender.selected = YES;
    poductType = @"2";
    [self reSet];
}

- (IBAction)btnT3OnTouch:(UIButton*)sender {
    selectButton.selected = NO;
    selectButton = sender;
    sender.selected = YES;
    poductType = @"3";
    [self reSet];
}

- (IBAction)btnT4OnTouch:(UIButton*)sender {
    selectButton.selected = NO;
    selectButton = sender;
    sender.selected = YES;
    poductType = @"4";
    [self reSet];
}
@end
