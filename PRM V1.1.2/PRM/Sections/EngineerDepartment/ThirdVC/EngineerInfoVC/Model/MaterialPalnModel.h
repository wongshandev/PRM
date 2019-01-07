//
//  MaterialPalnModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface MaterialPalnModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *OrderDate;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *MarketDate;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CreateDate;

@end
