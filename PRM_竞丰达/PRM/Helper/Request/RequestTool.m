//
//  RequestTool.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RequestTool.h"

@implementation RequestTool

+(void)checkUpdateWithAppID:(NSString *)appID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSString *api_update = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",appID];
    [HttpClient get:api_update parameters:nil success:success failure:failure];
}
//+(void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion ,NSString * newVersion , NSString * currentVersion))success failure:(void (^)(NSError *error))failure{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/json",@"text/javascript",nil];
//
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 15.0;//设置请求超时时间
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    //加上这行代码, https ssl 验证
//    [manager setSecurityPolicy: [self customSecurityPolicy]];
//
//    NSString *encodingUrl = [@"https://itunes.apple.com/cn/lookup?id=" stringByAppendingString:appID];
//    //@"http://itunes.apple.com/cn/lookup?id=1247751540"
//    [manager GET:encodingUrl parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//
//        NSDictionary *resultDic =  responseObject ;
//
//        //获取AppStore的版本号
//        NSString * versionStr = [[[resultDic objectForKey:@"results"]objectAtIndex:0 ] valueForKey:@"version"];
//
//        NSString *versionStr_int = [versionStr stringByReplacingOccurrencesOfString:@"."withString:@""];
//
//        int version = [versionStr_int intValue];
//
//        //获取本地的版本号
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//
//        NSString * currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
//
//        NSString *currentVersion_int = [currentVersion stringByReplacingOccurrencesOfString:@"."withString:@""];
//
//        int current = [currentVersion_int intValue];
//
//        if(version>current){
//            success(resultDic,YES, versionStr,currentVersion);
//        } else {
//            success(resultDic,NO ,versionStr,currentVersion);
//        }
//    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        failure(error);
//    }];
//
//}


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
    NSDictionary *params = @{
                             @"rows":@"20",
                             @"page":@(page),
                             @"EmployeeID":employID,
                             @"AEmp":[[SJYUserManager sharedInstance].sjyloginUC   modelToJSONString],
                             };
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
    NSDictionary *params = @{@"rows":@"20",@"page":@(page),@"PositionID":employID};
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
    //竞丰达 增加AEmp字段
    NSDictionary *params = @{
                             @"AEmp":[[SJYUserManager sharedInstance].sjyloginUC   modelToJSONString],
                             @"rows":@"20",
                             @"page":@(page),
                             @"SearchName":searchName,
                             @"SearchStateID":searchStateID,
                             @"SearchCode":searchCode};
    NSLog(@"%@",API_SJSHList);
    NSLog(@"%@",params);
    [HttpClient post:API_SJSHList parameters:params success:success failure:failure];
}

+(void)requestSJSHWithAPI:(NSString *)apiUrl  parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:apiUrl parameters:params success:success failure:failure]; 
}
#pragma mark ============= 工程分配
+(void)requestGCFPWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    //竞丰达 增加AEmp字段
    NSDictionary *params = @{
                             @"AEmp":[[SJYUserManager sharedInstance].sjyloginUC   modelToJSONString],
                             @"rows":@"20",
                             @"page":@(page)
                             };
    NSLog(@"%@",API_GCFPList);
    NSLog(@"%@",params);
    [HttpClient post:API_GCFPList parameters:params success:success failure:failure];
}
+(void)requestGCFPSubmit:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
     [HttpClient post:API_GCFPSave parameters:paradic success:success failure:failure];
}

#pragma mark ============== 采购审核
+(void)requestCGSHListWithSearchStateID:(NSInteger)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{

//    NSError *jsonError;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[[SJYUserManager sharedInstance].ucAemp  modelToJSONObject] options:NSJSONWritingPrettyPrinted error:&jsonError];
//    NSString *jsonStr = [[[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //竞丰达 增加AEmp字段
   NSDictionary *params = @{
                            @"rows":@"20",
                            @"page":@(page),
                            @"AEmp":[[SJYUserManager sharedInstance].ucAemp  modelToJSONString],
                            @"SearchStateID":@(searchStateID),
                            @"SearchCode":searchCode};

    NSLog(@"%@",API_CGSHList);
    NSLog(@"%@",params);
    [HttpClient post:API_CGSHList parameters:params success:success failure:failure];
}
+(void)requestCGSHSubmitWithParameters:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_CGSHSubmitList parameters:paradic success:success failure:failure];
}
#pragma mark ============== 入库评审
+(void)requestRKPSListWithSearchStateID:(NSInteger)searchStateID page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{

    NSDictionary *params = @{
                            @"rows":@"20",
                             @"page":@(page),
                             @"SearchStateID":@(searchStateID),
                             @"EmployeeID":KEmployID
                             };
    NSLog(@"%@",API_RKPSList);
    NSLog(@"%@",params);
    [HttpClient post:API_RKPSList parameters:params success:success failure:failure];
}
+(void)requestRKPSApprovelSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSLog(@"%@",API_RKPSSubmit);
    NSLog(@"%@",paradic);
    [HttpClient post:API_RKPSSubmit parameters:paradic success:success failure:failure];

}

