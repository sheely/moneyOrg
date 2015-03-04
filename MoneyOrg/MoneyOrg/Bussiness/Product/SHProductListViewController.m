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
- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= 50;
    self.navigationController.view.frame =rect;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.navigationController.view.frame =rect;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品列表";
    poductType = @"1";
    pdsubtype = @"0";
    SearchType = @"1";
    GroupID = @"";
    if ([self.intent.args valueForKey:@"group_id"]) {
        GroupID = [self.intent.args valueForKey:@"group_id"];
        SearchType = @"3";
        SHProductAssembleView * view = [[[NSBundle mainBundle]loadNibNamed:@"SHProductAssembleView" owner:nil options:nil]objectAtIndex:0];
        view.labTitle.text = [self.intent.args valueForKey:@"group_name"];
        view.frame = CGRectMake(0, 0, 320, 44);
        self.title = @"组合明细";
        [self.view addSubview:view];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"推荐" target:self action:@selector(btnGroupTuijian:)];
    }
    titleview = [[[NSBundle mainBundle]loadNibNamed:@"SHProductTitleView" owner:nil options:nil]objectAtIndex:0];
    selectButton = self.btnT1;

    // Do any additional setup after loading the view from its nib.
}

- (void)btnGroupTuijian:(UIButton*) btn
{
    SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
    [i.args setValue:@"3" forKey:@"type"];
    [i.args setValue:GroupID forKey:@"group_id"];
    [i.args setValue:[self.intent.args valueForKey:@"group_name"] forKey:@"group_name"];
    [i.args setValue:@"true" forKey:@"sms"];
    [[UIApplication sharedApplication]open:i];
}

- (void)loginSuc
{
    [self loadNext];
}

- (void)loadNext
{
    if ([SHEntironment.instance.loginName length] == 0) {
        return;
    }
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetProductList");
    [p.postArgs setValue:SearchType forKey:@"SearchType"];
    [p.postArgs setValue:poductType forKey:@"ProductType"];
    [p.postArgs setValue:pdsubtype forKey:@"ProductSubType"];
    [p.postArgs setValue:GroupID forKey:@"GroupID"];
    [p.postArgs setValue:@"25" forKey:@"PageSize"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    [p.postArgs setValue:@"Column1" forKey:@"OrderFiled"];
    [p.postArgs setValue:@"0" forKey:@"OrderDirect"];
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
        [t.respinfo show];
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
    [cell alternate:indexPath];
    
    if([[[dic valueForKey:@"ProductType"] description] caseInsensitiveCompare:@"1"]== NSOrderedSame){
        cell.btnOrder.hidden = YES;
    }else{
        cell.btnOrder.tag = indexPath.row;
        [cell.btnOrder addTarget:self action:@selector(btnOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(INVESTOR){
        cell.labCusNum.hidden = YES;
        cell.imgCusNum.hidden = YES;
    }
    return cell;
}

- (void)btnOrder:(UIButton *)b
{        NSDictionary * dic = [mList objectAtIndex:b.tag];

    if(INVESTOR){
        SHIntent * i = [[SHIntent alloc]init:@"order_create" delegate:nil containner:self.navigationController];
        [i.args setValue:  [[NSUserDefaults standardUserDefaults]valueForKey:@"User"] forKey:@"user"];
        [i.args setValue: [dic valueForKey:@"ShortProductName"]forKey:@"product_name"];
        [i.args setValue: [dic valueForKey:@"ProductID"] forKey:@"product_id"];
        
        [[UIApplication sharedApplication]open:i];
        
    }else{
        
        SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
        [i.args setValue:@"2" forKey:@"type"];
        [i.args setValue:[dic valueForKey:@"ProductID"] forKey:@"product_id"];
        [i.args setValue:[dic valueForKey:@"ShortProductName"] forKey:@"product_name"];
        [[UIApplication sharedApplication]open:i];
    }
}

- (float) tableView:(UITableView *)tableView heightForGeneralRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(mList.count == 0){
        return ;
    }
    NSDictionary * dic = [mList objectAtIndex:indexPath.row];
    SHIntent * intent = [[SHIntent alloc]init:@"prod_detail" delegate:nil containner:self.navigationController];
    [intent.args setValue:dic forKey:@"dic"];
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
    
    
    NSArray * array = @[ [KxMenuItem menuItem:@"股票基金" image:nil target:self action:@selector(kxm0:)],
                          [KxMenuItem menuItem:@"债券基金" image:nil target:self action:@selector(kxm1:)],
                          [KxMenuItem menuItem:@"货币基金" image:nil target:self action:@selector(kxm2:)],
                          [KxMenuItem menuItem:@"混合基金" image:nil target:self action:@selector(kxm3:)],
                          [KxMenuItem menuItem:@"其它基金" image:nil target:self action:@selector(kxm4:)]];
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:array];
    
}
- (void)kxm0:(KxMenuItem*)sender
{
    
    selectButton.selected = NO;
    selectButton = self.btnT1;
    self.btnT1.selected = YES;
    poductType = @"1";
    pdsubtype = @"0";
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateNormal];
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateSelected];

    [self reSet];
    
}
- (void)kxm4:(KxMenuItem*)sender
{
    
    selectButton.selected = NO;
    selectButton = self.btnT1;
    self.btnT1.selected = YES;
    poductType = @"1";
    pdsubtype = @"4";
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateNormal];
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateSelected];

    [self reSet];
    
}
- (void)kxm3:(KxMenuItem*)sender
{
    
    selectButton.selected = NO;
    selectButton = self.btnT1;
    self.btnT1.selected = YES;
    poductType = @"1";
    pdsubtype = @"3";
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateNormal];
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateSelected];

    [self reSet];
    
}
- (void)kxm2:(KxMenuItem*)sender
{
    
    selectButton.selected = NO;
    selectButton = self.btnT1;
    self.btnT1.selected = YES;
    poductType = @"1";
    pdsubtype = @"2";
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateNormal];
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateSelected];

    [self reSet];
    
}

- (void)kxm1:(KxMenuItem*)sender
{
    
    selectButton.selected = NO;
    selectButton = self.btnT1;
    self.btnT1.selected = YES;
    poductType = @"1";
    pdsubtype = @"1";
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateNormal];
    [self.btnT1 setTitle:sender.title forState:(UIControlState)UIControlStateSelected];

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
