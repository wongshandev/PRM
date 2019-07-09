//
//  PurchaseDetialModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/21.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface PurchaseDetialModel : BaseModel
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *StockID;
@property (nonatomic, copy) NSString *Model;
@property (nonatomic, copy) NSString *BrandName;
@property (nonatomic, copy) NSString *Quantity;
@end
