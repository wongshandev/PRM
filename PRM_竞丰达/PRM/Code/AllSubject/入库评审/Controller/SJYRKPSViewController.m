//
//  SJYRKPSViewController.m
//  PRM
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYRKPSViewController.h"
#import "RKPSListCell.h"
#import "RKPSDetialViewController.h"
 
#define  STATEArray  @[@"全部",@"待通过",@"已通过"]
#define  ListRKPSStateArray  @[@"",@"未审核",@"已驳回",@"已通过",@"弃权"]
 //待审核  ，已通过， 已驳回 ， 弃权
@interface SJYRKPSViewController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;
@property(nonatomic,assign)NSInteger shStateType;
@end

@implementation SJYRKPSViewController

-(void)setUpNavigationBar{
    Weak_Self;
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    self.shStateType = 0;
    [self.navBar.rightButton setTitle:@"查询" forState:UIControlStateNormal];
    self.navBar.rightButton.hidden = NO;
    [self.navBar.rightButton clickWithBlock:^{
        [weakSelf alertSearch];
    }];
}
-(void)alertSearch{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.footerSeparatorColor = UIColorClear;
    dialogViewController.headerSeparatorColor = UIColorClear;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
    dialogViewController.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    dialogViewController.rowHeight  = 55;
//    dialogViewController.contentViewMargins  = UIEdgeInsetsMake(0, 20, 0, 20);
    dialogViewController.headerViewHeight  = 10;
    dialogViewController.footerViewHeight  = 40;
    dialogViewController.allowsMultipleSelection = NO;// 打开多选
    dialogViewController.items = STATEArray;
    dialogViewController.selectedItemIndex = self.shStateType +1;


    dialogViewController.didSelectItemBlock = ^(__kindof QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        aDialogViewController.selectedItemIndex = itemIndex;
        self.shStateType = aDialogViewController.selectedItemIndex -1;
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
         [self.tableView.mj_header beginRefreshing];
    };

    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil]; 
    }];
    dialogViewController.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    dialogViewController.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);

    modalViewController.contentViewController = dialogViewController;
    [modalViewController showInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}
#pragma mark ======================= 数据绑定
-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf  requestData_RKPS];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf  requestData_RKPS];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRKPSListView) name:@"refreshRKPSListView" object:nil];
}
-(void)refreshRKPSListView{
    [self.tableView.mj_header beginRefreshing];
}
-(void)requestData_RKPS{
    [SJYRequestTool requestRKPSListWithSearchStateID:self.shStateType page:self.page success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
         if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in rowsArr) {
            RKPSListModel *model = [RKPSListModel  modelWithDictionary:dic];

            model.titleName = model.Model.length?[model.Name stringByAppendingFormat:@"(%@)",model.Model]:model.Name;
            model.titleNameDetial = [model.Name stringByAppendingFormat:@"(%@)",model.EmployeeName];

            model.WeightStr = model.Weight.floatValue == 0?@"": [[NSString numberMoneyFormattor:model.Weight] stringByAppendingString:model.WeightUnit];

            model.PriceListStr =  [[NSString numberMoneyFormattor:model.Guidance]   stringByAppendingFormat:@"(元/%@)",model.Unit];

            model.PriceStr =  model.Guidance.floatValue == 0?@"":[[NSString numberMoneyFormattor:model.Guidance]   stringByAppendingFormat:@"(元/%@)",model.Unit];

            NSString *stockStr = model.StockTypeName.length == 0?@"":model.StockTypeName;
             model.stockChildNameStr = model.ChildTypeName.length == 0? stockStr:[stockStr stringByAppendingFormat:@"(%@)",model.ChildTypeName];

            model.stateString = model.State < [ListRKPSStateArray count] ?[ListRKPSStateArray objectAtIndex:model.State] : ListRKPSStateArray.lastObject;
            BOOL ishav = [StateCodeStringArray containsObject:model.stateString];
            StateCode idx = ishav ? [StateCodeStringArray indexOfObject:model.stateString]:0;
            model.stateColor = [StateCodeColorHexArray objectAtIndex:idx];
 
            RKPSListModelFrame *frame = [[RKPSListModelFrame alloc]init];
            frame.model = model;

            [self.dataArray addObject:frame];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self endRefreshWithError:NO];
        });
    } failure:^(int status, NSString *info) {
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self endRefreshWithError:YES];
        });
    }];
}
-(void)endRefreshWithError:(BOOL)havError{
    [self.tableView.mj_header endRefreshing];
    if (self.dataArray.count < self.totalNum) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.dataArray.count == 0) {
        self.tableView.customImg = !havError ? [UIImage imageNamed:@"empty"]:SJYCommonImage(@"daoda");
        self.tableView.customMsg = !havError? @"没有数据了,休息下吧":@"网络错误,请检查网络后重试";
        self.tableView.showNoData = YES;
        self.tableView.isShowBtn =  havError;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SJYJJQRListCell *cell = [SJYJJQRListCell cellWithTableView:tableView];
    RKPSListCell *cell = [RKPSListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RKPSListModelFrame *model = self.dataArray[indexPath.row];
    RKPSDetialViewController*sjshSupVC = [[RKPSDetialViewController alloc]init];
    sjshSupVC.modelFrame = model;
    sjshSupVC.title = @"物料详情";
    [self.navigationController pushViewController:sjshSupVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshRKPSListView" object:nil];
}

@end
