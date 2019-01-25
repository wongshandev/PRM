//
//  CGFKDetialFrame.h
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BaseModel.h"



@interface CGFKDetialModel : BaseModel
@property (nonatomic, copy) NSString *BrandName;
@property (nonatomic, copy) NSString *Model;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Quantity;
@property (nonatomic, copy) NSString *StockID;


@property (nonatomic, copy) NSString *PriceStr;
@property (nonatomic, copy) NSString *QuantityStr;

@end
@interface CGFKDetialFrame : BaseModel<NSCopying,NSMutableCopying>
@property(nonatomic,assign)CGRect mcF;
@property(nonatomic,assign)CGRect tagViewF;

@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)CGFKDetialModel *model;
@end


