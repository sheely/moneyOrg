//
//  SHQuestionnairesurveyViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/23/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHQuestionnairesurveyViewController.h"

@interface SHQuestionnairesurveyViewController ()

{
    UIButton * btnAge;
    UIButton * btnMoney;
    UIButton * btnYear;
    UIButton * btnDanger;
    UIButton * btnInCome;
    UIButton * btnType;
}
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
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = URL_FOR(@"RiskAssessment");
    [post.postArgs setValue:[NSNumber numberWithInt:btnAge.tag ] forKey:@"UserAge"];
    [post.postArgs setValue:[NSNumber numberWithInt:btnMoney.tag ] forKey:@"FamilyIncome"];
    [post.postArgs setValue:self.txtMoney.text forKey:@"InvestmentMoney"];
    [post.postArgs setValue:[NSNumber numberWithInt:btnYear.tag ] forKey:@"RecoveryCycle"];
    [post.postArgs setValue:[NSNumber numberWithInt:btnDanger.tag ] forKey:@"RiskBearing"];
    [post.postArgs setValue:[NSNumber numberWithInt:btnInCome.tag ] forKey:@"ExpectedProfit"];
    [post.postArgs setValue:[NSNumber numberWithInt:btnType.tag ] forKey:@"InvestmentType"];
    [post start:^(SHTask *t) {
        [t.respinfo show];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAgeOnTouch:(UIButton*)sender {
    btnAge.selected = NO;
    btnAge = sender;
    sender.selected = YES;
}



- (IBAction)btnMoneyOnTouch:(UIButton*)sender {
    btnMoney.selected = NO;
    btnMoney = sender;
    sender.selected = YES;
}

- (IBAction)btnYearOnTouch:(UIButton*)sender {
    btnYear.selected = NO;
    btnYear = sender;
    sender.selected = YES;
}

- (IBAction)btnDangerOnTouch:(UIButton*)sender {
    btnDanger.selected = NO;
    btnDanger = sender;
    sender.selected = YES;
}

- (IBAction)btnInComeOnTouch:(UIButton*)sender {
    btnInCome.selected = NO;
    btnInCome = sender;
    sender.selected = YES;
}

- (IBAction)btnTypeOnTouch:(UIButton*)sender {
    btnType.selected = NO;
    btnType = sender;
    sender.selected = YES;
}
@end
