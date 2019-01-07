//
//  ReceiveGoodsModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface ReceiveGoodsModel : BaseModel
@property (nonatomic, copy) NSString *RealID;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *Approval;
@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *StateName;
@property (nonatomic, copy) NSString *Employee;
@property (nonatomic, copy) NSString *SiteState;

@end
