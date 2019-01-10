//
//  SJYMacro.h
//  PRM
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019年 JoinupMac01. All rights reserved.
//

#ifndef SJYMacro_h
#define SJYMacro_h


// 系统控件默认高度
#define kStatusBarHeight           ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kNavBarHeight              (44.f)
#define kTopStatusAndNavBarHeight  (kStatusBarHeight + kNavBarHeight)
#define kTabBarHeight              (49.f)

//是否 iOS11
#define IOS11_OR_LATER      ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending )

//屏幕尺寸
#define kDeviceWidth    [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight   [UIScreen mainScreen].bounds.size.height

// 是否是 iphoneX
//依据屏幕分辨率 resolution
#define IS_iPhoneX_ByScreenResolution ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//根据状态栏高度判断
#define IS_iPhoneX_ByStatusBarHeight (([[UIApplication sharedApplication] statusBarFrame].size.height > 20)?YES:NO)
//依据屏幕尺寸
#define IS_iPhoneX_ByScreenSize (kDeviceWidth == 375.f && kDeviceHeight == 812.f)

#define kStatusBarAndNavigationBarHeight (IS_iPhoneX_ByScreenResolution ? 88.f : 64.f)


#define isHighterThanIPhone5  ([UIScreen mainScreen].bounds.size.height <= 568 ? NO : YES)

#endif /* SJYMacro_h */
