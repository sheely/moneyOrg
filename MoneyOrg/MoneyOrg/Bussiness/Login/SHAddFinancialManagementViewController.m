//
//  SHAddFinancialManagementViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 3/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHAddFinancialManagementViewController.h"

@interface SHAddFinancialManagementViewController ()

@end

@implementation SHAddFinancialManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.autoKeyboard = YES;
    self.title = @"查找理财师";

    // Do any additional setup after loading the view from its nib.
}

- (void)loadSkin
{
    [super loadSkin];
    self.btnSearch.layer.cornerRadius = 5;
    self.btnSearch.layer.masksToBounds = YES;
    self.btnSearch2.layer.cornerRadius = 5;
    self.btnSearch2.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnCode:(id)sender {
    SHIntent* intent =  [[SHIntent alloc]init:@"search_financial" delegate:nil containner:self.navigationController];
    [intent.args setValue:self.txtCode.text forKey:@"UserCode"];
    [intent.args setValue:@"" forKey:@"Mobile"];
    [intent.args setValue:@"0" forKey:@"Speciality"];
    [[UIApplication sharedApplication]open:intent];

}

- (IBAction)btnMobile:(id)sender {
    SHIntent* intent =  [[SHIntent alloc]init:@"search_financial" delegate:nil containner:self.navigationController];
    
    [intent.args setValue:@"" forKey:@"UserCode"];
    [intent.args setValue:self.txtMobile.text forKey:@"Mobile"];
    [intent.args setValue:@"0" forKey:@"Speciality"];
    
    [[UIApplication sharedApplication]open:intent];

}

- (IBAction)btnSearchOnTouch:(UIButton*)sender
{
    SHIntent* intent =  [[SHIntent alloc]init:@"search_financial" delegate:nil containner:self.navigationController];
    
    [intent.args setValue:@"" forKey:@"UserCode"];
    [intent.args setValue:@"" forKey:@"Mobile"];
    [intent.args setValue: [NSNumber numberWithInt:sender.tag] forKey:@"Speciality"];
    
    [[UIApplication sharedApplication]open:intent];
}
@end
