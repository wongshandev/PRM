//
//  XMKZDetialController.h
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperViewController.h"
#import "XMKZDetialListModel.h"
#import "XMKZListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XMKZDetialController : DXSuperViewController//DXSuperTabViewController
@property(nonatomic,strong)XMKZDetialListModel *detialModel;
@property(nonatomic,strong)XMKZListModel *listModel;
@property(nonatomic,assign)NSInteger eld;

@end

NS_ASSUME_NONNULL_END
