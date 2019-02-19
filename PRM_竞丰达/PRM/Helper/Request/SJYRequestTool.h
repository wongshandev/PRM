//
//  SJYRequestTool.h
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

typedef void(^Success)(id responder);
typedef void (^Failure)(int status,NSString *info);

@interface SJYRequestTool : NSObject

#pragma mark ==============登录
//登录
+(void)loginWithUserName:(NSString *)username passworld:(NSString *)password  complete:(void(^) ( id responder))complete;
+(void)loginInfoWithUserName:(NSString *)username passworld:(NSString *)password success:(void(^) (LoginModel * loginInfo))success failure:(void (^)(int status,NSString *info))failure;
#pragma mark ==============主界面功能结构树
// 主界面功能结构树
+(void)requestMainFunctionList:(NSString *)employID complete:(void(^) ( id responder))complete;


#pragma mark ============== 施工管理
//施工管理  Engineering:
+(void)requestSGGLListWithEmployId:(NSString *)employID page:(NSInteger)page  success:(Success)success failure:(Failure)failure;

// 进度汇报列表
+(void)requestJDHBListWithProjectBranchID:(NSString *)projectBranchID  success:(Success)success failure:(Failure)failure;

//进度汇报列表  更新
+(void)requestJDHBUpdateWithEmployeeID:(NSString *)employID updated:(NSString *)updateString success:(Success)success failure:(Failure)failure;

// 物料计划列表
+(void)requestWLJHListWithProjectBranchID:(NSString *)projectBranchID  success:(Success)success failure:(Failure)failure;

// 物料计划详情列表
+(void)requestWLJHDetialListWithProjectBranchID:(NSString *)projectBranchID MarketOrderID:(NSString *)marketOrderID success:(Success)success failure:(Failure)failure;

// 物料计划阶段详情 ----保存/ 提交
+(void)requestWLJHDetialSaveWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure;

+(void)requestWLJHDetialSubmitWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure;


#pragma mark ============== 现场收货
//现场收货Procurement:
+(void)requestXCSHList:(NSString *)employID page:(NSInteger)page success:(Success)success failure:(Failure)failure;
//列表项目的 收货记录列表
+(void)requestXCSHRecordList:(NSString *)projectBranchID success:(Success)success failure:(Failure)failure;
//列表项目的 收货记录详情列表
+(void)requestXCSHRecordDetialListWithRealID:(NSString *)realID SiteState:(NSString *)siteState success:(Success)success failure:(Failure)failure;
// 收获记录提交
+(void)requestXCSHRecordChangeWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure;


#pragma mark ============== 项目请购
+(void)requestXMQGList:(NSString *)employID  page:(NSInteger)page success:(Success)success failure:(Failure)failure;
+(void)requestXMQGWithMarketOrderID:(NSString *)marketOrderID success:(Success)success failure:(Failure)failure;
+(void)requestXMQGApprovelWithParam:(NSDictionary *)paramDic success:(Success)success failure:(Failure)failure;
#pragma mark ============== 项目变更
+(void)requestXMBGList:(NSString *)employID  page:(NSInteger)page SearchCode:(NSString *)searchCode  success:(Success)success failure:(Failure)failure;

+(void)requestXMBGDetialWithProjectBranchID:(NSString *)projectBranchID SearchCode:(NSString *)searchCode success:(Success)success failure:(Failure)failure;

#pragma mark ============== 变更审核
+(void)requestBGSHListWithEmployID:(NSString *)employID SearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(Success)success failure:(Failure)failure;
+(void)requestBGSHSubmitWithEmployID:(NSString *)employID ChangeOrderID:(NSString *)changeOrderID success:(Success)success failure:(Failure)failure;

#pragma mark =============   项目进度
+(void)requestXMJDListWithPage:(NSInteger)page success:(Success)success failure:(Failure)failure;
+(void)requestXMJDGanttDataWithProjectBranchID:(NSString *)projectBranchID success:(Success)success failure:(Failure)failure;

#pragma mark =============   项目交接
+(void)requestJJQRListWithAPIUrl:(NSString *)api EmployID:(NSString *)employID success:(Success)success failure:(Failure)failure;
+(void)requestJJQRFTInfoWithProjectBranchID:(NSString *)projectBranchID success:(Success)success failure:(Failure)failure;
//提交
+(void)requestJJQRRTFTInfoSubmitWithAPIUrl:(NSString *)api params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

#pragma mark =============   任务分配
+(void)requestRWFPList:(NSString *)employID  page:(NSInteger)page success:(Success)success failure:(Failure)failure;

+(void)requestRWFPPersonData:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure;
+(void)requestRWFPSubmit:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure;

#pragma mark ============= 采购付款
+(void)requestCGFKListWithPage:(NSInteger)page success:(Success)success failure:(Failure)failure;

+(void)requestCGFKInfoDataWithPurchaseOrderID:(NSString *)purchaseOrderID success:(Success)success failure:(Failure)failure;

+(void)requestCGFKAgreeReject:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure;

#pragma mark ============= 设计审核

+(void)requestSJSHListWithSearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode SearchName:(NSString *)searchName page:(NSInteger)page success:(Success)success failure:(Failure)failure;

//报价清单 /文件清单 / 工程进度
+(void)requestSJSHWithAPI:(NSString *)apiUrl  parameters:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

#pragma mark ============= 工程分配
+(void)requestGCFPWithPage:(NSInteger)page success:(Success)success failure:(Failure)failure;
+(void)requestGCFPSubmit:(NSDictionary *)paradic success:(Success)success failure:(Failure)failure;
#pragma mark ============== 采购审核
+(void)requestCGSHListWithSearchStateID:(NSInteger)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(Success)success failure:(Failure)failure;
+(void)requestCGSHSubmitWithParameters:(NSDictionary *)paradic  success:(Success)success failure:(Failure)failure;


@end


