//
//  WLJHDetialController.h
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "WLJHListModel.h"
@interface WLJHDetialController : DXSuperTabViewController
@property(copy,nonatomic)NSString *dState;
@property(copy,nonatomic)NSString *projectBranchID;
@property(copy,nonatomic)NSString *marketOrderID;

@property(strong,nonatomic)WLJHListModel *wlListModel;
@end


