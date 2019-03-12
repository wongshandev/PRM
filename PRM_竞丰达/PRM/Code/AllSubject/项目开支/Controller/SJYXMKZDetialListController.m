//
//  SJYXMKZDetialListController.m
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYXMKZDetialListController.h"
#import "XMKZDetialListCell.h"
#import "XMKZDetialController.h"

#define  ListXMKZDetialStateArray  @[@"",@"计划",@"已提交",@"已驳回",@"主管已审",@"财务已审",@"总经理已审",@"待付款",@"已完成"]

@interface SJYXMKZDetialListController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;
@property(nonatomic,assign)BOOL isNeedRefreshFrontList;

@end

@implementation SJYXMKZDetialListController


-(void)setUpNavigationBar{
    self.navBar.titleLabel.text = self.title;
    [self.navBar.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    self.navBar.rightButton.hidden = NO;
    Weak_Self;
    [self.navBar.rightButton clickWithBlock:^{
        XMKZDetialController *xmkzVC = [[XMKZDetialController alloc]init];
        XMKZDetialListModel *model = [[XMKZDetialListModel alloc] init];
        model.Id = @"0";
        model.SpendingTypeID = @"";
        model.SpendingTypeIDChange = @"";
        model.OccurDate = @"";
        model.OccurDateChange = @"";
        model.Remark = @"";
        model.RemarkChange = @"";
        model.Amount = @"0.00";
        model.AmountChange = @"0.00";
        model.SpndingTypeName = @"";
        model.SpndingTypeNameChange = @"";
        model.modelType = ModelType_XMKZ;
        
        xmkzVC.detialModel = model;
        xmkzVC.listModel = self.listModel;
        xmkzVC.title =  weakSelf.title;
        [weakSelf.navigationController pushViewController:xmkzVC animated:YES];
    }];
}

-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCurrentList) name:@"refreshSJYXMKZDetiallList" object:nil];
}
-(void)refreshCurrentList{
    self.isNeedRefreshFrontList = YES;
    if (self.isNeedRefreshFrontList) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshXMKZViewControllerList" object:nil];
    }
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark ======================= 数据绑定
-(void)bindViewModel{
    self.isNeedRefreshFrontList = NO;
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf requestData_XMKZDetialList];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;

        [weakSelf requestData_XMKZDetialList];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)requestData_XMKZDetialList {

    [SJYRequestTool requestXMKZDetialListWithProjectBranchID:self.listModel.Id Page:self.page success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        NSArray *spendingTypeArray = [SJYDefaultManager shareManager].getXMKZSpendTypeArray;
        for (NSDictionary *dic in rowsArr) {
            XMKZDetialListModel  *model = [XMKZDetialListModel  modelWithDictionary:dic];
            model.modelType = ModelType_XMKZ;

            model.SpendingTypeIDChange = model.SpendingTypeID;
            model.OccurDateChange = model.OccurDate;
            model.RemarkChange = model.Remark;
            model.AmountChange = model.Amount;

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", model.SpendingTypeID];
            XMKZSpendTypeModel *typeModel =  [spendingTypeArray filteredArrayUsingPredicate:predicate].firstObject;
            model.SpndingTypeName = typeModel.name;
            model.SpndingTypeNameChange = model.SpndingTypeName;

            model.titleStr = [model.ApplyName stringByAppendingFormat:@"(%@)",model.SpndingTypeName];
            model.stateString = [ListXMKZDetialStateArray objectAtIndex:model.State];
            StateCode idx = [StateCodeStringArray indexOfObject:model.stateString];
            model.stateColor =   [StateCodeColorHexArray objectAtIndex:idx];  

            [self.dataArray addObject:model];
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
    XMKZDetialListCell *cell = [XMKZDetialListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMKZDetialListModel *model =  self.dataArray[indexPath.row];
    XMKZDetialController *xmkzVC = [[XMKZDetialController alloc]init];
    xmkzVC.detialModel = model;
    xmkzVC.listModel = self.listModel;
    xmkzVC.title =  self.title;
    [self.navigationController pushViewController:xmkzVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSJYXMKZDetiallList" object:nil];
}


 
@end
