//
//  RWFPListMOdel.h
//  PRM
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWFPListModel : BaseModel
@property (nonatomic, copy) NSString *DesignName;
@property (nonatomic, copy) NSString *DesignID;

@property (nonatomic, copy) NSString *InquiryName;
@property (nonatomic, copy) NSString *InquiryID;

@property (nonatomic, copy) NSString *EngineeringName;
@property (nonatomic, copy) NSString *EngineeringID;

@property (nonatomic, copy) NSString *AidIds;

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ProjectTypeName;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *City;

@property (nonatomic, copy) NSString *ProjectTypeID;

@property (nonatomic, copy) NSString *titleStr;

 @end

NS_ASSUME_NONNULL_END
