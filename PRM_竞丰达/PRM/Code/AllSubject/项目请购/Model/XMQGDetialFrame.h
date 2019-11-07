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
@property (nonatomic, copy) NSString *Unit;

@property(nonatomic, copy) NSString *BOMID;
@property(nonatomic, copy) NSString *Id;
@property(nonatomic, copy) NSString *QuantityDesign;
@property(nonatomic, copy) NSString *QuantityPurchased;
@property(nonatomic, copy) NSString *Quantity;
@property(nonatomic, copy) NSString *_parentId;

@property(nonatomic,copy) NSString *QuantityDesignStr;
@property(nonatomic,copy) NSString *QuantityPurchasedStr;
@property(nonatomic,copy) NSString *QuantityStr;

@end
 
@interface XMQGDetialFrame : BaseModel<NSCopying,NSMutableCopying>

@property(nonatomic,assign)CGRect mcF;
@property(nonatomic,assign)CGRect tagViewF;
 
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)XMQGDetialModel *model;

@end

NS_ASSUME_NONNULL_END
