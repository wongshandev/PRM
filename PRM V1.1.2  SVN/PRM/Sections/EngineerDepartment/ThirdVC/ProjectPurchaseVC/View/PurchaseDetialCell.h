//
//  PurchaseDetialCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/20.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseDetialModel.h"
@interface PurchaseDetialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *materialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *planNumLabel;

-(void)showCellDataWithModel:(PurchaseDetialModel *)model;

@end
