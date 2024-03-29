//
//  RequestTool.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RequestTool.h"

@implementation RequestTool
//登录接口
+(void)requestLoginInfoWithUserName:(NSString *)username passworld:(NSString *)password success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"loginName":username,@"password":password};
    NSLog(@"%@",API_Logion);
    NSLog(@"%@",params);
    [HttpClient post:API_Logion parameters:params success:success failure:failure];
}
//主界面列表树
+(void)requestMainFunctionList:(NSString *)employID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"EmployeeID":employID };
    NSLog(@"%@",API_MainListShow);
    NSLog(@"%@",params);
    [HttpClient post:API_MainListShow parameters:params success:success failure:failure];
}
#pragma mark ============== 施工管理
//施工管理
+(void)requestSGGLListWithEmployId:(NSString *)employID  page:(NSInteger)page  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params =@{@"EmployeeID":employID} ;
    NSLog(@"%@",API_SSGLList);
    NSLog(@"%@",params);
    [HttpClient post:API_SSGLList parameters:params success:success failure:failure];
}
// 进度汇报列表
+(void)requestJDHBListWithProjectBranchID:(NSString *)projectBranchID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"ProjectBranchID":projectBranchID};
    NSLog(@"%@",API_Logion);
    NSLog(@"%@",params);
    [HttpClient post:API_JDHBList parameters:params success:success failure:failure];
}
//进度汇报更新
+(void)requestJDHBUpdateWithEmployeeID:(NSString *)employID updated:(NSString *)updateJsonString  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"EmployeeID":employID,@"updated":updateJsonString};
    NSLog(@"%@",API_Logion);
    NSLog(@"%@",params);
    [HttpClient post:API_JDHBSave parameters:params success:success failure:failure];
}
//物料计划列表
+(void)requestWLJHListWithProjectBranchID:(NSString *)projectBranchID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{
                             @"ProjectBranchID":projectBranchID,
                             @"IsMaintenance": @"false"
                             };
    NSLog(@"%@",API_Logion);
    NSLog(@"%@",params);
    [HttpClient post:API_WLJHList parameters:params success:success failure:failure];
}

//物料计划阶段详情列表
+(void)requestWLJHDetialListWithProjectBranchID:(NSString *)projectBranchID MarketOrderID:(NSString *)marketOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{
                             @"ProjectBranchID":projectBranchID,
                             @"MarketOrderID":marketOrderID
                             };
    NSLog(@"%@",API_Logion);
    NSLog(@"%@",params);
    [HttpClient post:API_WLJHDetialList parameters:params success:success failure:failure];
}
// 物料计划阶段详情 保存/ 提交
+(void)requestWLJHDetialSaveWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_WLJHDetialSave parameters:paramDic success:success failure:failure];
}

+(void)requestWLJHDetialSubmitWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_WLJHDetialSubmit parameters:paramDic success:success failure:failure];
}

#pragma mark ============== 现场收货

//现场收货
+(void)requestXCSHList:(NSString *)employID  page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"EmployeeID":employID};
    NSLog(@"%@",API_XCSHList);
    NSLog(@"%@",params);
    [HttpClient post:API_XCSHList parameters:params success:success failure:failure];
}
+(void)requestXCSHRecordList:(NSString *)projectBranchID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{
                             @"ProjectBranchID":projectBranchID,
                             @"IsMaintenance": @"false"
                             };
    NSLog(@"%@",API_XCSHListModelRecord);
    NSLog(@"%@",params);
    [HttpClient post:API_XCSHListModelRecord parameters:params success:success failure:failure];
}

+(void)requestXCSHRecordDetialListWithRealID:(NSString *)realID SiteState:(NSString *)siteState success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"RealID":realID,@"SiteState":siteState};
    NSLog(@"%@",API_XCSHRecordDetial);
    NSLog(@"%@",params);
    [HttpClient post:API_XCSHRecordDetial parameters:params success:success failure:failure];
}
+(void)requestXCSHRecordChangeWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSLog(@"%@",API_XCSHRecordChangeSubmit);
    NSLog(@"%@",paramDic);
    [HttpClient post:API_XCSHRecordChangeSubmit parameters:paramDic success:success failure:failure];
}

#pragma mark ============== 项目请购
+(void)requestXMQGList:(NSString *)employID  page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"EmployeeID":employID};
    NSLog(@"%@",API_XMQGList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMQGList parameters:params success:success failure:failure];
}

