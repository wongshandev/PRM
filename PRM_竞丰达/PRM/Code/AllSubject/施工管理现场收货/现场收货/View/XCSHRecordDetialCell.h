//
//  XCSHRecordDetialCell.h
//  PRM
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CellSaveData)(NSMutableDictionary *cellDic);

@interface XCSHRecordDetialCell : DXBaseCell
@property (nonatomic, copy)CellSaveData savDataBlock;
@property(nonatomic,strong)NSMutableDictionary *cellDic;

@end

NS_ASSUME_NONNULL_END
