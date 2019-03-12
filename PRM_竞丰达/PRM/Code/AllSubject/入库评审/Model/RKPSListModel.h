//
//  RKPSListModel.h
//  PRM
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RKPSListModel : BaseModel

@property(nonatomic,copy)NSString *BrandName;
@property(nonatomic,copy)NSString *ChildTypeName;
@property(nonatomic,copy)NSString *EmployeeName;
@property(nonatomic,copy)NSString *Guidance;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *Model;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *Reason;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *Specifications;
@property(nonatomic,assign)NSInteger State;
@property(nonatomic,copy)NSString *StockTypeName;
@property(nonatomic,copy)NSString *Unit;
@property(nonatomic,copy)NSString *Weight;
@property(nonatomic,copy)NSString *WeightUnit;


@property (nonatomic, copy) NSString *PriceListStr;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *stateString;
@property (nonatomic, strong) UIColor *stateColor;

@property (nonatomic, copy) NSString *PriceStr;
@property (nonatomic, copy) NSString *WeightStr;
@property (nonatomic, copy) NSString *titleNameDetial;
@property (nonatomic, copy) NSString *stockChildNameStr;


@end

NS_ASSUME_NONNULL_END
