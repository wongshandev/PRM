//
//  JDHBListCell.h
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CellSaveData)(NSMutableDictionary *cellDic);

@interface JDHBListCell : DXBaseCell
@property (nonatomic, copy)CellSaveData savDataBlock;
@property(nonatomic,strong)NSMutableDictionary *cellDic;
@end

NS_ASSUME_NONNULL_END
