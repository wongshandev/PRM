//
//  GCJDListModel.h
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GCJDListModel : BaseModel
@property (nonatomic, copy) NSString *BeginDate;
@property (nonatomic, copy) NSString *DesignDay;
@property (nonatomic, copy) NSString *Name;


@property (nonatomic, copy) NSString *Rate;
@property (nonatomic, copy) NSString *pId;
@property (nonatomic, copy) NSString *ChildName;

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
