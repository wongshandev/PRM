//
//  MarketHeaderView.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProjectApprovalHeaderView.h"

@implementation ProjectApprovalHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    [super layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
@end
