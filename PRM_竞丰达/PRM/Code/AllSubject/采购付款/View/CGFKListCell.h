//
//  CGFKListCell.h
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXBaseCell.h"
#import "CGFKListModel.h"

typedef enum : NSUInteger {
    CellType_CGFKList,
    CellType_CGSHList,
} CellType;


NS_ASSUME_NONNULL_BEGIN

@interface CGFKListCell : DXBaseCell
@property(nonatomic,assign)CellType cellType;

@end

NS_ASSUME_NONNULL_END
