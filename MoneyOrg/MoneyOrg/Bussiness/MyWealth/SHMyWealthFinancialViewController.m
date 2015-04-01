//
//  SHMyWealthFinancial ViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHMyWealthFinancialViewController.h"

@interface SHMyWealthFinancialViewController ()
{
    NSDictionary * dic;
    CGRect orgFrame;
}
@end

@implementation SHMyWealthFinancialViewController
- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= 50;
    self.navigationController.view.frame =rect;
    
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
    self.title = @"我的财富";
    if(INVESTOR){
        self.viewMoney.hidden = YES;
        self.btnMoneyManager.hidden = NO;
        self.imgArrowZhiye.hidden = YES;
        self.viewPanl.frame = CGRectMake(0, 64, 320, 190);
        [self.view addSubview:self.viewPanl];
    }else{
        self.labZhiye.hidden = NO;
        self.labZhiyeState.hidden = NO;
        self.viewMyCustomer.hidden = NO;
        self.viewPanl.frame = CGRectMake(0, 258, 320, 190);
        [self.view addSubview:self.viewPanl];

    }
    
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"GetUserDetail");
    [p start:^(SHTask *t) {
        dic = t.result;
        [self.btnMoneyManager setTitle:[ NSString stringWithFormat:@"我的理财师  :  %@",[t.result valueForKey:@"MyAccountants" ]] forState: UIControlStateNormal   ];
        self.labZhiyeState.text = [[t.result valueForKey:@"HasConfirm"] boolValue]? @"[已认证]":@"[未认证]";
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
        
        self.labMoney.text = [[t.result valueForKey:@"Earned"] stringValue];
        self.labMoney2.text = [[t.result valueForKey:@"WillEarn"] stringValue];
        self.labName.text = [t.result valueForKey:@"UserName"];
        [self.imgView setUrl:[t.result valueForKey:@"UserVPhoto"]];
        
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" target:self action:@selector(btnQUIT:)];
    orgFrame = self.navigationController.view.frame;
    // Do any additional setup after loading the view from its nib.
}

- (void)btnQUIT:(UIButton*) b
{
    SHEntironment.instance.loginName = @"";
    SHEntironment.instance.password = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:nil];
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

- (IBAction)btnOrderListOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"order_list" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:i];
}

- (IBAction)btnCusOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"customer_list" delegate:nil containner:self.navigationController];
    [[UIApplication sharedApplication]open:i];

}

- (IBAction)btnQualificationOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"qualification_examination" delegate:nil containner:self.navigationController];
    [i.args setValue: [dic valueForKey:@"AccountantSN"] forKey:@"AccountantSN"];
    [i.args setValue: [dic valueForKey:@"CardPhotoVPath"]forKey:@"CardPhotoVPath"];
    [[UIApplication sharedApplication]open:i];

}

- (IBAction)btnMyInfoOnTouch:(id)sender {
    SHIntent * i = [[SHIntent alloc]init:@"myinfo" delegate:nil containner:self.navigationController];
        [[UIApplication sharedApplication]open:i];
    


}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 判断有摄像头，并且支持拍照功能
    // 初始化图片选择控制器
    if(actionSheet.tag == 0){
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
        if(buttonIndex == 2){
            return ;
        }else if(buttonIndex == 0){
            [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
            [controller setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        }else{
            [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
            
        }
        
        [controller setAllowsEditing:YES];// 设置是否可以管理已经存在的图片或者视频
        [controller setDelegate:self];// 设置代理
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.view.frame = orgFrame;
        }];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * img = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    self.imgView.image = img;
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"SettingUserDetail");
    [p.postArgs setValue:    [SHTools encode:UIImageJPEGRepresentation(img, 0.5)] forKey:@"UserPhoto"];
    [p.postArgs setValue:    @"" forKey:@"CNUserName"];
    
    
    [p start:^(SHTask *t) {
        
        [self dismissWaitDialog];
        [t.respinfo show];
        
    } taskWillTry:nil taskDidFailed:^(SHTask *t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.view.frame = orgFrame;
        }];
    }];
}



- (IBAction)btnUserPhotoOnTouch:(id)sender {
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    sheet.tag = 0;
    [sheet showInView:self.view];
}
@end
