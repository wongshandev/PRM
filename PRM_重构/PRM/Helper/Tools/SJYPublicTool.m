//
//  SJYPublicTool.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYPublicTool.h"

@interface SJYPublicTool ()

@end

static SJYPublicTool *sharedInstance=nil;
//static YYCache *cache=nil;
static AFHTTPSessionManager *_mgr;


@implementation SJYPublicTool
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
 
+(BOOL)isNetworkEnable
{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    BOOL net;
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = YES;
            break;

        case ReachableViaWWAN:
            net = YES;
            break;

        case NotReachable:
            net = NO;

        default:
            break;
    }

    return net;
}

//+ (UIImage *)getNotCommonImage:(NSString *)imageName{
//    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    return image;
//}

+ (CGFloat )getNavHeight{
    //判断机型
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        return 84.f+SJYNUM(5);
    }else {
        return 64.f+SJYNUM(5);
    }
}

+ (CGFloat )getNomarlNavHeight{
    //判断机型
    if (SCREEN_H == 812) {
        return 84.f;
    }else {
        return 64.f;
    }
//     [UIApplication sharedApplication].statusBarFrame.size.height
}

+ (UIFont *)getFontWithSize:(CGFloat)size{
    CGFloat bili=size/375;
    //UIFont *font=[UIFont fontWithName:@"MicrosoftYaHei" size:bili*SCREEN_WIDTH];
    UIFont *font=[UIFont systemFontOfSize:bili*SCREEN_W];
    return font;
}

+ (CGFloat)getNumberWith:(CGFloat)num{
    CGFloat bili=num/375;
    CGFloat current= bili*SCREEN_W;
    return current;
}

+ (NSString *)getPriceWithPrice:(NSString *)price{
    NSString * p=price;
    float pri=p.floatValue;
    int currentP=floorf(pri);

    if (pri>currentP) {
        return p;
    }
    else{
        NSString * m=[NSString stringWithFormat:@"%d",currentP];
        return m;
    }
}

//判断是否全是空格
+ (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
+ (UIWindow *)lastWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;

        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }

    return nil;
}

//计算lable字体的长度
+(float)getWidthWithText:(NSString *)text font:(UIFont *)font{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(SCREEN_W, MAXFLOAT);
    // 计算文字占据的宽度
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size.width;
}

//计算lable字体的高度
+(float)getTextHeightWithText:(NSString *)text LabelWidth:(float)width LabelFont:(float)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //paraStyle.alignment = NSTextAlignmentLeft;

    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    // 计算文字占据的高度  NSStringDrawingUsesLineFragmentOrigin
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    return size.height+SJYNUM(5);
}
+(NSString *)getUserUUID{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.Joinup.PRM" accessGroup:nil];
    NSString *UUIDString = [wrapper objectForKey:(__bridge id)kSecValueData];
    if (UUIDString.length == 0) {
        UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [wrapper setObject:UUIDString forKey:(__bridge id)kSecValueData];
    }
    NSLog(@"%@", UUIDString);
    return UUIDString;
}
@end
