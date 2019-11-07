//
//  AppDelegate+RootViewController.m
//  PRM
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "AppDelegate+RootViewController.h"
#import "SJYLoginViewController.h"
#import "SJYMainViewController.h"
#import "SJYMenuViewController.h"
#import "MMDrawerVisualState.h"

@implementation AppDelegate (RootViewController)
-(void)setAppWindows{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [[SJYDefaultManager shareManager] saveSoftwareBelong:SoftwareBelongTo];
//    if ([[SJYDefaultManager shareManager]getFirstRun]) {
//        //配置端口
////        [[SJYDefaultManager shareManager] saveIPAddress:@"58.216.202.186" IPPort:@"8817"];
//
//    }
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)setRootViewController{
    SJYLoginViewController *loginVC = [[SJYLoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = navVC;
}
-(void)setRootViewController1{
    SJYLoginViewController *loginVC = [[SJYLoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = navVC;
}
-(void)gotoMainVC {
    SJYMainViewController *mainVC = [[SJYMainViewController alloc] init];
    UINavigationController *mainNavVC = [[UINavigationController alloc] initWithRootViewController:mainVC];

    SJYMenuViewController *leftMenuVC = [[SJYMenuViewController alloc]init];
    UINavigationController *leftNavVC = [[UINavigationController alloc] initWithRootViewController:leftMenuVC];
    MMDrawerController *drawerController =  [[MMDrawerController alloc]
                                             initWithCenterViewController:mainNavVC
                                             leftDrawerViewController:leftNavVC];

    [drawerController setRestorationIdentifier:@"MMDrawer"];
    drawerController.showsShadow = YES;
    drawerController.shouldStretchDrawer= NO;
    [drawerController setMaximumLeftDrawerWidth:MainDrawerWidth];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //抽屉动画样式
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState swingingDoorVisualStateBlock];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    self.window.rootViewController = drawerController;

}
@end
