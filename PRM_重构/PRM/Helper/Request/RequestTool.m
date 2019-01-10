//
//  RequestTool.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RequestTool.h"

@implementation RequestTool

+(void)requestLoginInfoWithUserName:(NSString *)username passworld:(NSString *)password success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"loginName":username,@"password":password};
    [HttpClient post:API_Logion parameters:params success:success failure:failure];
}

@end
