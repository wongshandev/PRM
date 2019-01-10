//
//  HttpClient.h
//  NetWork
//
//  Created by du on 2017/3/10.
//  Copyright © 2017年 du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject

+ (void)post:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

//+ (void)postHeader:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

//+ (void)postImageAndHeader:(UIImage *)image url:(NSString *)urlString success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+ (void)get:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObject))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

//上传多张图片
+(void)upLoadMoreImageWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters imageArray:(NSArray *)imageArray fileName:(NSString *)name progerss:(void (^)(id))progress success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//注册 不含 token
//+ (void)postRegisterHeader:(NSString *)urlString parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;


+ (void)downLoadFilesWithURLStringr:(NSURL *)URLString
                       progress:(void (^)(NSProgress *downloadProgress))progressBlock
                    destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
              completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

+(BOOL)isNetAvilable;
@end
