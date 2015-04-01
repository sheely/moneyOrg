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
    NSString * OrderFiled;
    NSString * OrderDirect;
    NSString * keyword;
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
    self.navigationItem.titleView = self.searcbar;
    poductType = @"2";
    pdsubtype = @"0";
    SearchType = @"1";
    GroupID = @"";
    OrderDirect = @"1";
    OrderFiled = @"Column1";
    keyword = @"";
    if ([self.intent.args valueForKey:@"group_id"]) {
        GroupID = [self.intent.args valueForKey:@"group_id"];
        SearchType = @"3";
        SHProductAssembleView * view = [[[NSBundle mainBundle]loadNibNamed:@"SHProductAssembleView" owner:nil options:nil]objectAtIndex:0];
        view.labTitle.text = [self.intent.args valueForKey:@"group_name"];
        view.frame = CGRectMake(0, 0, 320, 44);
        self.title = @"组合明细";
        [self.view addSubview:view];
        if(!INVESTOR){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"推荐" target:self action:@selector(btnGroupTuijian:)];
            
        }
    }
    titleview = [[[NSBundle mainBundle]loadNibNamed:@"SHProductTitleView" owner:nil options:nil]objectAtIndex:0];
    [titleview.btnC1 addTarget:self action:@selector(btnC:) forControlEvents:UIControlEventTouchUpInside];
    [titleview.btnC2 addTarget:self action:@selector(btnC:) forControlEvents:UIControlEventTouchUpInside];
    [titleview.btnC3 addTarget:self action:@selector(btnC:) forControlEvents:UIControlEventTouchUpInside];
    [titleview.btnC4 addTarget:self action:@selector(btnC:) forControlEvents:UIControlEventTouchUpInside];
    
    selectButton = self.btnT1;

    // Do any additional setup after loading the view from its nib.
}

- (void)btnC:(UIButton*)b
{
    NSString * sort = @"";
    switch (b.tag) {
        case 0:
            sort = @"Column1";
            
            break;
        case 1:
            sort = @"Column2";

            break;
        case 2:
            sort = @"Column3";

            break;
        case 3:
            sort = @"Column4";

            break;
            
        default:
            break;
    }
    if([OrderFiled isEqualToString:sort]){
        if([OrderDirect isEqualToString:@"1"]){
            OrderDirect = @"0";
        }else{
            OrderDirect = @"1";
        }
    }
    OrderFiled = sort;
    titleview.img1.image = [UIImage imageNamed:@"ic_sort.png"];
    titleview.img2.image = [UIImage imageNamed:@"ic_sort.png"];
    titleview.img3.image = [UIImage imageNamed:@"ic_sort.png"];
    titleview.img4.image = [UIImage imageNamed:@"ic_sort.png"];
    UIImageView * imgView;
    if([OrderFiled isEqualToString:@"Column1"]){
        imgView = titleview.img1;
    }else  if([OrderFiled isEqualToString:@"Column2"]){
        imgView = titleview.img2;
    }else  if([OrderFiled isEqualToString:@"Column3"]){
        imgView = titleview.img3;
    }else  if([OrderFiled isEqualToString:@"Column4"]){
        imgView = titleview.img4;
    }
 
    if([OrderDirect isEqualToString:@"0"]){
        imgView.image = [UIImage imageNamed:@"ic_sort_up.png"];
    }else if ([OrderDirect isEqualToString:@"1"]){
        imgView.image = [UIImage imageNamed:@"ic_sort_down.png"];
    }
    [self reSet];
}
//
//- (void)reSet
//{
//    [self loadNext];
//}

- (void)btnGroupTuijian:(UIButton*) btn
{
    SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
    [i.args setValue:@"3" forKey:@"type"];
    [i.args setValue:GroupID forKey:@"group_id"];
    [i.args setValue:[self.intent.args valueForKey:@"group_name"] forKey:@"group_name"];
    [i.args setValue:@"true" forKey:@"sms"];
    
    
    NSString * msg = [NSString  stringWithFormat:@"理财师【当前理财师姓名%@】正在使用“天天有钱”，他推荐您关注此组合:%@,想查看组合详情并和认证理财师互动,请下载天天有钱app",[[[NSUserDefaults standardUserDefaults] valueForKey:@"User"]valueForKey:@"UserName"],[self.intent.args valueForKey:@"group_name"] ];
    [i.args setValue:msg forKey:@"text"];
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
    int index = mList.count/25 + 1;
    [p.postArgs setValue:[NSString stringWithFormat:@"%d",index ] forKey:@"PageIndex"];
    [p.postArgs setValue:OrderFiled forKey:@"OrderFiled"];
    [p.postArgs setValue:OrderDirect forKey:@"OrderDirect"];
    [p.postArgs setValue:keyword forKey:@"Keyword"];
    
    
    //"UserID": "f1b98876-2222-48da-b295-02dd992b172a",
    //"SessionID": "9054f537-f46c-466a-a1b0-eefd99a6df71",
    [self showWaitDialogForNetWork];
    [p start:^(SHTask * t) {
        NSArray* list = [t.result valueForKey:@"Content"];
        [titleview.btnC1 setTitle:[t.result valueForKey:@"ColumnName1"] forState:UIControlStateNormal];
        [titleview.btnC2 setTitle:[t.result valueForKey:@"ColumnName2"]  forState:UIControlStateNormal];
        [titleview.btnC3 setTitle:[t.result valueForKey:@"ColumnName3"]  forState:UIControlStateNormal];
        [titleview.btnC4 setTitle:[t.result valueForKey:@"ColumnName4"]  forState:UIControlStateNormal];
        if(list.count == 0){
            mIsEnd = YES;
        }else if (list.count < 25){
            mIsEnd = YES;
        }
        if(mList == nil){
            mList = [list mutableCopy];
        }else{
            [mList addObjectsFromArray:list];
        }
        [self.tableView reloadData];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t ) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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

- (CGFloat) tableView:(UITableView *)tableView heightForGeneralRowAtIndexPath:(NSIndexPath *)indexPath
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
    NSString * msg = [NSString  stringWithFormat:@"理财师【当前理财师姓名%@】正在使用“天天有钱”，他推荐您关注此产品：[%@]产品摘要模版[%@:%@],[%@:%@],[%@:%@],[%@:%@],想查看产品详情并和认证理财师互动,请下载天天有钱app",[[[NSUserDefaults standardUserDefaults] valueForKey:@"User"]valueForKey:@"UserName"],[dic valueForKey:@"ProductName"],titleview.btnC1.currentTitle,[dic valueForKey:@"Column1"],titleview.btnC2.currentTitle,[dic valueForKey:@"Column2"],titleview.btnC3.currentTitle,[dic valueForKey:@"Column3"],titleview.btnC4.currentTitle,[dic valueForKey:@"Column4"]];
    [intent.args setValue:msg forKey:@"text"];
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
    mIsEnd = NO;
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



- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    keyword  = @"";
    [searchBar resignFirstResponder ];
    [self reSet];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    keyword  = searchBar.text;
    [self reSet];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;

}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{    searchBar.showsCancelButton = YES;

}
@end
