//
//  SJYXMBGViewController.m
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYXMBGViewController.h"
#import "XMBGListCell.h"
#import "XMBGDetialController.h"

@interface SJYXMBGViewController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;

@end

@implementation SJYXMBGViewController


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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCurrentList) name:@"refreshSJYXMBGViewControllerList" object:nil];
}
-(void)refreshCurrentList{
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark ======================= 数据绑定
-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf requestData_XMBG];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;

        [weakSelf requestData_XMBG];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)requestData_XMBG {
    [SJYRequestTool requestXMBGList:[SJYUserManager sharedInstance].sjyloginUC.Id page:self.page SearchCode:@"" success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        if (self.tableView.mj_header.isRefreshing) {
                 [self.dataArray removeAllObjects]; 
        } 
        for (NSDictionary *dic in rowsArr) {
            XMBGListModel *model = [XMBGListModel  modelWithDictionary:dic];
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
    XMBGListCell *cell = [XMBGListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMBGListModel *model =  self.dataArray[indexPath.row];
    XMBGDetialController *detialVC = [[XMBGDetialController alloc]init];
    detialVC.listModel = model;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSJYXMBGViewControllerList" object:nil];
}


@end
