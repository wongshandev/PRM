//
//  MarketOrderCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketOrderModel.h"
@interface MarketOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyBuyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *demandDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStateLabel;

-(void)showCellDataWithModel:(MarketOrderModel *)model;


@end
