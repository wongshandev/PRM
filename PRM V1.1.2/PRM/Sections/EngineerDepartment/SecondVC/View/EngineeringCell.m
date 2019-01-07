//
//  ProjectApprovalCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "EngineeringCell.h"

@implementation EngineeringCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCellDataWithModel:(EngineeringModel *)model{
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.Code];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.technicalPersonLabel.text = [NSString stringWithFormat:@"%@",model.DesignName];
    self.marketPersonLabel.text = [NSString stringWithFormat:@"%@",model.InquiryName];
}
@end
