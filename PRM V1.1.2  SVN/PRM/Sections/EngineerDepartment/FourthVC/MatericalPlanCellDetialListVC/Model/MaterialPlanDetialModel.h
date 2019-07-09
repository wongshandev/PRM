//
//  MaterialPlanDetialModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/16.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface MaterialPlanDetialModel : BaseModel
@property (nonatomic, copy) NSString *_parentId;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *BOMID;
@property (nonatomic, copy) NSString *QuantityPurchased;
@property (nonatomic, copy) NSString *QuantityThis;
@property (nonatomic, copy) NSString *Quantity;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Model;
@property (nonatomic, copy) NSString *QuantityReceive;
@property (nonatomic, copy) NSString *ModId;
@end
