//
//  XCSHRecordDetialModel.h
//  PRM
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"


@interface XCSHRecordDetialModel : BaseModel

@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *QuantityCheck;
@property (nonatomic, copy) NSString *QuantityReceive;
@property (nonatomic, copy) NSString *Quantity;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Model;
@property (nonatomic, copy) NSString *ModId;
@property (nonatomic, copy) NSString *Unit;

@property (nonatomic, copy) NSString *changeRemark;
@property (nonatomic, copy) NSString *changeQuantityCheck;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign)BOOL isModelChange;

@end


