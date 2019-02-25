//
//  NSString+Validate.m
//  ZhangWan
//
//  Created by du on 2017/6/21.
//  Copyright © 2017年 RYD. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

/* 手机号校验*/
+ (BOOL)isAvailablePhoneNumber:(NSString *)str{
    if(str.length == 0) return NO;
    NSString *pattern = @"^1+[34578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/* 身份证号校验*/
+ (BOOL)isAvailableIdCard:(NSString *)str{
    if (str.length == 0) return NO;
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/* 邮箱校验*/
+ (BOOL)isAvailableEmail:(NSString *)str{
    if (str.length == 0) return NO;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:str];
    return isMatch;
}

/* 纯数字*/
+ (BOOL)isPureNumber:(NSString *)str{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

+(NSString *)matchType:(NSString *)fileName{
    // 后缀获取
    NSString *suffix = @"";
    // 获取类型结果
    NSString * result = @"";
    if (fileName.length !=0 && [fileName containsString:@"."] ) {
        suffix =  [fileName componentsSeparatedByString:@"."].lastObject;
    }else{
        suffix = nil;
        result = @"nofile";
        return result;
    }
    // 图片格式
    NSArray * imglist = @[@"png", @"jpg", @"jpeg", @"bmp", @"gif"];
    if ([imglist containsObject:suffix]) {
        result = @"image";
        return result;
    }

    // 匹配txt
    NSArray * txtlist = @[@"txt"];
    if ([txtlist containsObject: suffix]) {
        result = @"txt";
        return result;
    };

    // 匹配 excel
    NSArray * excelist = @[@"xls",@"xlsx"];

    if  ([excelist containsObject: suffix]){
        result = @"excel";
        return result;
    };
    // 匹配 word
    NSArray * wordlist = @[@"doc", @"docx"];

    if ([wordlist containsObject: suffix]) {
        result = @"word";
        return result;
    };
    // 匹配 pdf
    NSArray * pdflist = @[@"pdf"];

    if ([pdflist containsObject: suffix]) {
        result = @"pdf";
        return result;
    };
    // 匹配 ppt
    NSArray * pptlist = @[@"ppt"];

    if ([pptlist containsObject: suffix]) {
        result = @"ppt";
        return result;
    };
    // 匹配 视频
    NSArray * videolist = @[@"mp4", @"m2v", @"mkv"];

    if ([videolist containsObject: suffix]) {
        result = @"video";
        return result;
    };
    // 匹配 音频
    NSArray * radiolist = @[@"mp3", @"wav", @"wmv"];

    if ([radiolist containsObject: suffix]) {
        result = @"radio";
        return result;
    }

    NSArray * ziplist = @[@"zip"];

    if ([ziplist containsObject: suffix]) {
        result = @"zip";
        return result;
    }
    NSArray * rarlist = @[ @"rar"];
    if ([rarlist containsObject: suffix]) {
        result = @"rar";
        return result;
    }
    // 其他 文件类型
    result = @"otherfile";
    return result;
}


//path为要获取MIMEType的文件路径
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

+(NSString *)numberMoneyFormattor:(NSString *)number{
    if (number.length==0) {
         return @"";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;    //设置最大小数点后的位数
    formatter.minimumFractionDigits = 2;

     NSNumber *result111 = [NSNumber numberWithDouble:number.doubleValue];
    NSString *string = [formatter stringFromNumber:result111];
    return string;
}
+(NSString *)numberSepFormattor:(NSString *)number{
    if (number.length==0) {
         return @"";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;    //设置最大小数点后的位数
    formatter.minimumFractionDigits = 2;
    NSNumber *result111 = [NSNumber numberWithDouble:number.doubleValue];
    NSString *string = [formatter stringFromNumber:result111];
    return string;
}
+(NSString *)numberIntFormattor:(NSString *)number{
    if (number.length==0) {
        return @"";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 0;    //设置最大小数点后的位数
    formatter.minimumFractionDigits = 0;
    NSNumber *result111 = [NSNumber numberWithDouble:number.doubleValue];
    NSString *string = [formatter stringFromNumber:result111];
    return string;
}
@end
