//
//  LoginData.m
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "LoginModel.h"


@implementation LoginModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"uc":@"SJYLoginInfo"};
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    self.success = [aDecoder decodeObjectForKey:@"success"];
    self.uc = [aDecoder decodeObjectForKey:@"uc"];
    self.employeeID = [aDecoder decodeObjectForKey:@"employeeID"];
     self.employeeName = [aDecoder decodeObjectForKey:@"employeeName"];
    self.departmentID = [aDecoder decodeObjectForKey:@"departmentID"];
    self.dt = [aDecoder decodeObjectForKey:@"dt"];
    self.positionID = [aDecoder decodeObjectForKey:@"positionID"];
    self.infotype = [aDecoder decodeObjectForKey:@"infotype"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.success forKey:@"success"];
    [aCoder encodeObject:self.uc forKey:@"uc"];
    [aCoder encodeObject:self.employeeID forKey:@"employeeID"];
    [aCoder encodeObject:self.employeeName forKey:@"employeeName"];
    [aCoder encodeObject:self.departmentID forKey:@"departmentID"];
    [aCoder encodeObject:self.dt forKey:@"dt"];
    [aCoder encodeObject:self.positionID forKey:@"positionID"];
    [aCoder encodeObject:self.infotype forKey:@"infotype"];


}

@end

@implementation SJYLoginInfo
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.DepartmentID = [aDecoder decodeObjectForKey:@"DepartmentID"];
    self.DesignDpId = [aDecoder decodeObjectForKey:@"DesignDpId"];
    self.DesignId = [aDecoder decodeObjectForKey:@"DesignId"];
    self.Dt = [aDecoder decodeObjectForKey:@"Dt"];
    self.EngineeringDpId = [aDecoder decodeObjectForKey:@"EngineeringDpId"];
    self.EngineeringId = [aDecoder decodeObjectForKey:@"EngineeringId"];
    self.FinanceDpId = [aDecoder decodeObjectForKey:@"FinanceDpId"];
    self.FinanceId = [aDecoder decodeObjectForKey:@"FinanceId"];
    self.HRDpId = [aDecoder decodeObjectForKey:@"HRDpId"];
    self.HRId = [aDecoder decodeObjectForKey:@"HRId"];
    self.Id = [aDecoder decodeObjectForKey:@"Id"];
    self.InquiryDpId = [aDecoder decodeObjectForKey:@"InquiryDpId"];
    self.InquiryId = [aDecoder decodeObjectForKey:@"InquiryId"];
    self.Name = [aDecoder decodeObjectForKey:@"Name"];
    self.PositionID = [aDecoder decodeObjectForKey:@"PositionID"];
    self.PurchaseDpId  = [aDecoder decodeObjectForKey:@"PurchaseDpId"];
    self.PurchaseId  = [aDecoder decodeObjectForKey:@"PurchaseId"];
    self.SHDpId  = [aDecoder decodeObjectForKey:@"SHDpId"];
    self.SHId  = [aDecoder decodeObjectForKey:@"SHId"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.DepartmentID forKey:@"DepartmentID"];
    [aCoder encodeObject:self.DesignDpId forKey:@"DesignDpId"];
    [aCoder encodeObject:self.DesignId forKey:@"DesignId"];
    [aCoder encodeObject:self.Dt forKey:@"Dt"];
    [aCoder encodeObject:self.EngineeringDpId forKey:@"EngineeringDpId"];
    [aCoder encodeObject:self.EngineeringId forKey:@"EngineeringId"];
    [aCoder encodeObject:self.FinanceDpId forKey:@"FinanceDpId"];
    [aCoder encodeObject:self.FinanceId forKey:@"FinanceId"];
    [aCoder encodeObject:self.HRDpId forKey:@"HRDpId"];
    [aCoder encodeObject:self.HRId forKey:@"HRId"];
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.InquiryDpId forKey:@"InquiryDpId"];
    [aCoder encodeObject:self.InquiryId forKey:@"InquiryId"];
    [aCoder encodeObject:self.Name forKey:@"Name"];
    [aCoder encodeObject:self.PositionID forKey:@"PositionID"];
    [aCoder encodeObject:self.PurchaseDpId forKey:@"PurchaseDpId"];
    [aCoder encodeObject:self.PurchaseId forKey:@"PurchaseId"];
    [aCoder encodeObject:self.SHDpId forKey:@"SHDpId"];
    [aCoder encodeObject:self.SHId forKey:@"SHId"];
}
@end



