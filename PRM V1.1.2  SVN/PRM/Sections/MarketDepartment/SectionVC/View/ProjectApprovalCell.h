//
//  ProjectApprovalCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectApprovelModel.h"
@interface ProjectApprovalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

-(void)showCellDataWithModel:(ProjectApprovelModel *)model;

@end
