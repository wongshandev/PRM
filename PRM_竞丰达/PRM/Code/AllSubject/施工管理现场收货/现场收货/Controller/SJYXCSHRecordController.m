//
//  SJYXCSHRecordController.m
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYXCSHRecordController.h"
#import "XCSHRecordModel.h"
#import "XCSCRecordCell.h"
#import "XCSHRecordDetialController.h"

#define  ListXCSHStateArray  @[@"",@"已计划",@"已申请",@"已驳回",@"已审核",@"已下单",@"已采购",@"已完成"]
@interface SJYXCSHRecordController ()

@end

@implementation SJYXCSHRecordController


-(void)setUpNavigationBar{
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.engineerModel.Name;
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
        [weakSelf requestData_RecordList];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshXCSHRecordListView) name:@"refreshXCSHRecordListView" object:nil];

}

-(void)requestData_RecordList{
//    value == 1 ? "已计划" : value == 2 ? "已申请" : value == 3 ? "已驳回" : value == 4 ? "已审核" : value == 5 ? "已下单" : value == 6 ? "已采购" : "已完成"
    [SJYRequestTool  requestXCSHRecordList:self.engineerModel.Id success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self.dataArray removeAllObjects];
        
        for (NSDictionary *dic in rowsArr) {
            XCSHRecordModel *model = [XCSHRecordModel  modelWithDictionary:dic];
            NSString *titlStr =  model.SiteState.integerValue == 1? [model.SupplierName stringByAppendingFormat:@"  (%@)  ",  @"采购接收"]: [model.Approval stringByAppendingFormat:@"  (%@)  ",  @"总部发货"];
            model.titleName = titlStr;

            BOOL isHav = [StateCodeStringArray containsObject:model.StateName];
            StateCode idx = [StateCodeStringArray indexOfObject:model.StateName];
            model.stateColor = isHav ?  [StateCodeColorHexArray objectAtIndex:idx] : StateCodeColorHexArray.firstObject;

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
    XCSCRecordCell *cell = [XCSCRecordCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XCSHRecordModel*model = [self.dataArray objectAtIndex:indexPath.row];
    XCSHRecordDetialController *detialVC =  [[XCSHRecordDetialController alloc] init];
    detialVC.recordModel = model;
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshXCSHRecordListView" object:nil];
}
-(void)refreshXCSHRecordListView{
    [self.tableView.mj_header beginRefreshing];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
