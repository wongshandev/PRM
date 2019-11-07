//
//  WLJHListController.m
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "WLJHListController.h"
#import "WLJHListCell.h"
#import "WLJHDetialController.h"

#define  ListWLJHStateArray  @[@"", @"已计划", @"已申请", @"已驳回", @"已审核", @"已下单",@"已采购" ,@"已完成"]
@interface WLJHListController ()
@property(copy,nonatomic)NSString *dState;
@property(nonatomic,strong)QMUIFillButton *addBtn;

@end


@implementation WLJHListController

-(void)setUpNavigationBar{
    self.navBar.hidden = YES;
}


-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    Weak_Self;
    QMUIFillButton *addButton = [QMUIFillButton  buttonWithType:UIButtonTypeCustom];
    addButton.fillColor = Color_NavigationLightBlue;
    [addButton setImage:SJYCommonImage(@"add_press") forState:UIControlStateNormal];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:addButton];
    self.addBtn = addButton;
    [self.addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.height.equalTo(60);
        make.width.equalTo(60);
    }];
    [self.addBtn rounded:30];
    [self.addBtn clickWithBlock:^{
        //        [weakSelf update_JDHBData];
        WLJHDetialController *detialVC =  [[WLJHDetialController alloc] init];
        
        WLJHListModel *newModel = [[WLJHListModel alloc] init];
        newModel.State = @"-888";
        
        detialVC.wlListModel = newModel;
        detialVC.marketOrderID = @"0";
        detialVC.projectBranchID = self.engineerModel.Id;
        detialVC.dState = self.dState;
        detialVC.title= @"新增物料详情";
        [weakSelf.navigationController pushViewController:detialVC animated:YES];
    }];
}


-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  requestData_WLJH];
    }];
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListView) name:@"refreshListView" object:nil];
}

-(void)requestData_WLJH{
    [SJYRequestTool requestWLJHListWithProjectBranchID: self.engineerModel.Id success:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.tableView.mj_header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            self.dState = [responder objectForKey:@"dState"];
            self.addBtn.hidden = self.dState.integerValue < 7;
            NSArray *rowsArr = [responder objectForKey:@"rows"];
            for (NSDictionary *dic in rowsArr) {
                WLJHListModel *model = [WLJHListModel  modelWithDictionary:dic];
                if (model.State.integerValue < ListWLJHStateArray.count ) {
                    model.stateString = [ListWLJHStateArray objectAtIndex:model.State.integerValue];
                    StateCode idx = [StateCodeStringArray indexOfObject:model.stateString];
                    model.stateColor =   [StateCodeColorHexArray objectAtIndex:idx];
                }
                
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [self endRefreshWithError:NO];
        });
    } failure:^(int status, NSString *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
            [self.tableView reloadData];
            [self endRefreshWithError:YES];
        });
    }];
}
-(void)endRefreshWithError:(BOOL)havError{
    [self.tableView.mj_header endRefreshing];
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
    WLJHListCell *cell = [WLJHListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.cellType = CellType_WLJH;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLJHListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    WLJHDetialController *detialVC =  [[WLJHDetialController alloc] init];
    detialVC.title= @"物料详情";
    //    if (self.dState.integerValue >= 7 && (model.State.integerValue == 3 || model.State.integerValue ==1)) {
    //        detialVC.title = @"修改物料详情";
    //    }
    detialVC.dState = self.dState;
    detialVC.marketOrderID = model.Id;
    detialVC.projectBranchID = self.engineerModel.Id;
    detialVC.wlListModel = model;
    [self.navigationController pushViewController:detialVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshListView" object:nil];
}

-(void)refreshListView{
    [self.tableView.mj_header beginRefreshing];
}
@end
