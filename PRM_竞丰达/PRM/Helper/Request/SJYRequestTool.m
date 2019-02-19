//
//  SJYRequestTool.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYRequestTool.h"
#import "LoginModel.h"



@implementation SJYRequestTool

//登录
+(void)loginInfoWithUserName:(NSString *)username passworld:(NSString *)password  complete:(void(^) ( id responder))complete {
    [RequestTool requestLoginInfoWithUserName:username passworld:password success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        complete(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@(NO) forKey:@"success"];
        //        [dic setValue:@"登录请求出错" forKey:@"infotype"];
        [dic setValue:error.localizedDescription  forKey:@"infotype"]; 
        
        complete(dic);
    }];
}

+(void)loginInfoWithUserName:(NSString *)username passworld:(NSString *)password success:(void(^) (LoginModel * loginInfo))success failure:(void (^)(int status,NSString *info))failure{
    [RequestTool requestLoginInfoWithUserName:username passworld:password success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        NSString *string =  [[NSString alloc]initWithData:(NSData *)responseObjcet encoding:NSUTF8StringEncoding];
        NSLog(@"HttpClientResponseObject-->%@",string);
        LoginModel *model = [LoginModel modelWithJSON:string];
        if (model) {
            if (model.success ==  YES ) {
                success(model);
            }
            else{
                failure(-1,@"用户名或密码错误");
            }
        }
        else{
            failure(-1,@"JSON解析错误");
            NSLog(@"JSON解析错误");
        }
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

+(void)loginWithUserName:(NSString *)username passworld:(NSString *)password  complete:(void(^) ( id responder))complete {
    [RequestTool requestLoginInfoWithUserName:username passworld:password success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        complete(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@(NO) forKey:@"success"];
        //        [dic setValue:@"登录请求出错" forKey:@"infotype"];
        [dic setValue:error.localizedDescription  forKey:@"infotype"];
        
        complete(dic);
    }];
}

// 主界面功能结构树
+(void)requestMainFunctionList:(NSString *)employID complete:(void(^) ( id responder))complete{
    [RequestTool requestMainFunctionList:employID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        complete(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@(NO) forKey:@"success"];
        //        [dic setValue:@"登录请求出错" forKey:@"infotype"];
        [dic setValue:error.localizedDescription  forKey:@"infotype"];
    }];
}
#pragma mark ============== 施工管理

