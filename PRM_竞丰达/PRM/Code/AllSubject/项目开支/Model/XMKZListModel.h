//
//  XMKZListModel.h
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMKZListModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *ProjectTypeName;
@property (nonatomic, copy) NSString *SpendingPrice;
@property (nonatomic, copy) NSString *Budget;

@property (nonatomic, copy) NSString *titleStr;
@end

 
NS_ASSUME_NONNULL_END
