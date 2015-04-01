//
//  SHProductDetialViewController.h
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/1/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHViewController.h"

@interface SHProductDetialViewController : SHViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnTuijian;
@property (weak, nonatomic) IBOutlet UILabel *labCustomer;
@property (weak, nonatomic) IBOutlet UIButton *btnDoc;
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;
- (IBAction)btnShareOnTouch:(id)sender;
- (IBAction)btnTuijianOnTouch:(id)sender;
- (IBAction)btnOrderOnTouch:(id)sender;
- (IBAction)btnDocOnTouch:(id)sender;

@end
