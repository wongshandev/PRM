//
//  DXSuperViewController.h
//  DaXueZhang
//
//  Created by Sonjery on 2018/7/11.
//  Copyright © 2018年 Sonjery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXNavBarView.h"
#import "QMUICommonViewController.h"
@interface DXSuperViewController : QMUICommonViewController
@property (nonatomic,strong) DXNavBarView *navBar;
 
/**
 * 子类继承的方法
 */
- (void)setUpNavigationBar;
 
- (void)buildSubviews;


- (void)bindViewModel;

//跳转到登录界面
- (void)goToLoginViewController;

@end
