//
//  RequestTool.h
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestTool : NSObject

+(void)requestLoginInfoWithUserName:(NSString *)username passworld:(NSString *)password success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;


@end

 
