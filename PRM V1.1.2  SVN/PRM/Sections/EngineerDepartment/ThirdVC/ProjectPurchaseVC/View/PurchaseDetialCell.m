//
//  PurchaseDetialCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/20.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "PurchaseDetialCell.h"

@implementation PurchaseDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(PurchaseDetialModel *)model{
    self.materialNameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.brandNameLabel.text = [NSString stringWithFormat:@"%@",model.BrandName];
    self.materialTypeLabel.text = [NSString stringWithFormat:@"%@",model.Model];
    self.planNumLabel.text = [NSString stringWithFormat:@"%@",model.Quantity];
}
@end
