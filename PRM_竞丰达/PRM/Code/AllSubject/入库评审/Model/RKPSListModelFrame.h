//
//  RKPSListModelFrame.h
//  PRM
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"
#import "RKPSListModel.h"

@interface RKPSListModelFrame : BaseModel<NSCopying,NSMutableCopying>
@property(nonatomic,assign)CGRect mcF;
@property(nonatomic,assign)CGRect tagViewF;

@property(nonatomic,assign)CGRect sep1F;
@property(nonatomic,assign)CGRect sep2F;

@property(nonatomic,assign)CGRect bzMenF;
@property(nonatomic,assign)CGRect bzF;
@property(nonatomic,assign)CGRect reasonMenF;
@property(nonatomic,assign)CGRect reasonF;

@property(nonatomic,assign)CGFloat viewHeight;
@property(nonatomic,strong)RKPSListModel *model;

@end
 
