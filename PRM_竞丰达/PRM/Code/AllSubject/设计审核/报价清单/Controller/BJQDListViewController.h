//
//  BJQDListViewController.h
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "SJSHListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyBlock )(NSString *bjqdZJ,NSString *yhJE);

@interface BJQDListViewController : DXSuperTabViewController<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,copy)MyBlock myblock;
@property(nonatomic,strong)SJSHListModel *sjshListModel;

-(void)requestData_SJSH_BJQD;

@end

NS_ASSUME_NONNULL_END
