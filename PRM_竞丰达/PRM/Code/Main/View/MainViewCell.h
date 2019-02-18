//
//  MainViewCell.h
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewCell : UICollectionViewCell

@property (nonatomic,strong)NSIndexPath *indexPath;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)index;
-(void)showMainCellDataWithModel:(MainModel *)model;

@end


