//
//  GCJDListViewController.h
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "SJSHListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GCJDListViewController : DXSuperTabViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,strong)SJSHListModel *sjshListModel; 
@end

NS_ASSUME_NONNULL_END
