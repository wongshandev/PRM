//
//  MarketOrderCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ChangeOrdersCell.h"

@implementation ChangeOrdersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCellDataWithModel:(ChangeOrdersModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.codeNumLabel.text = [NSString stringWithFormat:@"%@",model.Code];
    self.techPersonLabel.text = [NSString stringWithFormat:@"%@",model.DesignName];
    self.marketPersonLabel.text = [NSString stringWithFormat:@"%@",model.InquiryName];
    self.receiveAddressLabel.text = [NSString stringWithFormat:@"  项目地址:  %@",model.Address];

}
@end
