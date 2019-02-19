//
//  CGFKDetialViewController.h
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "CGFKListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGFKDetialViewController : DXSuperTabViewController
@property(nonatomic,strong)CGFKListModel *listModel;
@property(nonatomic,assign)NSInteger eld;
@end

NS_ASSUME_NONNULL_END
