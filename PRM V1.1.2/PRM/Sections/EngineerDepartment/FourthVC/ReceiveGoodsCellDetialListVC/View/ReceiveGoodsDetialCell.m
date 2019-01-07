//
//  ReceiveGoodsDetialCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/21.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ReceiveGoodsDetialCell.h"

@implementation ReceiveGoodsDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(ReceiveGoodsDetialModel *)model{
    self.matericalNameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.matericalTypeLabel.text = [NSString stringWithFormat:@"%@",model.Model];
    self.totalNumLabel.text = [NSString stringWithFormat:@"%@",model.Quantity];
    self.receivedNumLabel.text = [NSString stringWithFormat:@"%@",model.QuantityReceive];
    self.thisReceiveLabel.text = [NSString stringWithFormat:@"%@",model.QuantityCheck];
    self.markLabel.text = [NSString stringWithFormat:@"%@",model.Remark];
}
@end
