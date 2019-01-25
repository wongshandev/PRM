//
//  JDHBListModel.h
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

 
@interface JDHBListModel : BaseModel
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *EndDate;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CompletionRate;
@property (nonatomic, copy) NSString *LastModifyDate;
@property (nonatomic, copy) NSString *BeginDate;


@property (nonatomic, copy) NSString *canChangeRate;
@property (nonatomic, copy) NSString *canChangeRemark;


@end


