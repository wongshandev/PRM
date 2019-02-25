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

#define  ListModelSTATEArray  @[@"",@"计划",@"已提交",@"已驳回",@"财务已审",@"总经理已审",@"待付款",@"已付款",@"已入库"]
#define  ListSTATEColorArray  @[[UIColor whiteColor],UIColorHex(#007BD3),UIColorHex(#007BD3),UIColorHex(#FF0000),UIColorHex(#FE6D4B),UIColorHex(#EF5362),UIColorHex(#F79746),UIColorHex(#3FD0AD),UIColorHex(#2BBDF3)]
//#define  ListSTATEColorArray  @[[UIColor whiteColor],UIColorHex(#3FD0AD),UIColorHex(#007BD3),]

@interface SJYXCSHRecordController ()

@end

@implementation SJYXCSHRecordController


-(void)setUpNavigationBar{
    self.navBar.backButton.hidden = NO;
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
}

-(void)requestData_RecordList{
    [SJYRequestTool  requestXCSHRecordList:self.engineerModel.Id success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self.dataArray removeAllObjects];
        
        for (NSDictionary *dic in rowsArr) {
            XCSHRecordModel *model = [XCSHRecordModel  modelWithDictionary:dic];
            NSString *titlStr =  model.SiteState.integerValue == 1? [model.SupplierName stringByAppendingFormat:@"  (%@)  ",  @"采购接收"]: [model.Approval stringByAppendingFormat:@"  (%@)  ",  @"总部发货"];
            model.titleName = titlStr;
            BOOL isHav = [ListModelSTATEArray containsObject:model.StateName];
            model.stateColor = isHav?[ListSTATEColorArray objectAtIndex:[ListModelSTATEArray indexOfObject:model.StateName]]:Color_NavigationLightBlue;
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
        self.tableView.customMsg = !havError? @"没有数据了,休息一下吧":@"网络错误,请检查网络后重试";
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
    cell .indexPath = indexPath;
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
    NSLog(@"释放");
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
