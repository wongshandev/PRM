//
//  JJQRFTInfotModel.h
//  PRM
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

@interface JJQRFTInfotModel : BaseModel
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


