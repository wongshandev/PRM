//
//  DXBaseTableHeaderFooterView.h
//  JiYouGe
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 河南咏赞软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXBaseTableHeaderFooterView;

@protocol DXBaseTableHeaderFooterViewDelegate <NSObject>

/**
 * DXBaseTableHeaderFooterView的点击事件
 *
 * @param DXBaseTableHeaderFooterView 对象
 * @param event 触发event
 */
- (void)DXBaseTableHeaderFooterView:(DXBaseTableHeaderFooterView *)DXBaseTableHeaderFooterView event:(id)event;

@end

@interface DXBaseTableHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<DXBaseTableHeaderFooterViewDelegate> delegate;

@property (nonatomic, weak) id data;

@property (nonatomic) NSInteger section;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIViewController *viewController;

- (void)setHeaderFooterViewBackgroundColor:(UIColor *)color;

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

#pragma mark -- 被子类重写的方法

/**
 * 对 HeaderFooterView 进行配置
 */
- (void)setupHeaderFooterView;

/**
 * 创建并布局子视图
 */
- (void)buildSubview;

/**
 * 加载数据
 */
- (void)loadContent;

@end
