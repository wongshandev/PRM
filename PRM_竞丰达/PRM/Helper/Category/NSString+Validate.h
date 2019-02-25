//
//  NSString+Validate.h
//  ZhangWan
//
//  Created by du on 2017/6/21.
//  Copyright © 2017年 RYD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

/* 手机号校验*/
+ (BOOL)isAvailablePhoneNumber:(NSString *)str;

/* 身份证号校验*/
+ (BOOL)isAvailableIdCard:(NSString *)str;

/* 邮箱校验*/
+ (BOOL)isAvailableEmail:(NSString *)str;

/* 纯数字*/
+ (BOOL)isPureNumber:(NSString *)str;


+(NSString *)matchType:(NSString *)fileName;

+(NSString *)mimeTypeForFileAtPath:(NSString *)path;

+(NSString *)numberMoneyFormattor:(NSString *)number;
+(NSString *)numberSepFormattor:(NSString *)number;
+(NSString *)numberIntFormattor:(NSString *)number;

@end
