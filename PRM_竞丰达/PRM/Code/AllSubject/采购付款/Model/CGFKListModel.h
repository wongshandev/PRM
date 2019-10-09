//
//  CGFLListModel.h
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGFKListModel : BaseModel

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CreateName;
@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *AgreementPrice;
@property (nonatomic, copy) NSString *PlaceReceipt;
@property (nonatomic, copy) NSString *Version;


@property (nonatomic, assign) NSInteger ApprovalID;
@property (nonatomic, assign) NSInteger ManagerID;
@property (nonatomic, assign) NSInteger BossID;
@property (nonatomic, assign) NSInteger State;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *StateStr;
@property (nonatomic, strong) UIColor *StateColor;
@property (nonatomic, assign) BOOL isCGFK;

 @end


NS_ASSUME_NONNULL_END
