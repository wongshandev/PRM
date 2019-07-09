//
//  ProjectApprovalCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EngineeringModel.h"
@interface EngineeringCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *technicalPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPersonLabel;

-(void)showCellDataWithModel:(EngineeringModel *)model;

@end
