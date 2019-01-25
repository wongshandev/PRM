//
//  HttpClient.m
//  NetWork
//
//  Created by du on 2017/3/10.
//  Copyright © 2017年 du. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking.h>
#import <AFURLRequestSerialization.h>

static NSUInteger const kRequestTimeOut = 15;

@implementation HttpClient
#define DEVICE_COOKIE @"DEVICE_COOKIE"

#define SET_COOKIE     NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];\
NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];\
[[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:DEVICE_COOKIE];\
[[NSUserDefaults standardUserDefaults] synchronize];\

+ (void)post:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    if (![self isNetAvilable]) {
        [QMUITips hideAllTips];
//        SJYAlertShow(@"当前网络不可用,请检查网络", @"确定");
        [self alertView];
//
        return;
    }
    NSLog(@"当前请求:%@\n,参数:%@",urlString,params);
    AFHTTPSessionManager * manager = [self createSessionManager];

    [manager POST:urlString parameters:params progress:nil success:success failure:failure];
}

//+ (void)postHeader:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    //设置通讯格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",@"text/javascript",nil];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setTimeoutInterval:kRequestTimeOut];
//
////    [manager.requestSerializer setValue:PN forHTTPHeaderField:@"pn"];
////    [manager.requestSerializer setValue:PK forHTTPHeaderField:@"pk"];
////    [manager.requestSerializer setValue:ACCESS_TOKEN forHTTPHeaderField:@"access_token"];//@"7sdhfksdfiosfsDF0812465461545745"
//
//    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:DEVICE_COOKIE];
//    if (data.length != 0) {
//        NSArray *cookieArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in cookieArray) {
//            NSLog(@"HttpClientCookie:%@",cookie);
//            [cookieStorage setCookie:cookie];
//        }
//    }
//    NSLog(@"当前请求:%@\n,参数:%@",urlString,params);
//    [manager POST:urlString parameters:params progress:nil success:success failure:failure];
//}

//+ (void)postImageAndHeader:(UIImage *)image url:(NSString *)urlString success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
////    [manager.requestSerializer setValue:PN forHTTPHeaderField:@"pn"];
////    [manager.requestSerializer setValue:PK forHTTPHeaderField:@"pk"];
////    [manager.requestSerializer setValue:ACCESS_TOKEN forHTTPHeaderField:@"access_token"];//@"7sdhfksdfiosfsDF0812465461545745"
//
//    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_COOKIE];
//    if (data.length != 0) {
//        NSArray *cookieArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in cookieArray) {
//            NSLog(@"HttpClientCookie:%@",cookie);
//            [cookieStorage setCookie:cookie];
//        }
//    }
//    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if(image == nil) return;
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy年MM月dd日"];
//        NSString *dateString = [formatter stringFromDate:date];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png",dateString];
//
//        //NSData *imageData = [UIImage lubanCompressImage:image];
//        NSData *imageData = UIImageJPEGRepresentation(image, 1);
//        //NSData * imageData = UIImagePNGRepresentation(image);
//
//        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"userAvatar"] fileName:fileName mimeType:@"image/png"];
//    } progress:nil success:success failure:failure];
//}

+ (void)get:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObject))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    if (![self isNetAvilable]) {
        [QMUITips hideAllTips];
//        SJYAlertShow(@"当前网络不可用,请检查网络", @"确定");
        [self alertView];

        return;
    }
    AFHTTPSessionManager * manager = [self createSessionManager];
    [manager GET:urlString parameters:params progress:nil success:success failure:failure];
}

