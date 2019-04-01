//
//  DXCellDataAdapter.m
//  ZiPeiYi
//
//  Created by Sonjery on 15/12/30.
//  Copyright © 2015年 Sonjery. All rights reserved.
//

#import "DXCellDataAdapter.h"

@implementation DXCellDataAdapter

+ (DXCellDataAdapter *)DXCellDataAdapterWithCellReuseIdentifier:(NSString *)cellReuseIdentifiers data:(id)data
                                                 cellHeight:(CGFloat)cellHeight cellType:(NSInteger)cellType {
    
    DXCellDataAdapter *adapter    = [[self class] new];
    adapter.cellReuseIdentifier = cellReuseIdentifiers;
    adapter.data                = data;
    adapter.cellHeight          = cellHeight;
    adapter.cellType            = cellType;
    
    return adapter;
}

+ (DXCellDataAdapter *)DXCellDataAdapterWithCellReuseIdentifier:(NSString *)cellReuseIdentifiers data:(id)data
                                                 cellHeight:(CGFloat)cellHeight cellWidth:(CGFloat)cellWidth
                                                   cellType:(NSInteger)cellType {
    
    DXCellDataAdapter *adapter    = [[self class] new];
    adapter.cellReuseIdentifier = cellReuseIdentifiers;
    adapter.data                = data;
    adapter.cellHeight          = cellHeight;
    adapter.cellWidth           = cellWidth;
    adapter.cellType            = cellType;
    
    return adapter;
}

+ (DXCellDataAdapter *)collectionDXCellDataAdapterWithCellReuseIdentifier:(NSString *)cellReuseIdentifiers data:(id)data cellType:(NSInteger)cellType {
    
    DXCellDataAdapter *adapter    = [[self class] new];
    adapter.cellReuseIdentifier = cellReuseIdentifiers;
    adapter.data                = data;
    adapter.cellType            = cellType;
    
    return adapter;
}

@end
