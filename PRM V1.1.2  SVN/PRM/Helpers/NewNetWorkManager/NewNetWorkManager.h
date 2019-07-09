//
//  NewNetWorkManager.h
//  WeiLv
//
//  Created by lanouhn on 16/6/27.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface NewNetWorkManager : NSObject
//GET请求
/**
 *  @param urlStr   数据请求接口地址
 *  @param dic       接口请求数据参数
 *  @param finish   数据请求成功回调
 *  @param conError 数据请求失败回调
 */
+(void)requestGETWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responder))finish conError:(void (^)(NSError *error))conError;

//POST请求
//GET请求
/**
 *  @param urlStr   数据请求接口地址
 *  @param dic       接口请求数据参数
 *  @param finish   数据请求成功回调
 *  @param conError 数据请求失败回调
 */
+(void)requestPOSTWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responder))finish conError:(void (^)(NSError *error))conError;

// 字符串请求
+(void)requestJSONStringDataPostWith:(NSString *)urlStr parStr:(NSString *)parmStr finish:(void(^)(NSURLResponse *responder,NSString *RespStr,id respond))finish conError:(void (^)(NSError *error))conError;

// 下载
+ (void)downLoadFilesWithUrlStr:(NSURL *)urlStr
                       progress:(void (^)(NSProgress *downloadProgress))progressBlock
                    destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
              completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


@end
