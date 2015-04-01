//
//  SHFirstPageViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/22/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHFirstPageViewController.h"
#import "SHProductCell.h"

@interface SHFirstPageViewController ()
{
    NSArray * mImage ;
    NSTimer * timer;
    int  direct;
    int index;
}
@end

@implementation SHFirstPageViewController
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
    self.title = @"有钱";
        timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(btnChanged:) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}
- (void)btnChanged:(NSObject*)nssender
{
    if(direct){
        index--;
    }else{
        index++;
    }
    if(index == mImage.count -1){
        direct = 1;
    }else if (index==0){
        direct = 0;
    }
    [self.scroll setContentOffset:CGPointMake(index*self.view.frame.size.width, 0) animated:YES];
    
}

- (void)loadNext
{
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = URL_FOR(@"GetHomePage");
    [post start:^(SHTask * t) {
        mImage = [t.result valueForKey:@"PicList"];
        if(mImage.count > 1){
             timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(btnChanged:) userInfo:nil repeats:YES];
        }
        mList = [t.result valueForKey:@"ProList"];
        for (int i = 0; i < mImage.count; i++) {
            NSDictionary * dic = [mImage objectAtIndex:i ];
            SHImageView * img = [[SHImageView alloc]initWithFrame:CGRectMake(i *  self.scroll.frame.size.width, 0, self.scroll.frame.size.width, self.scroll.frame.size.height)];
            UIButton * b = [[UIButton alloc]initWithFrame:img.frame];
            [b addTarget:self action:@selector(btnOnTouch:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
            [img setUrl:[dic valueForKey:@"PhotoUrl"]];
            [self.scroll addSubview:b];
            [self.scroll addSubview:img];
            mIsEnd = YES;
        }
        self.scroll.contentSize =CGSizeMake(mImage.count * self.scroll.frame.size.width, self.scroll.frame.size.height);
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
    if([a count]> 3){
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
    NSString * msg = [NSString  stringWithFormat:@"理财师【当前理财师姓名%@】正在使用“天天有钱”，他推荐您关注此产品：[%@]产品摘要模版[%@:%@],[%@:%@],[%@:%@],[%@:%@],想查看产品详情并和认证理财师互动,请下载财富导航app",[[[NSUserDefaults standardUserDefaults] valueForKey:@"User"]valueForKey:@"UserName"],[dic valueForKey:@"ShortProductName"],[[[a objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1],[[[a objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1],[[[a objectAtIndex:2] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:2] componentsSeparatedByString:@":"] objectAtIndex:1],[[[a objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:0],[[[a objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:1]];
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

- (IBAction)btnOnTouch:(id)sender
{
    int   index_ = (self.scroll.contentOffset.x + self.scroll.frame.size.width/2 )/self.scroll.frame.size.width;
    NSDictionary * dic = [mImage objectAtIndex:index_];
    SHIntent * i = [[SHIntent alloc]init:@"webview" delegate:nil containner:self.navigationController];
    [i.args setValue:  [ dic valueForKey: @"PageUrl"] forKey:@"url"];
    [i.args setValue:@"浏览器" forKey:@"title"];
    [[UIApplication sharedApplication]open:i];
    
}
@end
