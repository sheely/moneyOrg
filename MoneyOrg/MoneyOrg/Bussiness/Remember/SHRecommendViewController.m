//
//  SHRecommendViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/23/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHRecommendViewController.h"

@interface SHRecommendViewController ()

@end

@implementation SHRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推荐";
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = URL_FOR(@"MyRecommendList");
    [post start:^(SHTask * t) {
        
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        
    }];
    // Do any additional setup after loading the view from its nib.
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

@end
