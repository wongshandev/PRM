//
//  XMQGDetialController.h
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "XMQGListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMQGDetialController : DXSuperTabViewController
@property(nonatomic,strong)XMQGListModel *listModel;
@property(copy,nonatomic)NSString *marketOrderID;

@end

NS_ASSUME_NONNULL_END
