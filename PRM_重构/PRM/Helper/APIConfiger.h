//
//  APIConfiger.h
//  PRM
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define IP_Address                 [[SJYDefaultManager shareManager] getIPAddress]
#define IP_Port                        [[SJYDefaultManager shareManager] getIPPort]
#define kEmployeeID              [[SJYDefaultManager shareManager] getEmployeeID]


@interface APIConfiger : NSObject
#define API_BaseUrl           [NSString stringWithFormat:@"http://%@:%@/App",IP_Address,IP_Port]
//图片数据接口
#define API_ImageUrl        [NSString stringWithFormat:@"http://%@:%@",IP_Address,IP_Port]
//请求接口       拼接参数 loginName、password   post传递
#define API_Request(functionName)                  [NSString stringWithFormat:@"%@/%@",API_BaseUrl,functionName]


#define API_Logion     API_Request(@"LogApp")                            // 登录





@end

NS_ASSUME_NONNULL_END
