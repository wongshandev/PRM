//
//  ProjectChangeDetialCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/21.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProjectChangeDetialCell.h"

@implementation ProjectChangeDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
-(void)showCellDataWithModel:(ProjectChangeDetialModel *)model{
    NSInteger receiveTypeValue = model.ChangeType.integerValue;
    self.changeTypeLabel.text = ( receiveTypeValue == 1?@"签证变更": @"乙方责任");
    self.cahngeTimeLabel.text = [NSString stringWithFormat:@"%@",model.CreateDate];
    self.markLabel.text = [NSString stringWithFormat:@"%@",model.Remark];
  }

@end
