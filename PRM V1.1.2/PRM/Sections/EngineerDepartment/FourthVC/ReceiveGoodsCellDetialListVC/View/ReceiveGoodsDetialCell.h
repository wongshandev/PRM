//
//  ReceiveGoodsDetialCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/21.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveGoodsDetialModel.h"
@interface ReceiveGoodsDetialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *matericalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *matericalTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisReceiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;

-(void)showCellDataWithModel:(ReceiveGoodsDetialModel *)model;
@end