+(void)upLoadMoreImageWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters imageArray:(NSArray *)imageArray fileName:(NSString *)name progerss:(void (^)(id))progress success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    if (![self isNetAvilable]) {
        [QMUITips hideAllTips];
//        SJYAlertShow(@"当前网络不可用,请检查网络", @"确定");
        [self alertView];

        return;
    }

    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置通讯格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",@"text/javascript",nil];
    //    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //    manager.requestSerializer.timeoutInterval = 30;
    //    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //    //添加HTTPHeader
    //    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"os"];
    //    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //
    //    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_COOKIE];
    //    if (data.length != 0) {
    //        NSArray *cookieArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //        for (NSHTTPCookie *cookie in cookieArray) {
    //            NSLog(@"HttpClientCookie:%@",cookie);
    //            [cookieStorage setCookie:cookie];
    //        }
    //    }
 
    AFHTTPSessionManager * manager = [self createSessionManager];
    //添加HTTPHeader
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"os"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //加上这行代码, https ssl 验证
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    NSURLSessionDataTask *uploadTask =  [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArray.count; i ++) {
            UIImage *image = imageArray[i];
            //旋转图片
            UIImage *normalizedImage = [[self class] normalizedImageWithOriginalImage:image];
            CGFloat compressRatio = 0.5;
            NSLog(@"压缩比例:%lf", compressRatio);
            NSData *imageData = UIImageJPEGRepresentation(normalizedImage, compressRatio);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@%d",dateString,i]];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@[]",name] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:progress success:success  failure:failure];
    [uploadTask resume];
}
+(void)uploadFileWithUrl:(NSString *)url paradic:(NSDictionary *)paradic   filePath:(NSString *)filepath progress:(void(^)(NSProgress * uploadProgress))progress   success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    if (![self isNetAvilable]) {
        [QMUITips hideAllTips];
         [self alertView];
        return;
    }
    AFHTTPSessionManager *sharedManager1 = [[AFHTTPSessionManager alloc]init];
    sharedManager1.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    [sharedManager1 POST:url parameters:paradic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = [NSData dataWithContentsOfFile:filepath];
        NSString *mimeType =[NSString mimeTypeForFileAtPath:filepath];
        NSString *fileName =  [filepath.lastPathComponent componentsSeparatedByString:@"."].lastObject;
        [formData appendPartWithFileData:data
                                    name:[filepath.lastPathComponent componentsSeparatedByString:@"."].firstObject
                                fileName:filepath.lastPathComponent
                                mimeType:[NSString mimeTypeForFileAtPath:filepath]];
    } progress:progress   success:success  failure:failure];
    //        //上传数据:FileData-->data  name-->fileName(固定，和服务器一致)  fileName-->你的语音文件名  mimeType-->我的语音文件type是audio/amr 如果你是图片可能为image/jpeg
 }

//+ (void)postRegisterHeader:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//     //设置通讯格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",@"text/javascript",nil];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setTimeoutInterval:kRequestTimeOut];
//
//
//    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:DEVICE_COOKIE];
//    if (data.length != 0) {
//        NSArray *cookieArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in cookieArray) {
//            NSLog(@"HttpClientCookie:%@",cookie);
//            [cookieStorage setCookie:cookie];
//        }
//    }
//    NSLog(@"当前请求:%@\n,参数:%@",urlString,params);
//    [manager POST:urlString parameters:params progress:nil success:success failure:failure];
//}



/**
 旋转图片方向朝上
 
 @param originalImage 原始图片
 @return 旋转后的图片
 */
+ (UIImage *)normalizedImageWithOriginalImage:(UIImage *)originalImage {
    if (originalImage.imageOrientation == UIImageOrientationUp) return originalImage;
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
    [originalImage drawInRect:(CGRect){0, 0, originalImage.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}




+ (void)downLoadFilesWithURLStringr:(NSURL *)URLString
                           progress:(void (^)(NSProgress *downloadProgress))progressBlock
                        destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    if (![self isNetAvilable]) {
        [QMUITips hideAllTips];
         [self alertView];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:URLString];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return    destination(targetPath,response);
        /*        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
         //        NSLog(@"targetPath:%@",targetPath);
         //        NSLog(@"fullPath:%@",fullPath);
         //        return [NSURL fileURLWithPath:fullPath];
         */
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response,filePath,error);
    }];
    [task resume];
}

+(BOOL)isNetAvilable{
    BOOL bEnabled = FALSE;
    NSString *url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    CFRelease(ref);
    if (bEnabled) {
        //        kSCNetworkReachabilityFlagsReachable：能够连接网络
        //        kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
        //        kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }
    return bEnabled;
}

+ (AFHTTPSessionManager *)createSessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置通讯格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",@"text/javascript",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:kRequestTimeOut];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;

    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;

    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:DEVICE_COOKIE];
    if (data.length != 0) {
        NSArray *cookieArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArray) {
            NSLog(@"HttpClientCookie:%@",cookie);
            [cookieStorage setCookie:cookie];
        }
    }
    return manager;
}

+(void)alertView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用,请检查网络" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToAppSystemSetting];
    }]];
    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
+(void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}
@end
