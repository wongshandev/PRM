//
//  MainModel.h
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainModel : BaseModel
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,strong)NSMutableArray <MainModel*>*children;
@property(nonatomic,copy)NSString *iconURL;
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