//施工管理
+(void)requestSGGLListWithEmployId:(NSString *)employID page:(NSInteger)page  success:(Success)success failure:(Failure)failure{
    [RequestTool requestSGGLListWithEmployId:employID page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

//进度汇报
+(void)requestJDHBListWithProjectBranchID:(NSString *)projectBranchID  success:(Success)success failure:(Failure)failure{
    [RequestTool requestJDHBListWithProjectBranchID:projectBranchID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
//进度汇报列表  更新
+(void)requestJDHBUpdateWithEmployeeID:(NSString *)employID updated:(NSString *)updateString success:(Success)success failure:(Failure)failure{
    [RequestTool requestJDHBUpdateWithEmployeeID:employID updated:updateString success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}


//物料计划列表
+(void)requestWLJHListWithProjectBranchID:(NSString *)projectBranchID  success:(Success)success failure:(Failure)failure{
    [RequestTool requestWLJHListWithProjectBranchID:projectBranchID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}


// 物料计划详情列表
+(void)requestWLJHDetialListWithProjectBranchID:(NSString *)projectBranchID MarketOrderID:(NSString *)marketOrderID success:(Success)success failure:(Failure)failure{
    [RequestTool requestWLJHDetialListWithProjectBranchID:projectBranchID MarketOrderID:marketOrderID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

// 物料计划详情
//保存
+(void)requestWLJHDetialSaveWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure{
    [RequestTool requestWLJHDetialSaveWithParam:paramDic  success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
// 提交
+(void)requestWLJHDetialSubmitWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure{
    [RequestTool requestWLJHDetialSubmitWithParam:paramDic  success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

#pragma mark ============== 现场收货

//现场收货
+(void)requestXCSHList:(NSString *)employID page:(NSInteger)page  success:(Success)success failure:(Failure)failure{
    [RequestTool requestXCSHList:employID page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
//列表项目的 收货记录列表
+(void)requestXCSHRecordList:(NSString *)projectBranchID success:(Success)success failure:(Failure)failure{
    [RequestTool requestXCSHRecordList:projectBranchID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
//列表项目的 收货记录详情列表
+(void)requestXCSHRecordDetialListWithRealID:(NSString *)realID SiteState:(NSString *)siteState success:(Success)success failure:(Failure)failure{
    [RequestTool requestXCSHRecordDetialListWithRealID:realID SiteState:siteState success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
// 收获记录提交
+(void)requestXCSHRecordChangeWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure{
    [RequestTool requestXCSHRecordChangeWithParam:paramDic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark ============== 项目请购

+(void)requestXMQGList:(NSString *)employID  page:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMQGList:employID page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestXMQGWithMarketOrderID:(NSString *)marketOrderID success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMQGWithMarketOrderID:marketOrderID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

+(void)requestXMQGApprovelWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMQGApprovelWithParam:paramDic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestXMBGList:(NSString *)employID  page:(NSInteger)page SearchCode:(NSString *)searchCode  success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMBGList:employID page:page SearchCode:searchCode success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

+(void)requestXMBGDetialWithProjectBranchID:(NSString *)projectBranchID SearchCode:(NSString *)searchCode success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMBGDetialWithProjectBranchID: projectBranchID SearchCode:searchCode success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark ============== 变更审核

+(void)requestBGSHListWithEmployID:(NSString *)employID SearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestBGSHListWithEmployID:employID SearchStateID:searchStateID SearchCode:searchCode page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestBGSHSubmitWithEmployID:(NSString *)employID ChangeOrderID:(NSString *)changeOrderID success:(Success)success failure:(Failure)failure{
    [RequestTool requestBGSHSubmitWithEmployID:employID ChangeOrderID:changeOrderID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

#pragma mark =============   项目进度
+(void)requestXMJDListWithPage:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMJDListWithPage:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestXMJDGanttDataWithProjectBranchID:(NSString *)projectBranchID success:(Success)success failure:(Failure)failure{
    [RequestTool requestXMJDGanttDataWithProjectBranchID:projectBranchID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) { 
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

#pragma mark =============   项目交接
+(void)requestJJQRListWithAPIUrl:(NSString *)api EmployID:(NSString *)employID success:(Success)success failure:(Failure)failure{
    [RequestTool requestJJQRListWithAPIUrl:api EmployID:employID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestJJQRFTInfoWithProjectBranchID:(NSString *)projectBranchID success:(Success)success failure:(Failure)failure{
    [RequestTool requestJJQRFTInfoWithProjectBranchID:projectBranchID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestJJQRRTFTInfoSubmitWithAPIUrl:(NSString *)api params:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
    [RequestTool requestJJQRRTFTInfoSubmitWithAPIUrl:api params:params success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark =============   任务分配

+(void)requestRWFPList:(NSString *)employID  page:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestRWFPList:employID page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) { 
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

+(void)requestRWFPPersonData:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure{
    [RequestTool requestRWFPPersonData:paradic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestRWFPSubmit:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure{
    [RequestTool requestRWFPSubmit:paradic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark ============= 采购付款
+(void)requestCGFKListWithPage:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestCGFKListWithPage:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}

+(void)requestCGFKInfoDataWithPurchaseOrderID:(NSString *)purchaseOrderID success:(Success)success failure:(Failure)failure{
    [RequestTool requestCGFKInfoDataWithPurchaseOrderID:purchaseOrderID success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestCGFKAgreeReject:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure{
    [RequestTool requestCGFKAgreeReject:paradic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark ============= 设计审核

+(void)requestSJSHListWithSearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode SearchName:(NSString *)searchName page:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestSJSHListWithSearchStateID:searchStateID SearchCode:searchCode SearchName:searchName page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
//报价清单 /文件清单 / 工程进度
+(void)requestSJSHWithAPI:(NSString *)apiUrl  parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
    [RequestTool requestSJSHWithAPI:apiUrl  parameters:params success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark ============= 工程分配
+(void)requestGCFPWithPage:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestGCFPWithPage:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestGCFPSubmit:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure{
    [RequestTool requestGCFPSubmit:paradic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
#pragma mark ============== 采购审核
+(void)requestCGSHListWithSearchStateID:(NSInteger)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(Success)success failure:(Failure)failure{
    [RequestTool requestCGSHListWithSearchStateID:searchStateID  SearchCode:searchCode page:page success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
+(void)requestCGSHSubmitWithParameters:(NSDictionary *)paradic  success:(Success)success failure:(Failure)failure{
    [RequestTool requestCGSHSubmitWithParameters:paradic success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        id  respond = [NSJSONSerialization  JSONObjectWithData:responseObjcet options:0 error:nil];
        success(respond);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            failure(-1,@"请求失败");
        } else{
            failure(-1,@"网络异常,请检查您的网络状况");
        }
    }];
}
@end
