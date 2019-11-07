//
//  SJYXMKZListController.m
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYXMKZListController.h"
#import "XMKZListCell.h"
#import "SJYXMKZDetialListController.h"

@interface SJYXMKZListController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;

@end

@implementation SJYXMKZListController 

-(void)setUpNavigationBar{
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    
}

-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}
-(void)refreshCurrentList{
    self.page = 0;
    [self requestData_XMKZList];
}
#pragma mark ======================= 数据绑定
-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData_XMKZList];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        
        [weakSelf requestData_XMKZList];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCurrentList) name:@"refreshXMKZViewControllerList" object:nil];
}

-(void)requestData_XMKZList {
    [SJYRequestTool requestXMKZListWithPage:self.page success:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *rowsArr = [responder objectForKey:@"rows"];
            self.totalNum = [[responder objectForKey:@"total"] integerValue];
            if (self.tableView.mj_header.isRefreshing) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in rowsArr) {
                XMKZListModel *model = [XMKZListModel  modelWithDictionary:dic];
                model.titleStr = [model.Name stringByAppendingFormat:@"(%@)",model.ProjectTypeName];
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
    XMKZListCell *cell = [XMKZListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMKZListModel *model =  self.dataArray[indexPath.row];
    SJYXMKZDetialListController *detialVC = [[SJYXMKZDetialListController alloc]init];
    detialVC.listModel = model;
    //    detialVC.title = @"开支详情";
    detialVC.title =  model.Name;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshXMKZViewControllerList" object:nil];
}




@end
