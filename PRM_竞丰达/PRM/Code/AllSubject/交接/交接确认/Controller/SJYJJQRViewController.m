//
//  SJYJJQRViewController.m
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYJJQRViewController.h"
#import "SJYJJQRListCell.h"
#import "JJQRFTInfotModel.h"

@interface SJYJJQRViewController ()

@end

@implementation SJYJJQRViewController

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
-(void)bindViewModel {
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  request_JJQRData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)request_JJQRData{
    NSString *apiStr;
    if (KJumpURLToEnum(self.mainModel.url) == FileTransferEngineering ) {
        apiStr = API_JJQR_GCB;
    }
    if (KJumpURLToEnum(self.mainModel.url) == FileTransfer) {
        apiStr = API_JJQR_SCB;
        
    }
    if (KJumpURLToEnum(self.mainModel.url) == FileTransferDesign) {
        apiStr = API_JJQR_JSB;
    }
    
    [SJYRequestTool requestJJQRListWithAPIUrl:apiStr EmployID:[SJYUserManager sharedInstance].sjyloginUC.Id success:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *rowsArr = [responder objectForKey:@"rows"];
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *dic in rowsArr) {
                SJYJJQRListModel  *model = [SJYJJQRListModel  modelWithDictionary:dic];
                if (KJumpURLToEnum(self.mainModel.url) == FileTransferEngineering) { // 工程
                    model.titleStr = [model.Name stringByAppendingFormat:@" (%@)",model.ProjectTypeName];
                }
                if (KJumpURLToEnum(self.mainModel.url) == FileTransfer) { // 市场
                    model.titleStr =  model.Name ;
                }
                if (KJumpURLToEnum(self.mainModel.url) == FileTransferDesign) { //设计/技术
                    model.titleStr =  model.Name ;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SJYJJQRListCell *cell = [SJYJJQRListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.cellType =CellType_JJQRList;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SJYJJQRListModel *model = self.dataArray[indexPath.row];
    //    if (KJumpURLToEnum(self.mainModel.url) == FileTransferEngineering) { //工程
    //     }
    //    if (KJumpURLToEnum(self.mainModel.url) == FileTransfer) { // 市场
    //     }
    //    if (KJumpURLToEnum(self.mainModel.url) == FileTransferDesign) { //设计/技术
    //     }
    
    [self  requestAppGetFTInfoWithProjectBranchID:model];
    
}

-(void)requestAppGetFTInfoWithProjectBranchID:(SJYJJQRListModel *)listModel{
    [QMUITips showLoadingInView:self.view];
    [SJYRequestTool requestJJQRFTInfoWithProjectBranchID:listModel.Id success:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [QMUITips hideAllTips];
            JJQRFTInfotModel *model = [JJQRFTInfotModel modelWithJSON:responder];
            if ([listModel.Id isEqualToString:model.ProjectBranchID]) {
                [self showJJQRAlertViewWithInfoModel:model listModel:listModel];
            }
            else{
                
            }
        });
    } failure:^(int status, NSString *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips hideAllTips];
            [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
        });
    }];
}

- (void)showJJQRAlertViewWithInfoModel:(JJQRFTInfotModel *)infotModel listModel:(SJYJJQRListModel *)listModel{
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.maximumContentViewWidth = SCREEN_W - 2*30;
    dialogViewController.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    dialogViewController.tableView.separatorInset = UIEdgeInsetsZero;
    dialogViewController.title = @"交接详情";
    dialogViewController.items = @[@"工程合同", @"设备清单", @"方案图纸"];
    dialogViewController.allowsMultipleSelection = YES;// 打开多选
    
    // 设置是否可以选择
    if (KJumpURLToEnum(self.mainModel.url) == FileTransferEngineering) { //工程
        dialogViewController.tableView.userInteractionEnabled = NO;
    }
    if (KJumpURLToEnum(self.mainModel.url) == FileTransfer) { // 市场
        dialogViewController.titleView.subtitle = @"可多选";
        dialogViewController.tableView.userInteractionEnabled = YES;
    }
    if (KJumpURLToEnum(self.mainModel.url) == FileTransferDesign) { //设计/技术
        dialogViewController.tableView.userInteractionEnabled = NO;
    }
    //添加勾选项
    if (infotModel.HaveAgreement.boolValue) {
        [dialogViewController.selectedItemIndexes addObject:@(0)];
    }
    if (infotModel.HaveDeepenDesign.boolValue) {
        [dialogViewController.selectedItemIndexes addObject:@(1)];
    }
    if (infotModel.HaveProgram.boolValue) {
        [dialogViewController.selectedItemIndexes addObject:@(2)];
    }
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        if ([aDialogViewController.selectedItemIndexes containsObject:@(itemIndex)]) {
            cell.selected = YES;
        }
        cell.textLabel.textColor = aDialogViewController.tableView.userInteractionEnabled? Color_TEXT_HIGH : Color_TEXT_NOMARL;
    };
    
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    Weak_Self;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *dialogVC = (QMUIDialogSelectionViewController *)aDialogViewController;
        
        NSString *apiUrl;
        NSMutableDictionary *paraDic = [@{
            @"ProjectBranchID":listModel.Id,
            @"EmployeeID":[SJYUserManager sharedInstance].sjyloginUC.Id
        } mutableCopy];
        if (KJumpURLToEnum(self.mainModel.url) == FileTransferEngineering) { //工程
            apiUrl = API_JJQRSubmit_GCB;
        }
        if (KJumpURLToEnum(self.mainModel.url) == FileTransfer) { // 市场
            apiUrl = API_JJQRSubmit_SCB;
            [paraDic setValue:[dialogVC.selectedItemIndexes containsObject:@0]?@"1":@"0" forKey:@"HaveAgreement"];
            [paraDic setValue:[dialogVC.selectedItemIndexes containsObject:@1]?@"1":@"0" forKey:@"HaveDeepenDesign"];
            [paraDic setValue:[dialogVC.selectedItemIndexes containsObject:@2]?@"1":@"0" forKey:@"HaveProgram"];
        }
        if (KJumpURLToEnum(self.mainModel.url) == FileTransferDesign) { //设计/技术
            apiUrl = API_JJQRSubmit_JSB;
        }
        [SJYRequestTool requestJJQRRTFTInfoSubmitWithAPIUrl:apiUrl params:paraDic success:^(id responder) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [dialogVC hide];
                [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                if ([[responder valueForKey:@"success"] boolValue]== YES) {
                    [weakSelf.tableView.mj_header beginRefreshing];
                }
            });
        } failure:^(int status, NSString *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
                [dialogVC hide];
            });
        }];
    }];
    [dialogViewController show];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


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

