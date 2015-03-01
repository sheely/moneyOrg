//
//  SHCreateAssembleViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/7/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHCreateAssembleViewController.h"
#import "SHProductCell.h"
#import "SHProductTitleView.h"

@interface SHCreateAssembleViewController ()

{
    SHProductTitleView* titleview;
    NSString* ProductType;
    NSString * RiskLevel ;
    UIButton *btnSelected;
    UIButton *btnShareSelected;

    __weak IBOutlet UITextField *txtField;
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn2;
    __weak IBOutlet UIButton *btn3;
    __weak IBOutlet UIButton *btn4;
    __weak IBOutlet UIButton *btnShare1;
    __weak IBOutlet UIButton *btnShare2;
    __weak IBOutlet UIButton *btnShare3;
    __weak IBOutlet UIButton *btnShare4;
}
@end

@implementation SHCreateAssembleViewController
- (IBAction)btnShare1OnTouch:(UIButton*)sender {
    RiskLevel  = @"1";
    sender.selected = YES;
    btnShareSelected.selected = NO;
    btnShareSelected = sender;
    [self loadNext];
}

- (IBAction)btnShare2OnTouch:(UIButton*)sender {
    RiskLevel  = @"2";
    sender.selected = YES;
    btnShareSelected.selected = NO;
    btnShareSelected = sender;
    [self loadNext];

}
- (IBAction)btnShare3OnTouch:(UIButton*)sender {
    RiskLevel  = @"3";
    sender.selected = YES;
    btnShareSelected.selected = NO;
    btnShareSelected = sender;
    [self loadNext];

}
- (IBAction)btnShare4OnTouch:(UIButton*)sender {
    RiskLevel  = @"4";
    sender.selected = YES;
    btnShareSelected.selected = NO;
    btnShareSelected = sender;
    [self loadNext];

}

- (IBAction)btn4OnTouch:(UIButton*)sender {
    ProductType  = @"4";
    sender.selected = YES;
    btnSelected.selected = NO;
    btnSelected = sender;
    [self loadNext];

}
- (IBAction)btn3OnTouch:(UIButton*)sender {
    ProductType  = @"3";
    sender.selected = YES;
    btnSelected.selected = NO;
    btnSelected = sender;
    [self loadNext];

}
- (IBAction)btn1onTouch:(UIButton*)sender {
    ProductType  = @"1";
    sender.selected = YES;
    btnSelected.selected = NO;
    btnSelected = sender;
    [self loadNext];

}
- (IBAction)btn2OnTouch:(UIButton*)sender {
    ProductType  = @"2";
    sender.selected = YES;
    btnSelected.selected = NO;
    btnSelected = sender;
    [self loadNext];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组合详情";
    self.autoKeyboard = YES;
    btnSelected = btn1;
    btnShareSelected = btnShare1;
    ProductType = @"1";
    RiskLevel = @"1";
    titleview = [[[NSBundle mainBundle]loadNibNamed:@"SHProductTitleView" owner:nil options:nil]objectAtIndex:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[SHSkin.instance image:@"ic_ok"] target:self action:@selector(btnSubmit:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)btnSubmit:(NSObject*)o
{
    SHPostTaskM * post = [[SHPostTaskM alloc]init ];
    post.URL = URL_FOR(@"OperateGroup");
    [post.postArgs setValue:@"" forKey:@"GroupID"];
    [post.postArgs setValue:txtField.text forKey:@"GroupName"];
    [post.postArgs setValue:ProductType forKey:@"ProductType"];
    [post.postArgs setValue:RiskLevel forKey:@"RiskLevel"];
    NSMutableArray * dicP = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in mList) {
        NSMutableDictionary * m = [[NSMutableDictionary alloc]init];
        [m setValue:[dic valueForKey:@"ProductID"] forKey:@"ProductID"];
        [m setValue:@"0" forKey:@"ProductRate"];
        [dicP addObject:m];
    }
    [post.postArgs setValue:dicP forKey:@"Products"];
    
 [post start:^(SHTask *t) {
     
     [t.respinfo show];
 } taskWillTry:nil taskDidFailed:^(SHTask *t) {
     [t.respinfo show];

 }];
}

- (void)loadNext
{
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetProductList");
    [p.postArgs setValue:@"4" forKey:@"SearchType"];
    [p.postArgs setValue:RiskLevel forKey:@"RiskLevel"];
    [p.postArgs setValue:ProductType forKey:@"ProductType"];
    [p.postArgs setValue:@"" forKey:@"ProductSubType"];
    [p.postArgs setValue:@"" forKey:@"GroupID"];
    [p.postArgs setValue:@"200" forKey:@"PageSize"];
    [p.postArgs setValue:@"1" forKey:@"PageIndex"];
    [p.postArgs setValue:@"Column1" forKey:@"OrderFiled"];
    [p.postArgs setValue:@"1" forKey:@"OrderDirect"];
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
        mIsEnd = YES;

        [self.tableView reloadData];
        [self dismissWaitDialog];
    }];
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
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
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return titleview;
}
/*
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
