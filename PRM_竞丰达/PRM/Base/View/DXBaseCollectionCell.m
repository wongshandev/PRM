//
//  CustomCollectionCell.m
//  TechCode
//
//  Created by Sonjery on 16/5/18.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import "DXBaseCollectionCell.h"

@implementation DXBaseCollectionCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)index{
     DXBaseCollectionCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:[self className]  forIndexPath:index];
    if (cell == nil) {
        cell =  [collectionView  dequeueReusableCellWithReuseIdentifier:[self className]  forIndexPath:index];
    }
    cell.indexPath = index;
    cell.collectionView = collectionView;
    return  cell;
}
-(instancetype)init{
    if (self = [super init]) {
        [self setupCell];
        [self buildSubview];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupCell];
        
        [self buildSubview];
    }
    
    return self;
}

- (void)setupCell {
    
}

- (void)buildSubview {
    
}

- (void)loadContent {
    
}

- (void)contentOffset:(CGPoint)offset {
    
}

- (void)selectedEvent {
    
}

+ (DXCellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type {
    
    NSString *tmpReuseIdentifier = reuseIdentifier.length <= 0 ? NSStringFromClass([self class]) : reuseIdentifier;
    return [DXCellDataAdapter collectionDXCellDataAdapterWithCellReuseIdentifier:tmpReuseIdentifier data:data cellType:type];
}

+ (DXCellDataAdapter *)dataAdapterWithData:(id)data type:(NSInteger)type {

    return [DXCellDataAdapter collectionDXCellDataAdapterWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellType:type];
}

+ (DXCellDataAdapter *)dataAdapterWithData:(id)data {
    
    return [DXCellDataAdapter collectionDXCellDataAdapterWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellType:0];
}

+ (void)registerToCollectionView:(UICollectionView *)collectionView reuseIdentifier:(NSString *)reuseIdentifier {

    [collectionView registerClass:[self class] forCellWithReuseIdentifier:reuseIdentifier.length ? reuseIdentifier : NSStringFromClass([self class])];
}

+ (void)registerToCollectionView:(UICollectionView *)collectionView {

    [collectionView registerClass:[self class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
}

-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}
@end
