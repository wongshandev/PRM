//
//  JDHBListController.m
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "JDHBListController.h"
#import "JDHBListCell.h"
#import "JDHBListModel.h"
#import "NumTFBZTVAlertView.h"

@interface JDHBListController()<QMUITextViewDelegate,QMUITextFieldDelegate>

@property(nonatomic,strong)QMUIFillButton *updateBtn;
@property(nonatomic,strong)NumTFBZTVAlertView *alertView;
@property(nonatomic,strong)NSMutableDictionary <NSString *, NSMutableDictionary *>*insertDic;

@end

@implementation JDHBListController
-(NSMutableDictionary<NSString *,NSMutableDictionary *> *)insertDic{
    if (!_insertDic) {
        _insertDic = [NSMutableDictionary new];
    }
    return _insertDic;
}
-(NSMutableArray *)updateArray{
    if (!_updateArray) {
        _updateArray= [NSMutableArray new];
    }
    return _updateArray;
}

-(void)setUpNavigationBar{
    self.navBar.hidden = YES;
    //    Weak_Self;
    //    [self.navBar.backButton clickWithBlock:^{
    //        if (weakSelf.updateArray.count != 0) {
    //            [weakSelf alertWithSaveMention:@"您修改了进度 , 需要保存吗?" withAction:@selector(update_JDHBData)];
    //            return;
    //        }
    //        [weakSelf.navigationController popViewControllerAnimated:YES];
    //    }];
}
-(void)buildSubviews{
    Weak_Self;
    QMUIFillButton *btn = [QMUIFillButton  buttonWithType:UIButtonTypeCustom];
    btn.fillColor = Color_NavigationLightBlue;
    [btn setImage:SJYCommonImage(@"save_n") forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:btn];
    self.updateBtn = btn;
    [self.updateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.height.equalTo(60);
        make.width.equalTo(60);
    }];
    [self.updateBtn rounded:30];
    [self.updateBtn clickWithBlock:^{
        [weakSelf update_JDHBData];
    }];
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
    [self.view bringSubviewToFront:self.updateBtn];
}

-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  requestData_JDHB];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

