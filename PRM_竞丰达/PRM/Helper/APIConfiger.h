//
//  APIConfiger.h
//  PRM
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define IP_Address           [[SJYDefaultManager shareManager] getIPAddress]
#define IP_Port                  [[SJYDefaultManager shareManager] getIPPort]
#define kEmployeeID        [[SJYDefaultManager shareManager] getEmployeeID]

#define KEmployID            [SJYUserManager sharedInstance].sjyloginData.Id
#define KPositionID            [SJYUserManager sharedInstance].sjyloginData.PositionID

@interface APIConfiger : NSObject
#define API_BaseUrl                             [NSString stringWithFormat:@"http://%@:%@/App",IP_Address,IP_Port]
//图片数据接口
#define API_ImageUrl                            [NSString stringWithFormat:@"http://%@:%@",IP_Address,IP_Port]
//请求接口       拼接参数 loginName、password   post传递
#define API_Request(functionName)    [NSString stringWithFormat:@"%@/%@",API_BaseUrl,functionName]

#define API_RootUrl(functionName)    [NSString stringWithFormat:@"%@%@",API_ImageUrl,functionName]


  // 登录
#define API_Logion                          API_Request(@"LogApp")
 //主界面权限块列表
#define API_MainListShow             API_Request(@"FunctionListShow")



//施工管理
#define API_SSGLList                        API_Request(@"AppEngineeringList")
//进度汇报列表
#define API_JDHBList                        API_Request(@"ProjectProcessList")
#define API_JDHBSave                      API_Request(@"AppSaveProcessRate")
//物料计划列表
#define API_WLJHList                        API_Request(@"AppMarketOrderList")
#define API_WLJHDetialList              API_Request(@"AppMODList")
#define API_WLJHDetialSave            API_Request(@"AppSaveMO")
#define API_WLJHDetialSubmit        API_Request(@"AppApprovalMO")

//现场施工
#define API_XCSHList                                    API_Request(@"AppProcurementProjectBranchList")
#define API_XCSHListModelRecord             API_Request(@"ProcurementSendList")
#define API_XCSHRecordDetial                    API_Request(@"AppPODList")
#define API_XCSHRecordChangeSubmit     API_Request(@"SaveReceive")

//项目请购
#define API_XMQGList                              API_Request(@"AppInquiryMOList")
#define API_XMQGDetialList                    API_Request(@"AppMarketOrderInfo")
#define API_XMQGDetialShenHe              API_Request(@"AppApprovalMO")

//项目变更
#define API_XMBGList                            API_Request(@"AppWaitCOList")
#define API_XMBGDetialList                  API_Request(@"AppPBCOList")
#define API_XMQGBGDetialSubmit       API_Request(@"SaveChangeOrders")

//变更审核
#define API_BGSHList                            API_Request(@"AppChangeOrdersList")
#define API_BGSHSubmitList                API_Request(@"AppApprovalChangeOrders") //  与 API_XMQGBGDetialSubmit 相同参数不同

//项目进度
#define API_XMJDList                            API_Request(@"AppProcessPBList")
#define API_XMJDGanttData                 API_Request(@"AppProjectProcessGantt")

//交接确认
//列表
#define API_JJQR_GCB                        API_Request(@"FileTransferEngineeringList") // 工程部
#define API_JJQR_SCB                        API_Request(@"FileTransferInquiryList") // 市场部
#define API_JJQR_JSB                         API_Request(@"FileTransferDesignList") //  技术部
//弹出请求
#define API_JJQR_FTInfo                     API_Request(@"AppGetFTInfo")
//提交
#define API_JJQRSubmit_GCB            API_Request(@"AppFTEngineeringApproval") // 工程部
#define API_JJQRSubmit_SCB             API_Request(@"AppFTInquiryApproval") // 市场部
#define API_JJQRSubmit_JSB              API_Request(@"AppFTDesignApproval") //  技术部

// 任务分配
#define API_RWFPList                            API_Request(@"AppPBAssignList")
#define API_RWFPPersonData              API_Request(@"AppEmployeeByDPList")
#define API_RWFPSave                         API_Request(@"AppProjectApprove")

//采购付款
#define API_CGFKList                              API_Request(@"AppPOList")
#define API_CGFKInfoData                      API_Request(@"AppPOInfo")
#define API_CGFKSubmit                         API_Request(@"AppSubmitPO")

//设计审核
#define API_SJSHList                                     API_Request(@"AppDeepenDesignApproveList")
#define API_SJSH_BJQDList                         API_Request(@"AppTreeDesignAllList")
#define API_SJSH_WJQDList                         API_Request(@"AppProjectFileList")
#define API_SJSH_GCJDList                         API_Request(@"AppProjectProcessSubmitList")

#define API_SJSH_SH                                  API_Request(@"AppApprovalDesignAll")


// 工程分配
#define API_GCFPList                            API_Request(@"AppEngineeringAssignList")
#define API_GCFPSave                         API_Request(@"AppAssignEngineering")

// 采购审核
#define API_CGSHList                            API_Request(@"AppApprovalPurchaseOrderList")
#define API_CGSHSubmitList                API_Request(@"AppSubmitPO") // AppSubmitPO,参数:State=6,AEmp(登录成功后的uc)
//入库评审
#define API_RKPSList                            API_Request(@"AppStockApproveList")
#define API_RKPSSubmit                      API_Request(@"AppStApprove")

//项目开支
//SpendingTypeID开支类型：调用网站根目录下/Scripts/Json/SpendingType.json数据
#define API_XMKZSpendingType          API_RootUrl(@"/Scripts/Json/SpendingType.json")

#define API_XMKZList                            API_Request(@"AppSpendingPBList?Stat=")
#define API_XMKZSecondList               API_Request(@"AppSpendingList")
#define API_XMKZDetialAddSave         API_Request(@"AppSaveSpending")
#define API_XMKZDetialSubmit            API_Request(@"AppApproveSpending")
#define API_XMKZDetialDelete            API_Request(@"AppDelSpending")

/*
 int Id(开支Id)
 int State=2
 int EmployeeID(操作人Id)
*/


//开支审核
#define API_KZSHList                            API_Request(@"AppSpendingApproveList")
#define API_KZSHSubmit                      API_Request(@"AppApproveSpending")
/*
 int Id  EmployeeID
 int State=7(同意) =3(驳回) =-1(作废)
 string AEmp(登录成功后的uc State=7时必须回传)
 string RejectReason(State.In(3,-1)必须回传)
 */

//开支付款
#define API_KZFKList                            API_Request(@"AppSpendingPayList")
#define API_KZFKSubmit                      API_Request(@"AppApproveSpending")
/*
int Id
int EmployeeID
int State=8
*/
@end

NS_ASSUME_NONNULL_END
