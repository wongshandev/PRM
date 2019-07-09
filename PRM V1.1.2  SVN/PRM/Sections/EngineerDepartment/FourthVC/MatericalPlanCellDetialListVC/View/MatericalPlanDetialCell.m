//
//  MatericalPlanDetialCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/17.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MatericalPlanDetialCell.h"

@implementation MatericalPlanDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(MaterialPlanDetialModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.typeLabel.text = [NSString stringWithFormat:@"%@",model.Model];
    self.totalNumLabel.text = [NSString stringWithFormat:@"%@",model.Quantity];
    self.plannedLabel.text = [NSString stringWithFormat:@"%@",model.QuantityPurchased];
    self.thisApplyLabel.text = [NSString stringWithFormat:@"%@",model.QuantityThis];
}


@end
