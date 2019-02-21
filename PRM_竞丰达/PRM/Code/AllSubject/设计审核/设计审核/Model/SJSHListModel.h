//
//  SJSHListModel.h
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "EngineeringModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJSHListModel : EngineeringModel
@property(nonatomic,copy)NSString *State;
@property(nonatomic,copy)NSString *Address;

@property(nonatomic,assign)BOOL isCanSH;
@property(nonatomic,copy)NSString *stateString;
@property (nonatomic, strong) UIColor *StateColor;
@end

NS_ASSUME_NONNULL_END
