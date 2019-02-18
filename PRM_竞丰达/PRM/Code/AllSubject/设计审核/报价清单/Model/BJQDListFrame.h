//
//  BJQDListFrame.h
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJQDListModel : BaseModel

@property (nonatomic, copy) NSString *BrandName;
@property (nonatomic, copy) NSString *Cost;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *IsSubTotal;
@property (nonatomic, copy) NSString *LastQuantity;
@property (nonatomic, copy) NSString *Model;


@property (nonatomic, copy) NSString *NOStr;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Quantity;    //数量
@property (nonatomic, copy) NSString *QuotedPrice; //总价
@property (nonatomic, copy) NSString *SendType;
@property (nonatomic, copy) NSString *StockTypeName;
@property (nonatomic, copy) NSString *UnitQuotedPrice;   //单价
@property (nonatomic, copy) NSString *_parentId;

@property (nonatomic, copy) NSString *UnitQuotedPriceStr;
@property (nonatomic, copy) NSString *QuotedPriceStr; //总价
@property (nonatomic, copy) NSString *QuantityStr;

@end
NS_ASSUME_NONNULL_END



@interface BJQDListFrame : BaseModel<NSCopying,NSMutableCopying>

@property(nonatomic,assign)CGRect mcF;
@property(nonatomic,assign)CGRect tagViewF;
@property(nonatomic,assign)CGRect moneyF;

@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)BJQDListModel *model;

@end
 
