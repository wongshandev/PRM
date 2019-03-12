//
//  RequestTool.h
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestTool : NSObject
//登录
+(void)requestLoginInfoWithUserName:(NSString *)username passworld:(NSString *)password success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//主界面列表
+(void)requestMainFunctionList:(NSString *)employID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ============== 施工管理
 //施工管理列表
+(void)requestSGGLListWithEmployId:(NSString *)employID  page:(NSInteger)page  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
 //进度汇报列表
+(void)requestJDHBListWithProjectBranchID:(NSString *)projectBranchID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
 //进度汇报  ---- 更新 
+(void)requestJDHBUpdateWithEmployeeID:(NSString *)employID updated:(NSString *)updateString  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

// 物料计划列表
+(void)requestWLJHListWithProjectBranchID:(NSString *)projectBranchID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//物料计划阶段详情列表
+(void)requestWLJHDetialListWithProjectBranchID:(NSString *)projectBranchID MarketOrderID:(NSString *)marketOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

// 物料计划阶段详情 保存/ 提交
+(void)requestWLJHDetialSaveWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestWLJHDetialSubmitWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;


#pragma mark ============== 现场收货
//现场收货列表
+(void)requestXCSHList:(NSString *)employID  page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

//列表项目的 收货记录列表
+(void)requestXCSHRecordList:(NSString *)projectBranchID  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//列表项目的 收货记录详情列表
+(void)requestXCSHRecordDetialListWithRealID:(NSString *)realID SiteState:(NSString *)siteState success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;


+(void)requestXCSHRecordChangeWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
#pragma mark ============== 项目请购
+(void)requestXMQGList:(NSString *)employID  page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestXMQGWithMarketOrderID:(NSString *)marketOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestXMQGApprovelWithParam:(NSDictionary *)paramDic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;


#pragma mark ============== 项目变更
+(void)requestXMBGList:(NSString *)employID  page:(NSInteger)page SearchCode:(NSString *)searchCode success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+(void)requestXMBGDetialWithProjectBranchID:(NSString *)projectBranchID SearchCode:(NSString *)searchCode success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ============== 变更审核
+(void)requestBGSHListWithEmployID:(NSString *)employID SearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+(void)requestBGSHSubmitWithEmployID:(NSString *)employID ChangeOrderID:(NSString *)changeOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark =============   项目进度 
+(void)requestXMJDListWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+(void)requestXMJDGanttDataWithProjectBranchID:(NSString *)projectBranchID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark =============   交接 确认
+(void)requestJJQRListWithAPIUrl:(NSString *)api EmployID:(NSString *)employID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+(void)requestJJQRFTInfoWithProjectBranchID:(NSString *)projectBranchID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//提交
+(void)requestJJQRRTFTInfoSubmitWithAPIUrl:(NSString *)api params:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark =============   任务分配
+(void)requestRWFPList:(NSString *)employID  page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestRWFPPersonData:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+(void)requestRWFPSubmit:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ============= 采购付款
+(void)requestCGFKListWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestCGFKInfoDataWithPurchaseOrderID:(NSString *)purchaseOrderID success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure; 
+(void)requestCGFKAgreeReject:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ============= 设计审核

+(void)requestSJSHListWithSearchStateID:(NSString *)searchStateID  SearchCode:(NSString *)searchCode SearchName:(NSString *)searchName page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;


//报价清单 /文件清单 / 工程进度
+(void)requestSJSHWithAPI:(NSString *)apiUrl  parameters:(NSDictionary *)params success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ============= 工程分配
+(void)requestGCFPWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestGCFPSubmit:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ============== 采购审核
+(void)requestCGSHListWithSearchStateID:(NSInteger)searchStateID  SearchCode:(NSString *)searchCode page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestCGSHSubmitWithParameters:(NSDictionary *)paradic  success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
#pragma mark ============== 入库评审
+(void)requestRKPSListWithSearchStateID:(NSInteger)searchStateID page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestRKPSApprovelSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
#pragma mark ============== 项目开支
//SpendingTypeID开支类型：调用网站根目录下/Scripts/Json/SpendingType.json数据
+(void)requestXMKZSpendingTypeSuccess:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure; 
+(void)requestXMKZListWithPage:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestXMKZDetialListWithProjectBranchID:(NSString *)projectBranchID Page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//+(void)requestXMKZDetialSaveWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestXMKZDetialSaveWithParaDic:(NSDictionary *)paradic imageArray:(NSArray *)imgArray fileName:(NSString *)fileName progerss:(void (^)(id))progress  success:(void (^) (NSURLSessionDataTask *dataTask,id responseObjcet))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

+(void)requestXMKZDetialSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
+(void)requestXMKZDetialDeleteWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
#pragma mark ==============  开支审核
+(void)requestKZSHListWithSearchStateID:(NSInteger)searchStateID SearchSpendTypeID:(NSString *)searchSpendTypeID Page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//开支审核 与项目开支提交接口相同仅参数不同
//+(void)requestXMKZDetialSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;

#pragma mark ==============  开支付款
+(void)requestKZFKListWithSearchStateID:(NSInteger)searchStateID  SearchSpendTypeID:(NSString *)searchSpendTypeID  Page:(NSInteger)page success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
//开支付款 与项目开支提交接口相同仅参数不同
//+(void)requestXMKZDetialSubmitWithParaDic:(NSDictionary *)paradic success:(void (^) (NSURLSessionDataTask *dataTask, id responseObjcet ))success failure:(void (^)(NSURLSessionDataTask *dataTask,NSError *error))failure;



@end

 
