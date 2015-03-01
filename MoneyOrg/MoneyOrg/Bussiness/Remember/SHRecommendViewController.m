//
//  SHRecommendViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/23/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHRecommendViewController.h"
#import "SHRecommendCell.h"

@interface SHRecommendViewController ()
{
    NSArray * mList;
}
@end

@implementation SHRecommendViewController
- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= 50;
    self.navigationController.view.frame =rect;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.navigationController.view.frame =rect;
    [super viewWillDisappear:animated];
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    
    post.URL = URL_FOR(@"MyRecommendList");
    [post start:^(SHTask * t) {
        mList = t.result;
        [self.tableView reloadData];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推荐";
        // Do any additional setup after loading the view from its nib.
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary * dic = [mList objectAtIndex:section];
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    lab.text = [NSString stringWithFormat:@"  %@",[dic valueForKey:@"RecommendTitle"]];
    lab.backgroundColor = [UIColor orangeColor];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor whiteColor];
    
    return lab;
}
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mList count];
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[mList objectAtIndex:section] valueForKey:@"Content"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [[[mList objectAtIndex:indexPath.section] valueForKey:@"Content"] objectAtIndex:indexPath.row];
    
    SHRecommendCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHRecommendCell" owner:nil options:nil ] objectAtIndex:0];
    cell.labTitle.text = [dic valueForKey:@"ObjectShowName"];
    NSArray * array = [[dic valueForKey:@"Columns"] componentsSeparatedByString:@"|"];
    NSMutableString* content = [[NSMutableString alloc]init];
    for (NSString * s  in array) {
        [content appendFormat:@"%@\n",s];
    }
    cell.labContent.text = content;
    cell.sizeToFit;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dic = [[[mList objectAtIndex:indexPath.section] valueForKey:@"Content"] objectAtIndex:indexPath.row];
    SHIntent * intent = [[SHIntent alloc]init:@"prod_detail" delegate:nil containner:self.navigationController];
    [intent.args setValue:[dic valueForKey:@"ObjectID"] forKey:@"id"];
    [intent.args setValue:[dic valueForKey:@"ObjectShowName"] forKey:@"title"];
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

@end
