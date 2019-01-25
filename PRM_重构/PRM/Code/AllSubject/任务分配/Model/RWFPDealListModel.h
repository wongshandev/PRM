//
//  RWFPDealListModel.h
//  PRM
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWFPDealListModel : BaseModel

@property (nonatomic, assign)BOOL isMust;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *subtitleStr;
@property (nonatomic, copy) NSString *IdString;
 

@end

NS_ASSUME_NONNULL_END
