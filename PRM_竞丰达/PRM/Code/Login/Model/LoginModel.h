//
//  LoginData.h
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"
@class SJYLoginInfo;

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : BaseModel<NSCoding>
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) SJYLoginInfo *uc;
@property (nonatomic, copy  ) NSString *employeeID;
@property (nonatomic, copy)   NSString *employeeName;
@property (nonatomic, copy  ) NSString *departmentID;
@property (nonatomic, copy  ) NSString *dt;
@property (nonatomic, copy  ) NSString *positionID;
@property (nonatomic, copy)   NSString *infotype;

@property (nonatomic, strong) NSDictionary *ucAemp;


@end

@interface SJYLoginInfo : BaseModel<NSCoding>

@property (nonatomic, copy  ) NSString * DepartmentID;
@property (nonatomic, copy  ) NSString * DesignDpId;
@property (nonatomic, copy  ) NSString * DesignId;
@property (nonatomic, copy  ) NSString * Dt;
@property (nonatomic, copy  ) NSString * EngineeringDpId;
@property (nonatomic, copy  ) NSString * EngineeringId;
@property (nonatomic, copy  ) NSString * FinanceDpId;
@property (nonatomic, copy  ) NSString * FinanceId;
@property (nonatomic, copy  ) NSString * HRDpId;
@property (nonatomic, copy  ) NSString * HRId;
@property (nonatomic, copy  ) NSString * Id;
@property (nonatomic, copy  ) NSString * InquiryDpId;
@property (nonatomic, copy  ) NSString * InquiryId;
@property (nonatomic, copy  ) NSString * Name;
@property (nonatomic, copy  ) NSString * PositionID;
@property (nonatomic, copy  ) NSString * PurchaseDpId;
@property (nonatomic, copy  ) NSString * PurchaseId;
@property (nonatomic, copy  ) NSString * SHDpId;
@property (nonatomic, copy  ) NSString * SHId;

@property (nonatomic, copy  ) NSString * PoAmount1;
@property (nonatomic, copy  ) NSString * PoAmount2;
@property (nonatomic, copy  ) NSString * PoAmount3;
@property (nonatomic, copy  ) NSString * PoId1;
@property (nonatomic, copy  ) NSString * PoId2;
@property (nonatomic, copy  ) NSString * PoId3;


@property (nonatomic, copy  ) NSString * EoAmount1;
@property (nonatomic, copy  ) NSString * EoAmount2;
@property (nonatomic, copy  ) NSString * EoAmount3;
@property (nonatomic, copy  ) NSString * EoId1;
@property (nonatomic, copy  ) NSString * EoId2;
@property (nonatomic, copy  ) NSString * EoId3;

@end
NS_ASSUME_NONNULL_END


