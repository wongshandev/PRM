//
//  XMKZDetialListModel.h
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    ModelType_XMKZ,
    ModelType_KZSH,
    ModelType_KZFK,
} ModelType;

NS_ASSUME_NONNULL_BEGIN

@interface XMKZDetialListModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *SpendingTypeID;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, assign)NSInteger State;
@property (nonatomic, copy) NSString *OccurDate;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Url;
@property (nonatomic, assign) BOOL EditType;
@property (nonatomic, assign)NSInteger ApplyID;
@property (nonatomic, copy) NSString *ApplyName;
@property (nonatomic, assign)NSInteger EmployeeID;
@property (nonatomic, copy) NSString *EmployeeName;
@property (nonatomic, assign)NSInteger ApprovalID;
@property (nonatomic, assign)NSInteger ManagerID;
@property (nonatomic, assign)NSInteger BossID;
@property (nonatomic, assign)NSInteger PayID;


@property (nonatomic, strong) UIColor *stateColor;
@property (nonatomic, copy) NSString *stateString;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *SpndingTypeName;



@property (nonatomic, copy) NSString *SpendingTypeIDChange;
@property (nonatomic, copy) NSString *SpndingTypeNameChange;

@property (nonatomic, copy) NSString *OccurDateChange;
@property (nonatomic, copy) NSString *RemarkChange;
@property (nonatomic, copy) NSString *AmountChange;
@property (nonatomic, assign) ModelType modelType;

//[self.viewDataDic setObject:self.detialModel.SpendingTypeID forKey:@"SpendingTypeID"];
//[self.viewDataDic setObject:self.detialModel.OccurDate forKey:@"OccurDate"];
//[self.viewDataDic setObject:self.detialModel.Remark forKey:@"Remark"];
//[self.viewDataDic setObject:self.detialModel.Amount forKey:@"Amount"];

@end

NS_ASSUME_NONNULL_END
