//
//  SJYRequestTool.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYRequestTool.h"




@implementation SJYRequestTool

+(void)loginInfoWithUserName:(NSString *)username passworld:(NSString *)password  complete:(void(^) ( id responder))complete {
     [RequestTool requestLoginInfoWithUserName:username passworld:password success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        complete(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@(NO) forKey:@"success"];
        [dic setValue:@"登录请求出错" forKey:@"infotype"];
        complete(dic);
    }];


}

@end