+(void)requestXMQGWithMarketOrderID:(NSString *)marketOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"MarketOrderID":marketOrderID};
    NSLog(@"%@",API_XMQGDetialList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMQGDetialList parameters:params success:success failure:failure];
}
+(void)requestXMQGApprovelWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSLog(@"%@",API_XMQGDetialShenHe);
    NSLog(@"%@",paramDic);
    [HttpClient post:API_XMQGDetialShenHe parameters:paramDic success:success failure:failure];

}
#pragma mark ============== 项目变更
+(void)requestXMBGList:(NSString *)employID  page:(NSInteger)page SearchCode:(NSString *)searchCode success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"EmployeeID":employID,@"SearchCode":searchCode};
    NSLog(@"%@",API_XMQGList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMBGList parameters:params success:success failure:failure];
}

+(void)requestXMBGDetialWithProjectBranchID:(NSString *)projectBranchID SearchCode:(NSString *)searchCode success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"ProjectBranchID":projectBranchID,@"SearchCode":searchCode};
    NSLog(@"%@",API_XMBGDetialList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMBGDetialList parameters:params success:success failure:failure];
}

#pragma mark ============== 变更审核
+(void)requestBGSHListWithEmployID:(NSString *)employID SearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"EmployeeID":employID,@"SearchStateID":searchStateID,@"SearchCode":searchCode};
    NSLog(@"%@",API_BGSHList);
    NSLog(@"%@",params);
    [HttpClient post:API_BGSHList parameters:params success:success failure:failure];
}

+(void)requestBGSHSubmitWithEmployID:(NSString *)employID ChangeOrderID:(NSString *)changeOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"EmployeeID":employID,@"ChangeOrderID":changeOrderID};
    NSLog(@"%@",API_BGSHSubmitList);
    NSLog(@"%@",params);
    [HttpClient post:API_BGSHSubmitList parameters:params success:success failure:failure];
}
#pragma mark =============   项目进度

+(void)requestXMJDListWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page)};
    NSLog(@"%@",API_XMJDList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMJDList parameters:params success:success failure:failure];
}
+(void)requestXMJDGanttDataWithProjectBranchID:(NSString *)projectBranchID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{ @"ProjectBranchID":projectBranchID};
    NSLog(@"%@",API_XMJDGanttData);
    NSLog(@"%@",params);
    [HttpClient post:API_XMJDGanttData parameters:params success:success failure:failure];
}
#pragma mark =============   交接 确认 

+(void)requestJJQRListWithAPIUrl:(NSString *)api EmployID:(NSString *)employID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{ @"EmployeeID":employID};
    NSLog(@"%@",api);
    NSLog(@"%@",params);
    [HttpClient post:api parameters:params success:success failure:failure];
}

+(void)requestJJQRFTInfoWithProjectBranchID:(NSString *)projectBranchID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{ @"ProjectBranchID":projectBranchID};
    NSLog(@"%@",API_JJQR_FTInfo);
    NSLog(@"%@",params);
    [HttpClient post:API_JJQR_FTInfo parameters:params success:success failure:failure];
}
//提交
+(void)requestJJQRRTFTInfoSubmitWithAPIUrl:(NSString *)api params:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSLog(@"%@",api);
    NSLog(@"%@",params);
    [HttpClient post:api parameters:params success:success failure:failure];
}

#pragma mark =============   任务分配
+(void)requestRWFPList:(NSString *)employID  page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"EmployeeID":employID};
    NSLog(@"%@",API_RWFPList);
    NSLog(@"%@",params);
    [HttpClient post:API_RWFPList parameters:params success:success failure:failure];
}

+(void)requestRWFPPersonData:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_RWFPPersonData parameters:paradic success:success failure:failure];
}
+(void)requestRWFPSubmit:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_RWFPSave parameters:paradic success:success failure:failure];
}

#pragma mark ============= 采购付款
+(void)requestCGFKListWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page)};
    NSLog(@"%@",API_CGFKList);
    NSLog(@"%@",params);
    [HttpClient post:API_CGFKList parameters:params success:success failure:failure];
}
+(void)requestCGFKInfoDataWithPurchaseOrderID:(NSString *)purchaseOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"PurchaseOrderID":purchaseOrderID};
    NSLog(@"%@",API_CGFKInfoData);
    NSLog(@"%@",params);
    [HttpClient post:API_CGFKInfoData parameters:params success:success failure:failure];
}
+(void)requestCGFKAgreeReject:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
  [HttpClient post:API_CGFKSubmit parameters:paradic success:success failure:failure];
}
#pragma mark ============= 设计审核

+(void)requestSJSHListWithSearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode SearchName:(NSString *)searchName page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"SearchName":searchName,@"SearchStateID":searchStateID,@"SearchCode":searchCode};
    NSLog(@"%@",API_SJSHList);
    NSLog(@"%@",params);
    [HttpClient post:API_SJSHList parameters:params success:success failure:failure];
}

+(void)requestSJSHWithAPI:(NSString *)apiUrl  parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:apiUrl parameters:params success:success failure:failure]; 
}

@end
