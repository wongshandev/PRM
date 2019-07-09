//
//  MarketOrderCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "PurchaseOrderPayCell.h"

@implementation PurchaseOrderPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCellDataWithModel:(PurchaseOrderPayModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.personLabel.text = [NSString stringWithFormat:@"%@",model.CreateName];
    self.supplyLabel.text = [NSString stringWithFormat:@"%@",model.SupplierName];
    self.purchasePriceLabel.text = [NSString stringWithFormat:@"%@",model.AgreementPrice];

    

    self.receiveAddressLabel.text = [NSString stringWithFormat:@"  收货地址:  %@",model.PlaceReceipt];

}
@end
