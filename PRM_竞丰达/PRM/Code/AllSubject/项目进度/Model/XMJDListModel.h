//
//  XMJDListModel.h
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMJDListModel : BaseModel
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *BillingPrice;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *InquiryName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ProjectTypeName;
@property (nonatomic, copy) NSString *ReceivablesPrice;
@property (nonatomic, copy) NSString *DesignName;


@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *subtitleStr;
@property (nonatomic, copy) NSString *stateStr;

@end

NS_ASSUME_NONNULL_END
