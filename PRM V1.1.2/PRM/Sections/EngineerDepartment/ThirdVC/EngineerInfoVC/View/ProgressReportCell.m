//
//  ProgressReportCell.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProgressReportCell.h"

@implementation ProgressReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCellDataWithModel:(ProgressReportModel *)model{
    NSInteger kssj = [model.BeginDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    NSInteger jssj = [model.EndDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    NSInteger hbsj = [model.LastModifyDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    self.startDateLabel.text = [NSString stringWithFormat:@"%@",model.BeginDate];
    self.endDateLabel.text = [NSString stringWithFormat:@"%@",jssj>= kssj?model.EndDate:@""];
    self.lastDateLabel.text = [NSString stringWithFormat:@"%@",hbsj>= kssj?model.LastModifyDate:@""];
    self.progressLabel.text = [NSString stringWithFormat:@"%@%%",model.CompletionRate];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.Remark];
    self.completeProgress.progress = model.CompletionRate.integerValue/100.0;
    NSInteger rate = model.CompletionRate.integerValue;
    self.stateLabel.text =(rate == 0?@"未开工":rate == 100?@"已完成":@"施工中");
}

@end
