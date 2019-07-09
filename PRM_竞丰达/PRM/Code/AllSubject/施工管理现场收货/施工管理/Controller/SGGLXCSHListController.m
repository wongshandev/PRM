//
//  SGGLXCSHListController.m
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SGGLXCSHListController.h"
#import "SGGLXCSHListCell.h"
#import "EngineeringModel.h"


//施工管理
#import "SJYSGGLDetailController.h"
//现场收货
#import "SJYXCSHRecordController.h"

@interface SGGLXCSHListController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;

@end

@implementation SGGLXCSHListController

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
#pragma mark ======================= 数据绑定
-(void)bindViewModel{
    Weak_Self;
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (KJumpURLToEnum(weakSelf.mainModel.url) == Engineering) {  //施工管理
            [weakSelf  requestData_SGGL];
        }
        if (KJumpURLToEnum(weakSelf.mainModel.url) == Procurement) { //现场收货
            weakSelf.page = 1;
            [weakSelf  requestData_XCSH];
        }
    }];

    
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (KJumpURLToEnum(weakSelf.mainModel.url) == Engineering) { //施工管理
//            [weakSelf  requestData_SGGL];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (KJumpURLToEnum(weakSelf.mainModel.url) == Procurement) {  //现场收货
            weakSelf.page ++;
            [weakSelf  requestData_XCSH];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)requestData_SGGL{
    [SJYRequestTool requestSGGLListWithEmployId:[SJYUserManager sharedInstance].sjyloginUC.Id page:self.page  success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
        } 
        for (NSDictionary *dic in rowsArr) {
            EngineeringModel *model = [EngineeringModel  modelWithDictionary:dic];
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
-(void)requestData_XCSH{
    [SJYRequestTool requestXCSHList: [SJYUserManager sharedInstance].sjyloginUC.Id page:self.page success:^(id responder) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
        }
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        for (NSDictionary *dic in rowsArr) {
            EngineeringModel *model = [EngineeringModel  modelWithDictionary:dic];
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
    if (KJumpURLToEnum(self.mainModel.url) == Procurement) {  //现场收货
        if (self.dataArray.count < self.totalNum) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
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
    SGGLXCSHListCell *cell = [SGGLXCSHListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EngineeringModel *model =  self.dataArray[indexPath.row];
    if (KJumpURLToEnum(self.mainModel.url) == Engineering) {  //施工管理
        SJYSGGLDetailController *sgglVC = [[SJYSGGLDetailController alloc] init];
        sgglVC.engineerModel = model;
        [self.navigationController pushViewController:sgglVC  animated:YES];
    }
    if (KJumpURLToEnum(self.mainModel.url) == Procurement) { //现场收货
        SJYXCSHRecordController *xcshVC = [[SJYXCSHRecordController alloc] init];
        xcshVC.engineerModel = model;
        [self.navigationController pushViewController:xcshVC  animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
}


@end
