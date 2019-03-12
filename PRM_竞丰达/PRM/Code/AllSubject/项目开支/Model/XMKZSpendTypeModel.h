//
//  XMKZSpendTypeModel.h
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMKZSpendTypeModel : BaseModel<NSCoding>//注意：这里需要实现NSCoding协议
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
