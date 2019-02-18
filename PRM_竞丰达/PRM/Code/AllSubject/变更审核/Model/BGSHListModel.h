//
//  BGSHListModel.h
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

 
@interface BGSHListModel : BaseModel

@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *CName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *ApprovalID;
@property (nonatomic, copy) NSString *Url;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ChangeType;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *subtitleStr;
@property (nonatomic, copy) NSString *stateStr;

@end


