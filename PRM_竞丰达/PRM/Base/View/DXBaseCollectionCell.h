//
//  CustomCollectionCell.h
//  TechCode
//
//  Created by Sonjery on 16/5/18.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCellDataAdapter.h"
@class DXBaseCollectionCell;

@protocol DXBaseCollectionCellDelegate <NSObject>

@optional

/**
 *  CustomCollectionCell's event.
 *
 *  @param cell  CustomCollectionCell
 *  @param event Event.
 */
- (void)customCollectionCell:(DXBaseCollectionCell *)cell event:(id)event;

@end

@interface DXBaseCollectionCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)index;
/**
 *  CustomCollectionCell's delegate.
 */
@property (nonatomic, weak) id <DXBaseCollectionCellDelegate> delegate;

/**
 *  CustomCell's data.
 */
@property (nonatomic, weak) DXCellDataAdapter *dataAdapter;

/**
 *  CustomCell's data.
 */
@property (nonatomic, weak) id data;

/**
 *  CustomCell's indexPath.
 */
@property (nonatomic, weak) NSIndexPath *indexPath;

/**
 *  TableView.
 */
@property (nonatomic, weak) UICollectionView *collectionView;

/**
 *  Controller.
 */
@property (nonatomic, weak) UIViewController *controller;

/**
 *  Cell is showed or not, you can set this property in UICollectionView's method 'collectionView:willDisplayCell:forItemAtIndexPath:' at runtime.
 */
@property (nonatomic) BOOL display;

#pragma mark - Method you should overwrite.

/**
 *  Setup cell, override by subclass.
 */
- (void)setupCell;

/**
 *  Build subview, override by subclass.
 */
- (void)buildSubview;

/**
 *  Load content, override by subclass.
 */
- (void)loadContent;

/**
 *  The content offset, override by subclass.
 */
- (void)contentOffset:(CGPoint)offset;

#pragma mark - Useful method.

/**
 *  Selected event, override by subclass.
 */
- (void)selectedEvent;

#pragma mark - Constructor method.

/**
 *  Create the cell's dataAdapter.
 *
 *  @param reuseIdentifier Cell reuseIdentifier, can be nil.
 *  @param data            Cell's data, can be nil.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type;

/**
 *  Create the cell's dataAdapter, the reuseIdentifier is the cell's class string.
 *
 *  @param data            Cell's data, can be nil.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithData:(id)data type:(NSInteger)type;

/**
 *  Create the cell's dataAdapter, the reuseIdentifier is the cell's class string.
 *
 *  @param data Cell's data, can be nil.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithData:(id)data;

/**
 *  Register to collectionView with the reuseIdentifier you specified.
 *
 *  @param collectionView  CollectionView.
 *  @param reuseIdentifier The cell reuseIdentifier.
 */
+ (void)registerToCollectionView:(UICollectionView *)collectionView reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  Register to collectionView with the The class name.
 *
 *  @param collectionView  collectionView.
 */
+ (void)registerToCollectionView:(UICollectionView *)collectionView;

-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number;

@end
