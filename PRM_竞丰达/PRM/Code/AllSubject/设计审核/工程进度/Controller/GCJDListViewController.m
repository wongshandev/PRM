//
//  GCJDListViewController.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "GCJDListViewController.h"
#import "GCJDListCell.h"

@implementation GCJDListViewController

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
}


-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  requestData_SJSH_GCJD];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

#pragma mark -----------------------------进度汇报列表

-(void)requestData_SJSH_GCJD{
    [SJYRequestTool requestSJSHWithAPI:API_SJSH_GCJDList parameters:
     @{
         @"DeepenDesignID":self.sjshListModel.Id
     }   success:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView.mj_header.isRefreshing) {
                [self.dataArray removeAllObjects];
            }
            NSArray *rowsArr = [responder objectForKey:@"rows"];
            
            for (NSDictionary *dic in rowsArr) {
                GCJDListModel *model = [GCJDListModel  modelWithDictionary:dic];
                model.titleStr = model.ChildName.length?[model.Name stringByAppendingFormat:@"(%@)",model.ChildName]:model.Name;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GCJDListCell *cell = [GCJDListCell cellWithTableView:tableView];
    GCJDListModel *model =  self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.data = model;
    [cell loadContent];
    return cell;
}
@end
