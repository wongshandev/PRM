//
//  MarketOrderCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseOrderPayModel.h"
@interface PurchaseOrderPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplyLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;


-(void)showCellDataWithModel:(PurchaseOrderPayModel *)model;


@end
