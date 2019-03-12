//
//  XMQGDetialController.m
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMQGDetialController.h"
#import "XMQGDetialCell.h"

@interface XMQGDetialController ()<QMUITextViewDelegate>
@property(nonatomic,strong)QMUIButton *rejectBtn;
@property(nonatomic,strong)QMUIButton *agreeBtn;

@end

@implementation XMQGDetialController

-(void)setUpNavigationBar{
    self.navBar.hidden = NO;
    self.navBar.titleLabel.text = self.listModel.ProjectName;
    [self createSaveagreeBtn];
}
-(void)createSaveagreeBtn{
    Weak_Self;
    QMUIButton *rejectBt = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [rejectBt setTitle:@"驳回" forState:UIControlStateNormal];
    [rejectBt setTitleColor:Color_White forState:UIControlStateNormal];
    rejectBt.titleLabel.font = Font_System(16);
    [self.navBar addSubview:rejectBt];
    self.rejectBtn = rejectBt;
    [self.rejectBtn clickWithBlock:^{
        [weakSelf alertRejectView];
    }];

    QMUIButton *agreeBt = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [agreeBt setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBt setTitleColor:Color_White forState:UIControlStateNormal];
    agreeBt.titleLabel.font = Font_System(16);
    [self.navBar addSubview:agreeBt];
    self.agreeBtn = agreeBt;
    [self.agreeBtn clickWithBlock:^{
        [weakSelf alertAgreeView];
    }];
    [self.rejectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.navBar.mas_right);
        make.height.equalTo(44);
        make.width.equalTo(45);
    }];
    [self.agreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.rejectBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(45);
    }];
    [self.navBar.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navBar.rightButton.mas_left).offset(-SJYNUM(56));
    }];
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
        [weakSelf  requestData_XMQGDetial];
    }];

    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)requestData_XMQGDetial{
    [SJYRequestTool requestXMQGWithMarketOrderID:self.marketOrderID success:^(id responder){
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in rowsArr) {
            XMQGDetialModel *model = [XMQGDetialModel  modelWithDictionary:dic];
            model.titleStr = model.Model.length != 0? [model.Name stringByAppendingFormat:@"(%@)",model.Model]: model.Name;
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
    XMQGDetialCell *cell = [XMQGDetialCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    XMQGDetialModel *model =  self.dataArray[indexPath.row];
//
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
}



-(void)alertAgreeView{
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"提醒";

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
    contentView.backgroundColor = UIColorWhite;
    QMUILabel *label = [[QMUILabel alloc] init];
    label.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    label.font = Font_ListTitle;
    label.textColor = Color_TEXT_NOMARL;
    label.text = @"确定审核通过吗?";
    label.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [SJYRequestTool requestXMQGApprovelWithParam: @{
                                                        @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                                                        @"State":@"4",
                                                        @"MarketOrderID":self.marketOrderID,
                                                        @"PurchaseId": [SJYUserManager sharedInstance].sjyloginData.PurchaseId,  //(待办通知人Id,uc.PurchaseId，同意时必要回传)
                                                        @"RejectReason":@""//(驳回时必要回传参数)
                                                        } success:^(id responder) {
                                                            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                                                            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshXMQKListView" object:nil];
                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                });
                                                            }

                                                        } failure:^(int status, NSString *info) {
                                                            [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
                                                        }];

        [aDialogViewController hide];
    }];
    [dialogViewController show];
}

-(void)alertRejectView{
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"请输入驳回理由";

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    contentView.backgroundColor = UIColorWhite;
    QMUITextView *textView = [[QMUITextView alloc] init];
    [contentView addSubview:textView];
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    textView.shouldResponseToProgrammaticallyTextChanges = YES;
    textView.font = Font_ListTitle;
    textView.delegate = self;
    textView.maximumTextLength = 32;
    textView.maximumHeight = 90;
    textView.placeholder = @"请输入(限32字)";
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [textView endEditing:YES];
        NSString *content =  [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (content.length == 0) {
            [QMUITips showInfo:@"请输入驳回理由" inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            return ;
        }
        [SJYRequestTool requestXMQGApprovelWithParam: @{
                                                        @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                                                        @"State":@"3",
                                                        @"MarketOrderID":self.marketOrderID,
                                                        @"PurchaseId": [SJYUserManager sharedInstance].sjyloginData.PurchaseId,  //(待办通知人Id,uc.PurchaseId，同意时必要回传)
                                                        @"RejectReason":content//(驳回时必要回传参数)
                                                        } success:^(id responder) {
                                                            [aDialogViewController hide];
                                                            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                                                            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshXMQKListView" object:nil];
                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                });
                                                            }

                                                        } failure:^(int status, NSString *info) {
                                                            [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
                                                            [aDialogViewController hide];
                                                        }];


    }];
    [dialogViewController show];
    [textView becomeFirstResponder];
}
 
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (([text isEqualToString:@"\n"] || [text isEqualToString:@" "]) && textView.text.length == 0) {
//        return NO;
//    }
//    return YES;
//}
@end
