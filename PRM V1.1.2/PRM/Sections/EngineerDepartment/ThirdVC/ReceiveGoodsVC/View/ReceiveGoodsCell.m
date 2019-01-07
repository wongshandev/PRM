//
//  ReceiveGoodsCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ReceiveGoodsCell.h"

@implementation ReceiveGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(ReceiveGoodsModel *)model{
    NSInteger receiveTypeValue = model.SiteState.integerValue;
    self.receiveTypeLabel.text = ( receiveTypeValue == 1?@"采购接收": @"总部发货接收");
    self.out_supplyLabel.text = [NSString stringWithFormat:@"%@",model.SupplierName];
    self.stateLabel.text = [NSString stringWithFormat:@"%@",model.StateName];
    self.receivePersonLabel.text = [NSString stringWithFormat:@"%@",model.Employee];
    self.purchaseNumLabel.text = [NSString stringWithFormat:@"%@",model.Code];
}

@end
