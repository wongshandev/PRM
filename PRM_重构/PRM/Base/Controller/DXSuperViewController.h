//
//  DXSuperViewController.h
//  DaXueZhang
//
//  Created by qiaoxuekui on 2018/7/11.
//  Copyright © 2018年 qiaoxuekui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXNavBarView.h"
#import "QMUICommonViewController.h"

@interface DXSuperViewController : QMUICommonViewController
@property (nonatomic,strong) DXNavBarView *navBar;

/**
 * 子类继承的方法
 */
 
- (void)buildSubviews;

- (void)setUpNavigationBar;

- (void)bindViewModel;

//跳转到登录界面
- (void)goToLoginViewController;

@end
