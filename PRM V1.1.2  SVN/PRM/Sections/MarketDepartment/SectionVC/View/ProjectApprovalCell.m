//
//  ProjectApprovalCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProjectApprovalCell.h"

@implementation ProjectApprovalCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCellDataWithModel:(ProjectApprovelModel *)model{
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.Code];
    self.typeLabel.text = [NSString stringWithFormat:@"%@",model.ProjectTypeName];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.personLabel.text = [NSString stringWithFormat:@"%@",model.InquiryName];
    self.cityLabel.text = [NSString stringWithFormat:@"%@",model.City];
}
@end
