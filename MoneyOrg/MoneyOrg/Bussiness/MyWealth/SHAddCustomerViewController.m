//
//  SHAddCustomerViewController.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/11/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHAddCustomerViewController.h"
#import <AddressBook/AddressBook.h>
#import "SHCustomerAddCell.h"
#import <MessageUI/MessageUI.h>
#import "ChineseString.h"
@interface SHAddCustomerViewController ()
{
    NSMutableArray * mListSelecteds;
    NSMutableArray * mListSended;

    NSMutableArray * mListALL;
    NSMutableArray * arrayIndex;
}
@end

@implementation SHAddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mListSelecteds = [[NSMutableArray alloc]init];
    self.title = @"新增客户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ok"]  target:self action:@selector(btnOK:)];
    [self loadNext];
    mListSended = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_sended"] mutableCopy];
    if(mListSended == nil){
        mListSended = [[NSMutableArray alloc]init];
    }
    self.autoKeyboard = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadNext
{
    [self readAllPeoples];
    [self.tableView reloadData];
}

- (void)btnOK:(UIButton*)a
{
    [self a];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mListALL.count;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[mListALL objectAtIndex:section] count];
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [[mListALL objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SHCustomerAddCell_new * cell = [[[NSBundle mainBundle]loadNibNamed:@"SHCustomerAddCell_new" owner:nil options:nil]objectAtIndex:0];
    cell.labTitle.text = [dic valueForKey:@"name"];
    cell.labContent.text = [dic valueForKey:@"phone"];
    if([mListSelecteds containsObject:cell.labContent.text]){
        cell.check_switch_new.on = YES;
    }else{
        cell.check_switch_new.on = NO;
    }
    if([mListSended containsObject:cell.labContent.text]){
        cell.labState.text = @"已邀请";
        cell.labState.textColor = [UIColor orangeColor];
    }
    cell.check_switch_new.tag = indexPath.row;
    [cell.check_switch_new addTarget:self action:@selector(switch_check:) forControlEvents:UIControlEventValueChanged];
    return cell;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView

{
    return arrayIndex;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dic = [[mListALL objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
    SHCustomerAddCell_new * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.check_switch_new setOn:!cell.check_switch_new.on animated:YES];
    if([[dic valueForKey:@"phone"] length]>0 ){
        if(cell.check_switch_new .on){
            [mListSelecteds addObject:[dic valueForKey:@"phone"]];
        }else{
            [mListSelecteds removeObject:[dic valueForKey:@"phone"]];
            
        }
    }

}


- (void)a
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            [self showAlertDialog:@"设备没有短信功能"];
        }
    }
    else {
        
        [self showAlertDialog:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = mListSelecteds;
    picker.body= @"欢迎使用财富导航";
    [self showWaitDialog:@"请稍候" state:@"正在启动"];
    [self presentViewController:picker animated:YES completion:^{
        [self dismissWaitDialog];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            //LOG_EXPR(@"Result: SMS sending canceled");
            
        case MessageComposeResultSent:
            //LOG_EXPR(@"Result: SMS sent");
            [mListSended addObjectsFromArray:mListSelecteds];
            [self.tableView reloadData];
            [[NSUserDefaults standardUserDefaults] setValue:mListSended forKey:@"user_sended"];
            break;
        case MessageComposeResultFailed:
            [ self showAlertDialog:@"短信发送失败"];
            break;
        default:
            //LOG_EXPR(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.8];
    lab.text = [NSString stringWithFormat:@"  %@",[arrayIndex objectAtIndex:section]];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:15];
    return lab;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)readAllPeoples
{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    NSMutableArray * mList = [[NSMutableArray alloc]init];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        // dispatch_release(sema);
    }
    else{
        tmpAddressBook =ABAddressBookCreate();
    }
    //取得本地所有联系人记录
    
    
    if (tmpAddressBook==nil) {
        return ;
    };
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    for(id tmpPerson in tmpPeoples){
        
        //获取的联系人单一属性:First name
        
        
        NSMutableDictionary * dicuser = [[NSMutableDictionary alloc]init];
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        
        NSLog(@"First name:%@", tmpFirstName);
        
        //[tmpFirstName release];
        
        //获取的联系人单一属性:Last name
        
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        
        NSLog(@"Last name:%@", tmpLastName);
        
        [dicuser setValue: [NSString stringWithFormat:@"%@%@",tmpLastName==nil? @"":tmpLastName,tmpFirstName == nil? @"":tmpFirstName] forKey:@"name"];
        
        
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++){
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            [dicuser setValue: [NSString stringWithFormat:@"%@",tmpPhoneIndex == nil ?@"":tmpPhoneIndex] forKey:@"phone"];
            break;
            //[tmpPhoneIndex release];
        }
        CFRelease(tmpPhones);
        if([[dicuser valueForKey:@"phone"] length]>0 && [dicuser valueForKey:@"name"] > 0){
            [mList addObject:dicuser];
        }
    }
    
    arrayIndex = [ChineseString IndexArray:mList];
    mListALL = [ChineseString LetterSortDic:mList];

 
    //释放内存
    // [tmpPeoples release];
    CFRelease(tmpAddressBook);
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

- (IBAction)txtCode:(id)sender {
}
@end
