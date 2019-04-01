//
//  DXBaseCell.h
//  JiYouGe
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 Sonjery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCellDataAdapter.h"
@class DXBaseCell;

@protocol  DXBaseCellDelegate <NSObject>

@optional


/**
 * 点击cell的触发事件

 @param DXBaseCell 对象
 @param event 触发event
 */
- (void)DXBaseCell:(DXBaseCell *)DXBaseCell event:(id)event;

@end

@interface DXBaseCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
/**
 * cell 的代理
 */
@property (nonatomic, weak) id<DXBaseCellDelegate> delegate;

/**
 * cell 数据适配器
 */
@property (nonatomic, weak) DXCellDataAdapter *dataAdapter;

/**
 * 数据源
 */
@property (nonatomic, weak) id data;

/**
 * 记录 cell 的 indexPath
 */
@property (nonatomic, weak) NSIndexPath *indexPath;

/**
 * tableView
 */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIViewController *viewController;

/**
 *  Cell is showed or not, you can set this property in UITableView's method 'tableView:willDisplayCell:forRowAtIndexPath:' & 'tableView:didEndDisplayingCell:forRowAtIndexPath:' at runtime.
 */
@property (nonatomic, assign) BOOL display;

#pragma mark -- 子类重写的方法

/**
 * 配置 cell
 */
- (void)setupCell;

/**
 * 创建并布局子视图
 */
- (void)buildSubview;

/**
 * 加载数据
 */
- (void)loadContent;

/**
 *  Calculate the cell's from data, override by subclass.
 *
 *  @param data Data.
 *
 *  @return Cell's height.
 */
+ (CGFloat)cellHeightWithData:(id)data;

/**
 *  Update the cell's height with animated or not, before you use this method, you should have the weak reference 'tableView' and 'dataAdapter', and this method will update the weak reference dataAdapter's property cellHeight.
 *
 *  @param height   The new cell height.
 *  @param animated Animated or not.
 */

- (void)updateWithNewCellHeight:(CGFloat)height animated:(BOOL)animated;

/**
 *  Selected event, you should use this method in 'tableView:didSelectRowAtIndexPath:' to make it effective.
 */
- (void)selectedEvent;

#pragma mark - Constructor method.

/**
 *  Create the cell's dataAdapter.
 *
 *  @param reuseIdentifier Cell reuseIdentifier, can be nil.
 *  @param data            Cell's data, can be nil.
 *  @param height          Cell's height.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data
                                             cellHeight:(CGFloat)height type:(NSInteger)type;

/**
 *  Create the cell's dataAdapter.
 *
 *  @param reuseIdentifier Cell reuseIdentifier, can be nil.
 *  @param data            Cell's data, can be nil.
 *  @param height          Cell's height.
 *  @param cellWidth       Cell's width.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data
                                             cellHeight:(CGFloat)height cellWidth:(CGFloat)cellWidth
                                                   type:(NSInteger)type;

/**
 *  Create the cell's dataAdapter, the CellReuseIdentifier is the cell's class string.
 *
 *  @param data            Cell's data, can be nil.
 *  @param height          Cell's height.
 *  @param type            Cell's type.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height type:(NSInteger)type;

/**
 *  Create the cell's dataAdapter, the CellReuseIdentifier is the cell's class string.
 *
 *  @param data            Cell's data, can be nil.
 *  @param height          Cell's height.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height;

/**
 *  Create the cell's dataAdapter, the CellReuseIdentifier is the cell's class string.
 *
 *  @param data            Cell's data, can be nil.
 *
 *  @return Cell's dataAdapter.
 */
+ (DXCellDataAdapter *)dataAdapterWithData:(id)data;

/**
 *  Convenient method to set some weak reference.
 *
 *  @param dataAdapter DXCellDataAdapter's object.
 *  @param data        Data.
 *  @param indexPath   IndexPath.
 *  @param tableView   TableView.
 */
- (void)setWeakReferenceWithDXCellDataAdapter:(DXCellDataAdapter *)dataAdapter data:(id)data
                                  indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

/**
 *  Register to tableView with the reuseIdentifier you specified.
 *
 *  @param tableView       TableView.
 *  @param reuseIdentifier The cell reuseIdentifier.
 */
+ (void)registerToTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  Register to tableView with the The class name.
 *
 *  @param tableView       TableView.
 */
+ (void)registerToTableView:(UITableView *)tableView;

-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number; 

@end
