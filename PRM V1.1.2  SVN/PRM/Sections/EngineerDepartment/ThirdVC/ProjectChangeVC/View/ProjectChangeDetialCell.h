//
//  ProjectChangeDetialCell.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/21.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectChangeDetialModel.h"
@interface ProjectChangeDetialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *changeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cahngeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property(nonatomic,copy)void (^btnBlock)();

-(void)showCellDataWithModel:(ProjectChangeDetialModel *)model;

@end
