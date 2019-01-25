//
//  XMBGDetailModel.h
//  PRM
//
//  Created by apple on 2019/1/19.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMBGDetailModel : BaseModel
@property (nonatomic, copy) NSString *Url;
@property (nonatomic, copy) NSString *ApprovalID;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *ChangeType;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) BOOL isNewAdd;


@property (nonatomic, copy) NSString *Name;


@end

NS_ASSUME_NONNULL_END
