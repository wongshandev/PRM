//
//  SJYMacro.h
//  PRM
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 apple. All rights reserved.
//

#ifndef SJYMacro_h
#define SJYMacro_h

#define  DisplayName  [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"]

//屏幕尺寸
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds //获取屏幕尺寸
#define SCREEN_H SCREEN_BOUNDS.size.height//获取屏幕高度
#define SCREEN_W SCREEN_BOUNDS.size.width//获取屏幕宽度

#define IOS11 @available(iOS 11.0, *)
#define Weak_Self __weak typeof(self) weakSelf = self
#define NAVHEIGHT [SJYPublicTool getNomarlNavHeight]//获取导航条高度 //（+5高度阴影）不再增加
#define NAVNOMARLHEIGHT [SJYPublicTool getNomarlNavHeight]//获取正常导航条高度 不算阴影
#define kWindow [UIApplication sharedApplication].keyWindow



// 系统控件默认高度
#define kStatusBarHeight           ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kNavBarHeight              (44.f)
#define kTopStatusAndNavBarHeight  (kStatusBarHeight + kNavBarHeight)
#define kTabBarHeight              (49.f)


// 是否是 iphoneX
//依据屏幕分辨率 resolution
#define IS_iPhoneX_ByScreenResolution ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//根据状态栏高度判断
#define IS_iPhoneX_ByStatusBarHeight (([[UIApplication sharedApplication] statusBarFrame].size.height > 20)?YES:NO)
//依据屏幕尺寸
#define IS_iPhoneX_ByScreenSize (SCREEN_W == 375.f && SCREEN_H == 812.f)

#define kStatusBarAndNavigationBarHeight (IS_iPhoneX_ByScreenResolution ? 88.f : 64.f)

#define isHighterThanIPhone5  (SCREEN_H <= 568 ? NO : YES)



//图片名字
#define SJYCommonImage(imageName) [UIImage imageNamed:imageName]
#define SJYNotCommonImage(imageName) [SJYPublicTool getNotCommonImage:imageName]

//基于375屏宽 数字处理
#define SJYNUM(num)  [SJYPublicTool getNumberWith:num]



//字体大小
#define SJYFont(fsize)  [SJYPublicTool getFontWithSize:fsize]
//加粗字体显示
#define SJYBoldFont(size)      [UIFont boldSystemFontOfSize:size]

#define Font_ListTitle  [UIFont systemFontOfSize:15] //SJYFont(15)
#define Font_ListLeftCircle [UIFont systemFontOfSize:12]// SJYFont(12)
#define Font_ListOtherTxt [UIFont systemFontOfSize:13] //SJYFont(13)
#define Font_EqualWidth(sizeNum) [UIFont fontWithName:@"Helvetica Neue" size:sizeNum]//等宽数字
#define Font_System(sizeNum) [UIFont systemFontOfSize:sizeNum]


 
// 针对 block实现之前  外部时, 引用 @weakify(self)
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

// 针对 block实现中  内部时, 引用 @strongify(self)
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//提示框
#define SJYAlertShow(messageText,buttonName) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:(messageText) \
delegate:nil cancelButtonTitle:(buttonName) otherButtonTitles: nil];\
[alert show];



#define SJYCommonImage(imageName) [UIImage imageNamed:imageName]
//#define SJYNotCommonImage(imageName) [SJYPublicTool getNotCommonImage:imageName]




#ifdef DEBUG
#define NSLog(format , ...) NSLog((@"\n[***函数名:%s]\n" "[行号:%d]\n" format), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(format, ...)
#endif


#define LOGINDATAKEY @"LOGINDATAKEY"
#define LOGINMODELKEY @"LOGINMODELKEY"
#define SJYCACHEKEY @"DXCACHE"



typedef NS_ENUM(NSUInteger, JumpURL) {
    FileTransferEngineering  = 0, //工程  -- 交接确认；
    FileTransfer, //市场部 项目交接
    FileTransferDesign,//技术部 交接确认
    PurchaseOrderPay,//技术部 ----- 采购付款；
    Engineering,//施工管理
    Procurement, //现场收货
    ChangeOrders, //项目变更
    ProjectProcess, //项目进度
    MySpending, //我的报销
    MarketOrder,  // 工程部----项目请购
    ChangeOrdersApprove, //变更审核
    ProjectApproval,  //任务分配；
    EngineeringAssign, // 工程分配 
    DesignAllApprove// 技术部--- 设计审核 ；
};
#define kJumpURLGet [[NSArray alloc] initWithObjects:\
@"FileTransferEngineering",\
@"FileTransfer",\
@"FileTransferDesign",\
@"PurchaseOrderPay",\
@"Engineering",\
@"Procurement", \
@"ChangeOrders", \
@"ProjectProcess",\
@"MySpending",\
@"MarketOrder",\
@"ChangeOrdersApprove",\
@"ProjectApproval",\
@"EngineeringAssign",\
@"DesignAllApprove", nil]
// 枚举 to 字串
#define KJumpURLToString(type) ([kJumpURLGet objectAtIndex:type])
// 字串 to 枚举
#define KJumpURLToEnum(string) ([kJumpURLGet indexOfObject:string])






#endif /* SJYMacro_h */
