//
//  XMBGDetailCell.h
//  PRM
//
//  Created by apple on 2019/1/19.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXBaseCell.h"
#import "XMBGDetailModel.h"

typedef enum : NSUInteger {
    CellType_WJQDList,
    CellType_XMBGDetial,
} CellType;

@interface XMBGDetailCell : DXBaseCell
@property(nonatomic,strong) QMUIButton *fujianBtn;
@property(nonatomic,assign) CellType cellType;

@end

 
