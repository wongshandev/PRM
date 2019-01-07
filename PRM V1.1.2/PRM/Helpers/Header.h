//
//  Header.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/6.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#ifndef Header_h
#define Header_h



typedef enum  {
    isMatericalPlanDetialVCToEngineerInfoVC,
} JumpDirection;




//1.经常引入一些常用的宏定义
//2.常用的API 如NSLog
//3.后台数据接口地址
//屏幕高
#define kDeviceHeight           [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth            [UIScreen mainScreen].bounds.size.width
#define RGBColor(r, g, b, alph)      ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alph)/1])
#define kGeneralColor_lightCyanColor  (RGBColor(0, 256, 256, 0.8))
#define kWarningColor_lightRedColor  (RGBColor(256, 150, 50, 0.8))

#define kNavigaHight     64

// 菜单宽度
#define kMenuWidth      (kDeviceWidth*2/3)
// 遮挡视图的颜色
#define MASK_COLOR [UIColor lightGrayColor]
// 遮挡的最大透明度
#define MASK_MAX_ALPHA 0.5

//打印API
#define kMyLog(...)                NSLog(__VA_ARGS__)

//ip 地址 , ip 端口
#define IP_Address                  [[UserDefaultManager shareUserDefaultManager] getIPAddress]
#define IP_Port                        [[UserDefaultManager shareUserDefaultManager] getIPPort]
#define kEmployeeID              [[UserDefaultManager shareUserDefaultManager]getEmployeeID]


//图片数据接口
#define kImageUrl        [NSString stringWithFormat:@"http://%@:%@",IP_Address,IP_Port]

#define kBaseUrl           [NSString stringWithFormat:@"http://%@:%@/App",IP_Address,IP_Port]

//登录接口       拼接参数 loginName、password   post传递
//#define kRequestUrl(functionName)                  [NSString stringWithFormat:@"%@/%@",kBaseUrl,functionName]
#define kRequestUrl(functionName)                  [NSString stringWithFormat:@"%@/%@",kBaseUrl,functionName]




#endif /* Header_h */
