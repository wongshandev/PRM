//
//  ProgressReportModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/14.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface ProgressReportModel : BaseModel
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *EndDate;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CompletionRate;
@property (nonatomic, copy) NSString *LastModifyDate;
@property (nonatomic, copy) NSString *BeginDate;
@end
