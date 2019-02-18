//
//  XMQGDetialModel.h
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMQGDetialModel : BaseModel
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *StockID;
@property (nonatomic, copy) NSString *Model;
@property (nonatomic, copy) NSString *BrandName;
@property (nonatomic, copy) NSString *Quantity;

@property(nonatomic,copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