#pragma mark ============== 项目开支
//SpendingTypeID开支类型：调用网站根目录下/Scripts/Json/SpendingType.json数据
+(void)requestXMKZSpendingTypeSuccess:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient get:API_XMKZSpendingType parameters:@{} success:success failure:failure];
}
+(void)requestXMKZListWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    BOOL isEqual = [[SJYUserManager sharedInstance].sjyloginUC.InquiryDpId isEqualToString:  [SJYUserManager sharedInstance].sjyloginUC.DepartmentID];
    NSDictionary *params = @{
                             @"rows":@"20",
                             @"page":@(page),
                             @"EmployeeID":KEmployID,
                             @"PositionID":KPositionID,
                             @"IsInquiryDpt": isEqual ? @"true":@"false"
                             };
    NSLog(@"%@",API_XMKZList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMKZList parameters:params success:success failure:failure];
}
+(void)requestXMKZDetialListWithProjectBranchID:(NSString *)projectBranchID Page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{
                             @"rows":@"20",
                             @"page":@(page),
                            @"ProjectBranchID":projectBranchID,
                             @"EmployeeID":KEmployID
                             };
    NSLog(@"%@",API_XMKZSecondList);
    NSLog(@"%@",params);
    [HttpClient post:API_XMKZSecondList parameters:params success:success failure:failure];
}
//+(void)requestXMKZDetialSaveWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
//    [HttpClient post:API_XMKZDetialAddSave parameters:paradic success:success failure:failure];
//}
+(void)requestXMKZDetialSaveWithParaDic:(NSDictionary *)paradic imageArray:(NSArray *)imgArray fileName:(NSString *)fileName progerss:(void (^)(id))progress  success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient upLoadMoreImageWithURLString:API_XMKZDetialAddSave parameters:paradic imageArray:imgArray fileName:fileName progerss:progress success:success failure:failure];
}

+(void)requestXMKZDetialSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_XMKZDetialSubmit parameters:paradic success:success failure:failure];
}
+(void)requestXMKZDetialDeleteWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    [HttpClient post:API_XMKZDetialDelete parameters:paradic success:success failure:failure];
}
#pragma mark ==============  开支审核
+(void)requestKZSHListWithSearchStateID:(NSInteger)searchStateID SearchSpendTypeID:(NSString *)searchSpendTypeID Page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{
                             @"rows":@"20",
                             @"page":@(page),
                             @"AEmp":[[SJYUserManager sharedInstance].ucAemp  modelToJSONString],
                             @"SearchSpendingTypeID":searchSpendTypeID,
                             @"SearchStateID":@(searchStateID)
                             };
    NSLog(@"%@",API_KZSHList);
    NSLog(@"%@",params);
    [HttpClient post:API_KZSHList parameters:params success:success failure:failure];
}
//开支审核 与项目开支提交接口相同仅参数不同
//+(void)requestXMKZDetialSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ==============  开支付款
+(void)requestKZFKListWithSearchStateID:(NSInteger)searchStateID  SearchSpendTypeID:(NSString *)searchSpendTypeID  Page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure{
    NSDictionary *params = @{
                             @"rows":@"20",
                             @"page":@(page),
                             @"AEmp":[[SJYUserManager sharedInstance].ucAemp  modelToJSONString],
                             @"SearchSpendingTypeID":searchSpendTypeID,
                             @"SearchStateID":@(searchStateID)
                             };
    NSLog(@"%@",API_KZFKList);
    NSLog(@"%@",params);
    [HttpClient post:API_KZFKList parameters:params success:success failure:failure];
}
//开支付款 与项目开支提交接口相同仅参数不同
//+(void)requestXMKZDetialSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

@end
