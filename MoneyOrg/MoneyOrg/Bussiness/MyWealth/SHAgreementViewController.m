//
//  SHAgreementViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/25/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHAgreementViewController.h"

@interface SHAgreementViewController ()

@end

@implementation SHAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传合同";
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ok"] target:self action:@selector(btnOK:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)btnOK:(UIButton*)b
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    post.URL = URL_FOR(@"ChangeOrderStatus");
    [post.postArgs setValue:@"20" forKey:@"TargetOrderStatus"];
    [post.postArgs setValue:[SHTools encode:UIImageJPEGRepresentation(self.imageView.image,0.7)] forKey:@"ContractPhoto"];
    [post.postArgs setValue:[self.intent.args valueForKey:@"OrderID"] forKey:@"OrderID"];
    [post start:^(SHTask * t) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"order_state_changed" object:nil];
        [t.respinfo show];
        [self.navigationController popViewControllerAnimated:YES];                            
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask * t) {
        [t.respinfo show];
        [self dismissWaitDialog];
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self loadCamera];//加载相机
            break;
        case 1:
            [self loadAlbum];//加载相册
            break;
            
        default:
            break;
    }
}

-(void)photograph
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册获取", nil];
    [actionSheet showInView:self.view];
    
}

-(void)loadCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        //        imgPicker.allowsEditing = YES;  //是否可编辑
        //摄像头
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    else{
        [self showAlertDialog:@"未检测到拍摄设备" button:@"确定" otherButton:nil];
    }
    
}
-(void)loadAlbum
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        //        imgPicker.allowsEditing = YES;  //是否可编辑
        //图片库
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUploadImageOnTouch:(id)sender {
    [self photograph];
}
- (void)loadSkin
{
    [super loadSkin];
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
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
