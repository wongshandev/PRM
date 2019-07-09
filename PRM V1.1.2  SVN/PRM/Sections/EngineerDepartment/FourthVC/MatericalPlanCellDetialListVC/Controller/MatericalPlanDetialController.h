//
//  MatericalPlanDetialController.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/16.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseViewController.h"
@interface MatericalPlanDetialController : BaseViewController

@property(nonatomic,copy)NSString *projectBranchID;
@property(nonatomic,copy)NSString *marketOrderID;
@property(nonatomic,copy)NSString *deliveryDate;

@property(nonatomic,copy)void(^JumpBlock)(JumpDirection junpDirection);
@property (assign, nonatomic)  BOOL isSaveItem;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectButton;

@end
