//
//  PurchaseOrderPayModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/10.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface PurchaseOrderPayModel : BaseModel
@property (nonatomic, copy) NSString *PlaceReceipt;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CreateName;
@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *AgreementPrice;
@property (nonatomic, copy) NSString *Id;
@end
