//
//  StasticGanttModel.h
//  MicroOAForCompany
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface StasticGanttModel : BaseModel
// 甘特图数据数据处理

  //PRMStageModel
 @property (nonatomic,copy) NSString*Id;
  @property (nonatomic,copy) NSString *JD_Id;
 @property (nonatomic,copy) NSString *sjJSRQ;
 @property (nonatomic,copy) NSString *sjKSRQ;

  @property (nonatomic,copy) NSString *TS;


@property (nonatomic,copy) NSString*jhJSRQ;
@property (nonatomic,copy) NSString *jhKSRQ;
@property (nonatomic,copy) NSString *JDNum; //进度比例值
@property (nonatomic,copy) NSString *JDName; //进度比例值
@property (nonatomic,copy) NSString *JZNR; // 进展内容


@end

@interface StageModel : BaseModel

@property (nonatomic,copy) NSString *ActualBeginDate; // sjKSRQ
@property (nonatomic,copy) NSString *ActualEndDate;  //sjJSRQ
@property (nonatomic,copy) NSString *BeginDate; //jhJSRQ
@property (nonatomic,copy) NSString *EndDate; // jhKSRQ
@property (nonatomic,copy) NSString *CompletionRate; //JDNum
@property (nonatomic,copy) NSString *Name;   // JDName
@property (nonatomic,copy) NSString*Id;  // JDId


//@property (nonatomic,copy) NSString *DesignDay;
@property (nonatomic,copy) NSString *LastModifyDate;

@end
