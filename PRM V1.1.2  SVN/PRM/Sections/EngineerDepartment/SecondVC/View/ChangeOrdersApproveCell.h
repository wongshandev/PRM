//
//  ChangeOrdersApproveCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/13.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeOrdersApproveModel.h"
@interface ChangeOrdersApproveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *codeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *chageTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *markInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;

-(void)showCellDataWithModel:(ChangeOrdersApproveModel *)model;
@end
