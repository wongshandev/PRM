//
//  ReceiveGoodsCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveGoodsModel.h"
@interface ReceiveGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *out_supplyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivePersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseNumLabel;

-(void)showCellDataWithModel:(ReceiveGoodsModel *)model;


@end
