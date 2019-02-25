//
//  CGFKDetialViewController.m
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "CGFKDetialViewController.h"
#import "CGFKDetialCell.h"
#import "CGFKDetialFrame.h"

@interface CGFKDetialViewController ()<QMUITextViewDelegate>
@property(nonatomic,strong)QMUIButton *rejectBtn;
@property(nonatomic,strong)QMUIButton *agreeBtn;
@end

@implementation CGFKDetialViewController
-(void)setUpNavigationBar{
    self.navBar.hidden = NO;
    self.navBar.titleLabel.text = self.listModel.Name;
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
    self.tableView.bounces =NO;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
}


-(void)bindViewModel{
    Weak_Self;
    [self  requestData_CGFKInfoData];
     self.tableView.refreshBlock = ^{
        [weakSelf  requestData_CGFKInfoData];
    };
 }

-(void)requestData_CGFKInfoData{
    [SJYRequestTool requestCGFKInfoDataWithPurchaseOrderID:self.listModel.Id success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        NSArray *footerArr = [responder objectForKey:@"footer"];

        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
 
        NSMutableArray *rowSectionArr = [NSMutableArray new];
        for (NSDictionary *dic in rowsArr) {
            CGFKDetialModel *model = [CGFKDetialModel  modelWithDictionary:dic];
            model.PriceStr = model.Price.length!= 0?[[NSString numberMoneyFormattor:model.Price] stringByAppendingString:@" (单价)"]:@"";
           model.QuantityStr = model.Quantity.length!= 0?[[NSString numberSepFormattor:model.Quantity] stringByAppendingString:@" (数量)"]:@"";
            CGFKDetialFrame *frame = [[CGFKDetialFrame alloc]init];
            frame.model = model;
              [rowSectionArr addObject:frame];
        }
        [self.dataArray addObject:rowSectionArr];
 
        NSMutableArray *footSectionArr = [NSMutableArray new];
        for (NSDictionary *dic in footerArr) {
            CGFKDetialModel *model = [CGFKDetialModel  modelWithDictionary:dic];

             [footSectionArr addObject:model];
        }
        [self.dataArray addObject:footSectionArr];
        
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 return CGFLOAT_MIN;
} 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CGFKDetialFrame *frame = self.dataArray[indexPath.section][indexPath.row];
        return frame.cellHeight;
    }
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFKDetialCell *cell = [CGFKDetialCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.data = self.dataArray[indexPath.section][indexPath.row];
        [cell loadContent];
        return cell; 
    }else{
        CGFKDetialFootCell *cell = [CGFKDetialFootCell cellWithTableView:tableView];
        cell .indexPath = indexPath;
        cell.data = self.dataArray[indexPath.section][indexPath.row];
        [cell loadContent];
        return cell;
    }
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
        [SJYRequestTool requestCGFKAgreeReject: @{
                                                        @"PurchaseOrderID":self.listModel.Id,
                                                        @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                                                        @"State":@"5",
                                                         @"RejectReason":@""//(驳回时必要回传参数)
                                                        } success:^(id responder) {
                                                            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                                                            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCGFKListView" object:nil];
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
        if (textView.text.length == 0) {
            [QMUITips showInfo:@"请输入驳回原因" inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            return ;
        }
        [SJYRequestTool requestCGFKAgreeReject:@{
                                                        @"PurchaseOrderID":self.listModel.Id,
                                                        @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                                                        @"State":@"3",
                                                        @"RejectReason":textView.text//(驳回时必要回传参数)
                                                        } success:^(id responder) {
                                                            [aDialogViewController hide];
                                                            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                                                            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCGFKListView" object:nil];
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


@end
