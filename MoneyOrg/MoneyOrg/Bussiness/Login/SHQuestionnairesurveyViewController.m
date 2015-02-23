//
//  SHQuestionnairesurveyViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/23/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHQuestionnairesurveyViewController.h"

@interface SHQuestionnairesurveyViewController ()

@end

@implementation SHQuestionnairesurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问卷调查";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ok"] target:self action:@selector(btnOK:)];
    [((UIScrollView*)self.view) setContentSize:CGSizeMake(320, 1023)];
    self.autoKeyboard = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnOK:(UIButton*)b
{
    
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
