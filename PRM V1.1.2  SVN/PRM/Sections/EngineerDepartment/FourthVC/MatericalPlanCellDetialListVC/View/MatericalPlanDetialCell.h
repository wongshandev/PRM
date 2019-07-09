//
//  MatericalPlanDetialCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/17.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialPlanDetialModel.h"
@interface MatericalPlanDetialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannedLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisApplyLabel;

-(void)showCellDataWithModel:(MaterialPlanDetialModel *)model;

@end
