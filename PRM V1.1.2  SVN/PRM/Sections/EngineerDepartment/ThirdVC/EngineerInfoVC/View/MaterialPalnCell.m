//
//  MaterialPalnCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MaterialPalnCell.h"
@implementation MaterialPalnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(MaterialPalnModel *)model{
    
    self.planPersonLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.planDateLabel.text = [NSString stringWithFormat:@"%@",model.CreateDate];
    NSInteger qgrq = [model.MarketDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    NSInteger planDate = [model.CreateDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
   NSInteger dhRq = [model.OrderDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    self.applyBuyLabel.text = [NSString stringWithFormat:@"%@",qgrq >= planDate?model.MarketDate:@""];
    self.demandDateLabel.text = [NSString stringWithFormat:@"%@",dhRq>= planDate?model.OrderDate:@""];
    NSInteger stateValue = model.State.integerValue;
    self.stateLabel.text = ( stateValue == 1?@"未提交": stateValue == 2?@"已提交未审核": stateValue == 3?@"已驳回": stateValue == 4?@"已审核通过": stateValue == 5?@"已下单": stateValue == 6?@"已下采购计划单,按计划发料":@"已完成");
}

@end
