//
//  SHSexOrientationViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHSexOrientationViewController.h"
#import "SHSexOrientationCell.h"
@interface SHSexOrientationViewController ()

@end

@implementation SHSexOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的特长";
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[ UIImage imageNamed:@"ic_ok"]  target:self action:@selector(btnOK:)];
    // Do any additional setup after loading the view.
}

- (void)btnOK:(UIButton*)b
{
    int value = 0;
    for (int i = 0; i < mList.count; i++) {
        SHSexOrientationCell * cell = (SHSexOrientationCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell.switch_new.isOn){
            switch (i) {
                case 0:
                    value += 1;
                    break;
                case 1:
                    value += 2;

                    break;
                case 2:
                    value += 4;

                    break;
                case 3:
                    value += 8;

                    break;
                    
                default:
                    break;
            }
        }
    }
    if(value == 0){
        [self showAlertDialog:@"请选择至少一个特长"];
    }else{
        SHPostTaskM * p = [[SHPostTaskM alloc]init];
        p.URL = URL_FOR(@"SettingAccountant");
        [p.postArgs setValue: [NSNumber numberWithInt:value] forKey:@"Speciality"];
        [p start:^(SHTask *t) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESSFUL object:nil];

            [t.respinfo show];
        } taskWillTry:nil taskDidFailed:^(SHTask *t) {
            [t.respinfo show];

        }];
        
    }
}

- (void)loadNext
{
    mIsEnd = YES;
    mList = [NSArray arrayWithObjects:@"基金产品",@"信托产品",@"资管计划",@"私募基金", nil] ;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*)tableView:(UITableView *)tableView dequeueReusableStandardCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSexOrientationCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHSexOrientationCell" owner:nil options:nil]objectAtIndex:0];
    cell.labTitle.text = [mList objectAtIndex:indexPath.row];
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
