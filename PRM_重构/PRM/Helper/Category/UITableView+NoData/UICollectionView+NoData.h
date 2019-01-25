//
//  UICollectionView+NoData.h
//  PRM
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionViewRefreshBtnBlock)(void);

@interface UICollectionView (NoData)

@property (nonatomic, assign) BOOL showNoData;   // 为YES时使用该缺省背景视图，默认为NO
@property (nonatomic, strong) UIImage *customImg;// 必须项
@property (nonatomic, strong) UIColor *bgColor;  // 背景色，默认为白色
@property (nonatomic, strong) NSString *customMsg;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL isShowBtn;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) CollectionViewRefreshBtnBlock  refreshBlock;
@end


