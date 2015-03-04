//
//  SHRecommendCell.m
//  MoneyOrg
//
//  Created by sheely.paean.Nightshade on 2/24/15.
//  Copyright (c) 2015 sheely.paean.coretest. All rights reserved.
//

#import "SHRecommendCell.h"

@implementation SHRecommendCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)loadSkin
{
    [super loadSkin];
    self.btnOrder.layer.cornerRadius =5 ;
    self.btnOrder.layer.masksToBounds = YES;
}
@end
