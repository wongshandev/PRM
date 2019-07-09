//
//  ChangeOrdersApproveCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/13.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ChangeOrdersApproveCell.h"

@implementation ChangeOrdersApproveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(ChangeOrdersApproveModel *)model{
    self.codeNumLabel.text = [NSString stringWithFormat:@"%@",model.Code];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.applyPersonLabel.text = [NSString stringWithFormat:@"%@",model.CName];
    self.chageTypeLabel.text = [NSString stringWithFormat:@"%@",model.ChangeType.integerValue== 1? @"签证变更":@"乙方责任"];
    self.markInfoLabel.text = [NSString stringWithFormat:@"  备注: %@",model.Remark];
        
}

@end
