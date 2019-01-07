//
//  TransferCellClickModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/3/10.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface TransferCellClickModel : BaseModel
@property (nonatomic, copy) NSString *DesignID;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, strong) NSMutableDictionary *Inquiry;
@property (nonatomic, copy) NSString *ProjectBranchID;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *IsEnable;
@property (nonatomic, copy) NSString *IsDel;
@property (nonatomic, copy) NSString *Design;
@property (nonatomic, copy) NSString *HaveDeepenDesign;
@property (nonatomic, copy) NSString *EngineeringID;
@property (nonatomic, copy) NSString *HaveProgram;
@property (nonatomic, copy) NSString *InquiryID;
@property (nonatomic, copy) NSString *HaveAgreement;
@property (nonatomic, copy) NSString *Engineering;
@end
