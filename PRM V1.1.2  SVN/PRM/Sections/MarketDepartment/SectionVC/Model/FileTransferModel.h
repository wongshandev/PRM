//
//  FileTransferModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/9.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface FileTransferModel : BaseModel

@property(nonatomic,copy)NSString *Code;
@property(nonatomic,copy)NSString *DesignName;
@property(nonatomic,copy)NSString *EngineeringName;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *InquiryName;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *ProjectTypeName;

@end
