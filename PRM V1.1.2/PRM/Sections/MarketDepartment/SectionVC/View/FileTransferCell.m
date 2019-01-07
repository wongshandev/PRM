//
//  FileTransferCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "FileTransferCell.h"

@implementation FileTransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(FileTransferModel *)model{
    self.projectNumLabel.text = [NSString stringWithFormat:@"%@",model.Code];
    self.projectTypeLabel.text = [NSString stringWithFormat:@"%@",model.ProjectTypeName];
    self.projectNameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.projectContactLabel.text = [NSString stringWithFormat:@"%@",model.EngineeringName];
}
@end
