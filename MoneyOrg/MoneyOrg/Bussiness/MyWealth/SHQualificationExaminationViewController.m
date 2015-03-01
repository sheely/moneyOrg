//
//  SHQualificationExaminationViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/21/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHQualificationExaminationViewController.h"

@interface SHQualificationExaminationViewController ()

@end

@implementation SHQualificationExaminationViewController

-(void)loadSkin
{
    [super loadSkin];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 0.5;
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.cornerRadius = 5;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职业资格审核";
    self.autoKeyboard = YES;
   
    if([[self.intent.args valueForKey:@"reg"] length] > 0){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步"  target:self action:@selector(btnOK:)];
        
    }else{
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[ UIImage imageNamed:@"ic_ok"]  target:self action:@selector(btnOK:)];
    }
    // Do any additional setup after loading the view from its nib.
}



- (void)btnOK:(UIButton*)b
{
    [self showWaitDialogForNetWork];
    SHPostTaskM * p = [[SHPostTaskM alloc]init];
    p.URL = URL_FOR(@"VerifyAccountant");
    [p.postArgs setValue:self.txtCardID.text forKey:@"AccountantSN"];
    if(self.imgView.image){
        [p.postArgs setValue:[SHTools encode:UIImageJPEGRepresentation(self.imgView.image,0.5)] forKey:@"CardPhoto"];
    }
    [p start:^(SHTask * t) {
        if([[self.intent.args valueForKey:@"reg"] length] > 0){
            SHIntent * i = [[SHIntent alloc]init:@"sexorientation" delegate:nil containner:self.navigationController];
            [[UIApplication sharedApplication]open:i];
        }else{
            [t.respinfo show];
        }
        //xcxx[t.respinfo show];
        [self dismissWaitDialog];
    } taskWillTry:nil taskDidFailed:^(SHTask * t) {
        if([[self.intent.args valueForKey:@"reg"] length] > 0){
            SHIntent * i = [[SHIntent alloc]init:@"sexorientation" delegate:nil containner:self.navigationController];
            [[UIApplication sharedApplication]open:i];
        }else{
            [t.respinfo show];

        }
        [self dismissWaitDialog];

    }];
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
    
    self.imgView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUploadImageOnTouch:(id)sender {
    [self photograph];
}
@end
