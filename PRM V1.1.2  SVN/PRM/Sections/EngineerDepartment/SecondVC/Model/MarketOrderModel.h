//
//  MarketOrderModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface MarketOrderModel : BaseModel

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *OrderDate;
@property (nonatomic, copy) NSString *ProjectCode;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *MarketDate;


@end
