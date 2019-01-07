//
//  MaterialPalnCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialPalnModel.h"

@interface MaterialPalnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *planPersonLabel;

@property (weak, nonatomic) IBOutlet UILabel *planDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *demandDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

-(void)showCellDataWithModel:(MaterialPalnModel *)model;
@end
