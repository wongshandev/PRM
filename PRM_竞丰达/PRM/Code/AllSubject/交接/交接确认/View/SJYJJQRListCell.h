//
//  SJYJJQRListCell.h
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXBaseCell.h"
#import "SJYJJQRListModel.h"
#import "SJSHListModel.h"
typedef enum : NSUInteger {
    CellType_JJQRList,
    CellType_SJSHList,
 } CellType;

@interface SJYJJQRListCell : DXBaseCell

@property(nonatomic,assign)CellType cellType;

@end


