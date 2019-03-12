//
//  WLJHListCell.h
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXBaseCell.h"
#import "WLJHListModel.h"
#import "XMQGListModel.h"


typedef enum : NSUInteger {
    CellType_XMQG,
     CellType_WLJH,
} CellType;

NS_ASSUME_NONNULL_BEGIN

@interface WLJHListCell : DXBaseCell
@property (nonatomic, strong) QMUILabel *leftCircleLab;
@property (nonatomic, strong) QMUILabel *titleLab;

@property (nonatomic, assign) CellType cellType;

//+(instancetype)cellWithTableView:(UITableView *)tableView; 

@end

NS_ASSUME_NONNULL_END
