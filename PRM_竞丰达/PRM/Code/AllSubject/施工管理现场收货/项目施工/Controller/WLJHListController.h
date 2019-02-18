//
//  WLJHListController.h
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "EngineeringModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLJHListController : DXSuperTabViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,strong)EngineeringModel *engineerModel;

@end

NS_ASSUME_NONNULL_END
