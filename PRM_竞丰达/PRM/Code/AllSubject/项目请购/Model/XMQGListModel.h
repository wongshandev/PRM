//
//  XMQGListModel.h
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMQGListModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *OrderDate;
@property (nonatomic, copy) NSString *ProjectCode;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *MarketDate;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, strong) UIColor *stateColor;

@end

NS_ASSUME_NONNULL_END
