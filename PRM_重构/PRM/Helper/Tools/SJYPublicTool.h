//
//  SJYPublicTool.h
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AFNetworking.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJYPublicTool : NSObject
#pragma mark-------初始化

+ (instancetype)sharedInstance;
+ (BOOL)isNetworkEnable;
+ (UIWindow *)lastWindow;

#pragma mark-------UI相关
+ (NSString *)getPriceWithPrice:(NSString *)price;//小数位为0的话去除小数位，否则保留所有小数
//+ (UIImage *)getNotCommonImage:(NSString *)imageName;//通过路径方式添加不常用Image
+ (CGFloat )getNavHeight;//获取导航条高度 +10高度阴影
+ (CGFloat )getNomarlNavHeight;//获取正常导航条高度 不算阴影
+ (UIFont *)getFontWithSize:(CGFloat)size;
+ (CGFloat )getNumberWith:(CGFloat)num;
 
//判断是否全是空格
+ (BOOL)isEmpty:(NSString *) str;
//计算lable字体的长度
+(float)getWidthWithText:(NSString *)text font:(UIFont *)font;
//计算lable字体的高度
+(float)getTextHeightWithText:(NSString *)text LabelWidth:(float)width LabelFont:(float)font;
+(NSString *)getUserUUID;
@end

NS_ASSUME_NONNULL_END
