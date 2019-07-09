//
//  MarketOrderCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeOrdersModel.h"
@interface ChangeOrdersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *codeNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *techPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPersonLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;


-(void)showCellDataWithModel:(ChangeOrdersModel *)model;


@end
