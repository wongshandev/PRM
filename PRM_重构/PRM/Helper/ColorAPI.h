//
//  ColorAPI.h
//  PRM
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorAPI : NSObject
/// RGB颜色(16进制)
#define Color_RGB_HEX(rgbValue, a)  [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0  green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0  blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define RGBColor(r, g, b)       ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

// 随机颜色
#define Color_Random [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]



// NavigationBar 的 蓝色背景
#define Color_NavigationBlue            RGBColor(96, 140, 215)
#define Color_NavigationLightBlue     Color_RGB_HEX(0x007BD3, 1) //RGBColor(128, 175, 233)
//cell 隔行换色背景
#define Color_CellBackground           RGBColor(228, 239, 245)
// 分割线颜色
#define Color_SrprateLine                 RGBColor(240, 240, 240)



// RGB 颜色 
#define Color_Black        [UIColor blackColor]
#define Color_Blue          [UIColor blueColor]
#define Color_Brown       [UIColor brownColor]
#define Color_Clear         [UIColor clearColor]
#define Color_DarkGray  [UIColor darkGrayColor]
#define Color_DarkText   [UIColor darkTextColor]
#define Color_White        [UIColor whiteColor]
#define Color_Yellow       [UIColor yellowColor]
#define Color_Red           [UIColor redColor]
#define Color_Orange      [UIColor orangeColor]
#define Color_Purple       [UIColor purpleColor]
#define Color_LightText  [UIColor lightTextColor]
#define Color_LightGray [UIColor lightGrayColor]
#define Color_Green        [UIColor greenColor]
#define Color_Gray          [UIColor grayColor]
#define Color_Magenta    [UIColor magentaColor]

@end

NS_ASSUME_NONNULL_END
