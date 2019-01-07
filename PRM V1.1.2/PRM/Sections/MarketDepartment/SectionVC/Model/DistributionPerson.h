//
//  DistributionPerson.h
//  PRM
//
//  Created by JoinupMac01 on 17/3/2.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface DistributionPerson : BaseModel
@property(assign,nonatomic)NSInteger Id;
@property(copy,nonatomic)NSString *Name;

@property(copy,nonatomic)NSString *DepartmentID;
@property(copy,nonatomic)NSString *MP;
@end
