//
//  WLJHListModel.h
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLJHListModel : BaseModel

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *OrderDate;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *MarketDate;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CreateDate;




@end

NS_ASSUME_NONNULL_END
