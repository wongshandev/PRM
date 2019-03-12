//
//  SJYXMJDViewController.m
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYXMJDViewController.h"
#import "XMJDListCell.h"
#import "XMJDGanttController.h"
@interface SJYXMJDViewController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;

@end

@implementation SJYXMJDViewController


-(void)setUpNavigationBar{
    self.navBar.hidden = NO;
    self.navBar.titleLabel.text = self.title;
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
        [weakSelf  requestData_XMQG];
    }];


    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf  requestData_XMQG];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshListView) name:@"refreshXMQKListView" object:nil];

}

-(void)requestData_XMQG{
    [SJYRequestTool requestXMJDListWithPage:self.page  success:^(id responder) {
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        if (self.tableView.mj_header.isRefreshing) {
                 [self.dataArray removeAllObjects]; 
        }
        for (NSDictionary *dic in rowsArr) {
            XMJDListModel *model = [XMJDListModel  modelWithDictionary:dic];
            model.titleStr = model.Address.length? [model.Name stringByAppendingFormat:@" (%@)",model.Address]:model.Name;
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
    XMJDListCell *cell = [XMJDListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMJDListModel *model =  self.dataArray[indexPath.row];
    XMJDGanttController *detialVC = [[XMJDGanttController alloc] init];
    detialVC.listModel = model;
    detialVC.title = model.Name;
    [self.navigationController pushViewController:detialVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshXMQKListView" object:nil];
}


-(void)refreshListView{
    [self.tableView.mj_header beginRefreshing];
}


@end
