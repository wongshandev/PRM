//
//  MainCellModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface MainModel : BaseModel
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSMutableArray *children;
@property(nonatomic,copy)NSString *iconURL;
@property(nonatomic,copy)NSString *url;

@end
