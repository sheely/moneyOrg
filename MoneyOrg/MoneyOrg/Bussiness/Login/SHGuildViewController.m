//
//  SHGuildViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/26/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHGuildViewController.h"

@interface SHGuildViewController ()
{
    BOOL isPush ;
}
@end

@implementation SHGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320*4, self.view.frame.size.height);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > 320* 3 && !isPush){
        isPush = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"guild"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"guild_view_finished" object:nil];
    }
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
