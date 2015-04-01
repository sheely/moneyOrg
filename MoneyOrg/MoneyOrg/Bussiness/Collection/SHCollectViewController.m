//
//  SHCollectViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/22/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHCollectViewController.h"
#import "SHProductCell.h"

@interface SHCollectViewController ()
{
   // NSArray * mImage ;

}
@end

@implementation SHCollectViewController

- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= 50;
    self.navigationController.view.frame =rect;
    //[self loadNext];
    
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
    self.title = @"我的店铺";
     SHPostTaskM * p = [[SHPostTaskM alloc]init];
     p.URL = URL_FOR(@"GetUserDetail");
     [p start:^(SHTask *t) {
        
          int level = [[t.result valueForKey:@"Score"] intValue]/100;
          if(level == 0){
               level = 1;
          }
          for (int i = 0; i< level; i++) {
               UIImageView * img = [[UIImageView alloc]init];
               img.image = [UIImage imageNamed:@"ic_star"];
               img.frame = CGRectMake(62 + (20)*i , 31, 15, 15);
               [self.view addSubview:img];
          }
          self.labName.text = [NSString stringWithFormat:@"%@的店铺",[t.result valueForKey:@"UserName"]];
          [self.imgView setUrl:[t.result valueForKey:@"UserVPhoto"]];
          
          [self dismissWaitDialog];
     } taskWillTry:nil taskDidFailed:^(SHTask *t) {
          [t.respinfo show];
          [self dismissWaitDialog];
     }];
     // Do any additional setup after loading the view from its nib.
}

- (void)loadNext
{
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = URL_FOR(@"MyCollectList");
    [post start:^(SHTask * t) {
//        mImage = [t.result valueForKey:@"PicList"];
        mList = [t.result valueForKey:@"ProList"];
//        for (int i = 0; i < mImage.count; i++) {
//            NSDictionary * dic = [mImage objectAtIndex:i ];
//            SHImageView * img = [[SHImageView alloc]initWithFrame:CGRectMake(i *  self.scroll.frame.size.width, 0, self.scroll.frame.size.width, self.scroll.frame.size.height)];
//            [img setUrl:[dic valueForKey:@"PhotoUrl"]];
//            [self.scroll addSubview:img];
//        }
//        self.scroll.contentSize =CGSizeMake(mImage.count * self.scroll.frame.size.width, self.scroll.frame.size.height);
        mIsEnd = YES;
        [self.tableView reloadData];
    } taskWillTry:nil taskDidFailed:^(SHTask * t) {
        
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableStandardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [mList objectAtIndex:indexPath.row];
    SHProductCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHProductCell" owner:nil options:nil] objectAtIndex:0];
    NSArray *a = [[dic valueForKey:@"Columns"]componentsSeparatedByString:@"|"];
    
    cell.labC1.text =  [[[a objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] ;
    cell.labC2.text =  [[[a objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] ;
    cell.labC3.text =  [[[a objectAtIndex:2] componentsSeparatedByString:@":"] objectAtIndex:1] ;
    if(a.count > 3){
        cell.labC4.text =  [[[a objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:1] ;    //cell.labNum.text = [dic valueForKey:@"ProductCode"];

    }
    CGRect r = cell.labName.frame;
    r.size.width = 300;
    cell.labName.frame = r;
    cell.labName.text = [dic valueForKey:@"ShortProductName"];
    //cell.labCusNum.text = [[dic valueForKey:@"CustomerNum"] stringValue];
    [cell alternate:indexPath];
    
    cell.btnOrder.hidden = YES;
    cell.labCusNum.hidden = YES;
    cell.imgCusNum.hidden = YES;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [intent.args setValue:[dic valueForKey:@"ShortProductName"] forKey:@"title"];
    
    NSArray *a = [[dic valueForKey:@"Columns"]componentsSeparatedByString:@"|"];
    NSString * msg = [NSString  stringWithFormat:@"理财师【当前理财师姓名%@】正在使用“天天有钱”，他推荐您关注此产品：[%@]产品摘要模版[%@:%@],[%@:%@],[%@:%@],[%@:%@],想查看产品详情并和认证理财师互动,请下载天天有钱app",[[[NSUserDefaults standardUserDefaults] valueForKey:@"User"]valueForKey:@"UserName"],[dic valueForKey:@"ShortProductName"],[[[a objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1],[[[a objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1],[[[a objectAtIndex:2] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:2] componentsSeparatedByString:@":"] objectAtIndex:1],[[[a objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:1]];
    [intent.args setValue:msg forKey:@"text"];
    [[UIApplication sharedApplication]open:intent];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
