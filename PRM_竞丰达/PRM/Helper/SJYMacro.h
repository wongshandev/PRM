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

//抽屉宽度
#define MainDrawerWidth  SCREEN_W*0.85

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
#define SJYAlertShow(messageText,buttonName)\
UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:(messageText) preferredStyle:UIAlertControllerStyleAlert];\
[alertVC addAction: [UIAlertAction actionWithTitle:(buttonName) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {\
}]];\
[kWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//[alertVC addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];\


#define SJYCommonImage(imageName) [UIImage imageNamed:imageName]
//#define SJYNotCommonImage(imageName) [SJYPublicTool getNotCommonImage:imageName]




#ifdef DEBUG
#define NSLog(format , ...) NSLog((@"\n[***函数名:%s]\n" "[行号:%d]\n" format), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(format, ...)
#endif


#define LOGINUCMODELKEY @"LOGINUCMODELKEY"
#define LOGINMODELKEY @"LOGINMODELKEY"
#define SJYCACHEKEY @"DXCACHE"

#define LOGINUCKEY @"LOGINUCKEY"


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
    PurchaseApprove,//采购审核
    DesignAllApprove,// 技术部--- 设计审核 ；
    StockApprove,      // 入库评审
    SpendingPB,      // 项目开支
    SpendingApprove,
    Spending
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
@"PurchaseApprove",\
@"DesignAllApprove",\
@"StockApprove",\
@"SpendingPB",\
@"SpendingApprove",\
@"Spending",\
nil]
// 枚举 to 字串
#define KJumpURLToString(type) ([kJumpURLGet objectAtIndex:type])
// 字串 to 枚举
#define KJumpURLToEnum(string) ([kJumpURLGet indexOfObject:string])


typedef NS_ENUM(NSUInteger, StateCode) {
    StateCode_None = 0, //@""
    StateCode_JH = 1, // @"计划"
    StateCode_YTJ  = 2, // @"已提交"
    StateCode_YBH  = 3, // @"已驳回"
    StateCode_CWYS  = 4, //    @"财务已审",
    StateCode_ZJLYS  = 5, //    @"总经理已审",
    StateCode_DFK  = 6, //    @"待付款",
    StateCode_YFK  = 7, //    @"已付款",
    StateCode_YRK  = 8, //    @"已入库",
    StateCode_YFY  = 9, //    @"已发运",
    StateCode_JSZ  = 10, //    @"接收中",
    StateCode_YJH  = 11, //    @"已计划",
    StateCode_YSQ  = 12, //     @"已申请",
    StateCode_YSH  = 13, //    @"已审核",
    StateCode_YXD  = 14, //    @"已下单",
    StateCode_YCG  = 15, //    @"已采购" ,
    StateCode_YWC  = 16, //    @"已完成"
    StateCode_WSH  = 17, //    @"未审核"
    StateCode_YTG  = 18, //    @"已通过"
    StateCode_QQ  = 19, //    @"弃权"
    StateCode_ZGYS  = 20, //    @"主管已审"
};



static const NSArray *___StateTypeArray;
#define StateCodeStringArray (___StateTypeArray == nil ? ___StateTypeArray = [[NSArray alloc] initWithObjects:\
@"",\
@"计划",\
@"已提交",\
@"已驳回",\
@"财务已审",\
@"总经理已审",\
@"待付款",\
@"已付款",\
@"已入库",\
@"已发运",\
@"接收中",\
@"已计划",\
@"已申请",\
@"已审核",\
@"已下单",\
@"已采购" ,\
@"已完成",\
@"未审核",\
@"已通过",\
@"弃权",\
@"主管已审",\
nil] : ___StateTypeArray)
//@"未审核",@"已驳回",@"已通过",@"弃权"
//#define KStateCodeToString(index)         [StateCodeStringArray objectAtIndex:index]
//#define KStateStringToIndex(stateString)         [StateCodeStringArray indexOfObject:stateString]


static const NSArray *___StateColorArray;
#define StateCodeColorHexArray (___StateColorArray == nil ? ___StateColorArray = [[NSArray alloc] initWithObjects:\
UIColorHex(#007BD3),\
UIColorHex(#007BD3),\
UIColorHex(#007BD3),\
UIColorHex(#FF0000),\
UIColorHex(#FE6D4B),\
UIColorHex(#EF5362),\
UIColorHex(#F79746),\
UIColorHex(#3FD0AD),\
UIColorHex(#31BDF3),\
UIColorHex(#EE85C1),\
UIColorHex(#AC8FEF),\
UIColorHex(#FFCF47),\
UIColorHex(#5C4033),\
UIColorHex(#5A9AEF),\
UIColorHex(#527F76),\
UIColorHex(#2F4F4F),\
UIColorHex(#9FD661),\
UIColorHex(#5A9AEF),\
UIColorHex(#007BD3),\
UIColorHex(#FE6D4B),\
UIColorHex(#527F76),\
nil] : ___StateColorArray)

//#define KStateColorWithCode(code)         [StateCodeStringArray objectAtIndex:code]
//#define KStateColorWithString(stateString)     KStateColorWithCode(KStateStringToIndex(stateString))

//物料计划,项目请购,现场收货 
//#define  ListWLJHStateArray  @[@"",@"已计划",@"已申请",@"已驳回",@"已审核",@"已下单",@"已采购" ,@"已完成"]
//#define  ListXCSHStateArray  @[@"",@"已计划",@"已申请",@"已驳回",@"已审核",@"已下单",@"已采购",@"已完成"]
//#define  ListXMQGStateArray @[@"",@"已计划",@"已申请",@"已驳回",@"已审核",@"已下单",@"已采购" ,@"已完成"]

#endif /* SJYMacro_h */