#pragma mark -----------------------------进度汇报列表
-(void)requestData_JDHB{
    [SJYRequestTool requestJDHBListWithProjectBranchID: self.engineerModel.Id success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
            [self.insertDic removeAllObjects];
            [self.updateArray removeAllObjects];
        }
        
        for (NSDictionary *dic in rowsArr) {
            JDHBListModel *model = [JDHBListModel  modelWithDictionary:dic];
            model.titleStr =  model.ChildName.length==0?model.Name:[model.Name stringByAppendingFormat:@" (%@)",model.ChildName];
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
#pragma mark -----------------------------进度汇报 更新
-(void)update_JDHBData{
    if (self.updateArray.count == 0) {
        [QMUITips showInfo:@"无数据需要提交" inView:self.view hideAfterDelay:1.2];
        return ;
    }

    NSString *jsonStr = [self.updateArray modelToJSONString];
    [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
    [SJYRequestTool requestJDHBUpdateWithEmployeeID:[SJYUserManager sharedInstance].sjyloginUC.Id updated:jsonStr success:^(id responder) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [self.updateArray removeAllObjects];
            [self.tableView.mj_header beginRefreshing];
        }
    } failure:^(int status, NSString *info) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
    }];
}
-(void)update_JDHBDataForParentVC{
    if (self.updateArray.count == 0) {
        [QMUITips showInfo:@"无数据需要提交" inView:self.view hideAfterDelay:1.2];
        return ;
    }

    NSString *jsonStr = [self.updateArray modelToJSONString];
    [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
    [SJYRequestTool requestJDHBUpdateWithEmployeeID:[SJYUserManager sharedInstance].sjyloginUC.Id updated:jsonStr success:^(id responder) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [self.updateArray removeAllObjects];
            dispatch_after(1.2, dispatch_get_main_queue(), ^{
                [self.parentViewController.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(int status, NSString *info) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
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
#pragma mark -----------------------------tableView delegate / dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDHBListCell *cell = [JDHBListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    JDHBListModel *model = self.dataArray[indexPath.row];
    Weak_Self;
    kWeakSelf(cell);
    cell.savDataBlock = ^(NSMutableDictionary * cellDic) {
        if (![cellDic[@"CompletionRate"] isEqualToString:model.CompletionRate]
            || ![cellDic[@"Remark"] isEqualToString:model.Remark]) {
            [weakSelf.insertDic setValue:cellDic forKey:@(indexPath.row).stringValue];
        }
        [weakSelf.tableView reloadRow:weakcell.indexPath.row inSection:weakcell.indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    };
    NSArray *indexArr = self.insertDic.allKeys;
    if ([indexArr containsObject:@(indexPath.row).stringValue]) {
        cell.cellDic =  self.insertDic[@(indexPath.row).stringValue] ;
    }else{
        cell.data = model;
        [cell loadContent];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDHBListModel *model = self.dataArray[indexPath.row];
    JDHBListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self click_ProgressReportCell:cell alertViewWithModel:model];
    //    [self clickProgressReportCell:cell alertViewWithModel:model];
}
#pragma mark ---------------- QMUIDialogViewController 处理
-(void)click_ProgressReportCell:(JDHBListCell *)cell alertViewWithModel:(JDHBListModel *)model{
    if (model.CompletionRate.integerValue >=100) {
        return;
    }
    //创建弹窗 对话框
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = model.Name;
    dialogViewController.headerViewHeight = 40;
    dialogViewController.headerSeparatorColor = UIColorWhite;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;

    //对话框的view 即 自定义内容页
    self.alertView = [[NumTFBZTVAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W -20 *2, 180)];
    self.alertView.backgroundColor = UIColorWhite;

    self.alertView.numMentionLab.text = [NSString stringWithFormat:@"可输入范围: %@ ~ 100",model.CompletionRate];
    //TextField 配置
    self.alertView.numTF.delegate = self;
    self.alertView.numTF.placeholder =@"请输入进度";
    self.alertView.numTF.text = [cell.cellDic[@"CompletionRate"] integerValue] == 0 ?@"": cell.cellDic[@"CompletionRate"];

    [self.alertView.numTF addTarget:self action:@selector(alert_TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //textView 配置
    self.alertView.BZTV.delegate = self;
    self.alertView.BZTV.text = cell.cellDic[@"Remark"];

    //内容页子控件  布局处理
    [self.alertView.numMentionLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.mas_top).mas_offset(NumTFPading);
        make.left.mas_equalTo(self.alertView.mas_left).mas_offset(NumTFMargin);
        make.right.mas_equalTo(self.alertView.mas_right).mas_offset(-NumTFMargin);
        make.height.mas_equalTo(MentionHeight);
    }];
    [self.alertView.numTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.numMentionLab.mas_bottom).mas_offset(NumTFPading);
        make.left.mas_equalTo(self.alertView.mas_left).mas_offset(NumTFMargin);
        make.right.mas_equalTo(self.alertView.mas_right).mas_offset(-NumTFMargin);
        make.height.mas_equalTo(NumTFHeight);
    }];
    [self.alertView.sepLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.numTF.mas_bottom);
        make.left.mas_equalTo(self.alertView.numTF.mas_left);
        make.right.mas_equalTo(self.alertView.numTF.mas_right);
        make.height.mas_equalTo(2);
    }];
    [self.alertView.bzMentionLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.sepLine.mas_bottom).offset(NumTFPading);
        make.left.mas_equalTo(self.alertView.numTF.mas_left);
        make.right.mas_equalTo(self.alertView.numTF.mas_right);
        make.height.mas_equalTo(MentionHeight);
    }];
    [self.alertView.BZTV makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView.bzMentionLab.mas_bottom).offset(NumTFPading);
        make.left.mas_equalTo(self.alertView.numTF.mas_left);
        make.right.mas_equalTo(self.alertView.numTF.mas_right);
        make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(-NumTFPading);
    }];

    //    Weak_Self;
    dialogViewController.contentView = self.alertView;

    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [self.alertView.BZTV endEditing:YES];
        //  cell 界面 数据 的调整
        if ([self.alertView.numTF.text integerValue] > 100 ) {
            cell.cellDic[@"CompletionRate"] = @"100";
            [QMUITips showInfo:@"超出默认范围上限" inView:self.view hideAfterDelay:1.2];
        }else if([self.alertView.numTF.text integerValue] < model.CompletionRate.integerValue){
            cell.cellDic[@"CompletionRate"] = model.CompletionRate;
            [QMUITips showInfo:@"超出默认范围下限" inView:self.view hideAfterDelay:1.2];
        }else{
            cell.cellDic[@"CompletionRate"] = self.alertView.numTF.text.length==0?model.CompletionRate:self.alertView.numTF.text;
        }
        cell.cellDic[@"Remark"] = self.alertView.BZTV.text;
        cell.cellDic = cell.cellDic;
        
        //FIXME: 新建并存储 修改后的内容到更新数组
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", model.Id];
        NSMutableDictionary *havDic = [self.updateArray filteredArrayUsingPredicate:predicate].firstObject; 
        if (![cell.cellDic[@"CompletionRate"] isEqualToString:model.CompletionRate] || ![cell.cellDic[@"Remark"] isEqualToString:model.Remark]) {
            //数据处理 添加进入数组
            NSMutableDictionary *currentDic= [NSMutableDictionary dictionary];
            [currentDic setValue:cell.cellDic[@"CompletionRate"] forKey:@"CompletionRate"];
            [currentDic setValue:cell.cellDic[@"Remark"] forKey:@"Remark"];
            [currentDic setValue:model.Id forKey:@"Id"];

            if (havDic) {
                if (![[havDic valueForKey:@"Remark"] isEqualToString:[currentDic valueForKey:@"Remark"]] || ![[havDic valueForKey:@"CompletionRate"] isEqualToString:[currentDic valueForKey:@"CompletionRate"]]) {
                    [havDic setValue:cell.cellDic[@"CompletionRate"] forKey:@"CompletionRate"];
                    [havDic setValue:cell.cellDic[@"Remark"] forKey:@"Remark"];
                }
            }else{
                [self.updateArray addObject:currentDic];
            }
            NSLog(@"%@", self.updateArray);
        }else{
            if (havDic) {
                [self.updateArray removeObject:havDic];
            }
        }
        //FIXME: 存储更改后的数据到 字典内 便于滑动时进行加载修改后的数据
        if (cell.savDataBlock) {
            cell.savDataBlock(cell.cellDic);
        }
        [aDialogViewController hide];
    }];
    dialogViewController.submitButton.enabled = (self.alertView.numTF.text.length || self.alertView.BZTV.text.length);
    [dialogViewController show];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.alertView.sepLine.backgroundColor = Color_NavigationLightBlue;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.alertView.sepLine.backgroundColor = Color_SrprateLine;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    //结束编辑时移除首尾的空格和换行
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(void)textViewDidChange:(QMUITextView *)textView{
    QMUIDialogViewController *adialogVC = (QMUIDialogViewController *)self.alertView.viewController;
    QMUIButton *okAction = adialogVC.submitButton;
    okAction.enabled = self.alertView.numTF.text.length || self.alertView.BZTV.text.length;
}
- (void)alert_TextFieldDidChange:(QMUITextField *)textField{
    QMUIDialogViewController *adialogVC = (QMUIDialogViewController *)self.alertView.viewController;
    QMUIButton *okAction = adialogVC.submitButton;
    okAction.enabled = textField.text.length || self.alertView.BZTV.text.length;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str =[textField.text stringByAppendingString:string];
    if (![NSString isAvailableStr:str WithFormat:@"^(0|[1-9][0-9]*)$"]) {
        return NO;
    }
    if (str.integerValue > 100) {// ||  (str.integerValue < self.minNumThis.integerValue)
        return NO;
    }
    return YES;
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
