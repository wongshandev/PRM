//
//  XCSHRecordDetialController.m
//  PRM
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XCSHRecordDetialController.h"
#import "XCSHRecordDetialCell.h"
#import "XCSHRecordDetialModel.h"
#import "NumTFBZTVAlertView.h"

#define TopViewHigh 80
@interface XCSHRecordDetialController ()<QMUITextFieldDelegate,QMUITextViewDelegate>

@property(nonatomic,strong)QMUIFillButton *submitBtn;
@property(nonatomic,strong)NumTFBZTVAlertView *alertView;
@property(nonatomic,strong)NSMutableArray *sectionArray;

@property(nonatomic,strong)NSMutableArray<NSMutableDictionary *> *updateArray;
@property(nonatomic,assign)NSInteger maxNumThis;
@end
@implementation XCSHRecordDetialController
-(NSMutableArray<NSMutableDictionary *> *)updateArray{
    if (!_updateArray) {
        self.updateArray = [NSMutableArray new];
    }
    return _updateArray;
}
-(void)setUpNavigationBar{
    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.recordModel.titleName;
    [self.navBar.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    Weak_Self;
    [self.navBar.rightButton clickWithBlock:^{
        [weakSelf submit_RecordChangeData];
    }];
    [self alertMention];
}
-(void)alertMention{
    /**
     SiteState：
     1-采购接收;State=5,弹出接收详情，State=6,提示该发货已接收完成，State<5,提示该发货还未付款
     2-总部发货接收:State>2&&State<5,弹出接收详情，State<3提示未发货记录不能接收， State>=5提示该发货已接收完成
     */
    if ((self.recordModel.SiteState.integerValue == 1 && self.recordModel.State.integerValue == 5) || (self.recordModel.SiteState.integerValue == 2 && (self.recordModel.State.integerValue >2  &&   self.recordModel.State.integerValue < 5 ))) {
        self.navBar.rightButton.hidden= NO;
    }

    if (self.recordModel.SiteState.integerValue == 1) {
        if (self.recordModel.State.integerValue < 5) {
            SJYAlertShow(@"该发货尚未付款", @"确定");
        }
    }
    if (self.recordModel.SiteState.integerValue == 2) {
        if (self.recordModel.State.integerValue < 3) {
            SJYAlertShow(@"未发货,不能接收", @"确定");
        }
        if (self.recordModel.State.integerValue >= 5) {
            SJYAlertShow(@"该发货已接收完成", @"确定");
        }
    }

}
-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData_RecordDetial];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}
-(void)submit_RecordChangeData{
    if (self.updateArray.count == 0) {
        [QMUITips showWithText:@"无数据修改,无须提交" inView:self.view hideAfterDelay:1.5];
    }else{
        NSString *updateString = [self.updateArray modelToJSONString];
        
        NSDictionary *  paraDic = @{
                                    @"EmployeeID":kEmployeeID,
                                    @"SiteState":self.recordModel.SiteState,
                                    @"RealID":self.recordModel.RealID,
                                    @"updated":updateString
                                    };
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestXCSHRecordChangeWithParam:paraDic success:^(id responder) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshXCSHRecordListView" object:nil];
                [self.updateArray removeAllObjects];
//                [self.tableView.mj_header beginRefreshing];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(int status, NSString *info) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
        }];
    }
}

-(void)requestData_RecordDetial{
    [SJYRequestTool requestXCSHRecordDetialListWithRealID:self.recordModel.RealID SiteState:self.recordModel.SiteState success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
            [self.updateArray removeAllObjects];
        }
        for (NSDictionary *dic in rowsArr) {
            XCSHRecordDetialModel *model = [XCSHRecordDetialModel  modelWithDictionary:dic];
            model.changeRemark = model.Remark;
            model.changeQuantityCheck = model.QuantityCheck;
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
    XCSHRecordDetialCell *cell = [XCSHRecordDetialCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XCSHRecordDetialCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XCSHRecordDetialModel *model  = self.dataArray[indexPath.row];
    [self  click_ReceiveGoodsDetialCell:cell alertViewWithModel:model];
//    [self  clickReceiveGoodsDetialCell:cell alertViewWithModel:model];
}
#pragma mark ---------------- QMUIDialogViewController 处理
-(void)click_ReceiveGoodsDetialCell:( XCSHRecordDetialCell *)cell alertViewWithModel:(XCSHRecordDetialModel*)model{
    NSInteger maxNumThis =  model.Quantity.integerValue - model.QuantityReceive.integerValue;
    NSString *maxNum = @(maxNumThis).stringValue;
    NSString *messageStr = [NSString stringWithFormat:@"可输入值范围: 0 ~ %@",maxNum];
    if (maxNumThis == 0) {
        return;
    }
    if (self.navBar.rightButton.hidden) {
        return;
    }
    self.maxNumThis = maxNumThis;


    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = model.Name;
    dialogViewController.headerViewHeight = 40;
    dialogViewController.headerSeparatorColor = UIColorWhite;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;

    //对话框的view 即 自定义内容页
    self.alertView = [[NumTFBZTVAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W -20 *2, 180)];
    self.alertView.backgroundColor = UIColorWhite;

    self.alertView.numMentionLab.text = messageStr;
    //TextField 配置
    self.alertView.numTF.delegate = self;
    self.alertView.numTF.placeholder = @"请输入数量";
    self.alertView.numTF.text = model.changeQuantityCheck.integerValue == 0 ?@"" : model.changeQuantityCheck;
    [self.alertView.numTF addTarget:self action:@selector(alert_TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //textView 配置
    self.alertView.BZTV.delegate = self;
    self.alertView.BZTV.text = model.changeRemark;;

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

    Weak_Self;
    dialogViewController.contentView = self.alertView;

    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [self.alertView.BZTV endEditing:YES];
        //  cell 界面 数据 的调整
        if ([self.alertView.numTF.text integerValue] > maxNum.integerValue ) {
            model.changeQuantityCheck = maxNum;
            [QMUITips showInfo:@"超出范围上限" inView:self.view hideAfterDelay:1.2];
        }else if([self.alertView.numTF.text integerValue] <0){
            model.changeQuantityCheck = @"0";
            [QMUITips showInfo:@"超出范围下限" inView:self.view hideAfterDelay:1.2];
        }else{
            model.changeQuantityCheck = self.alertView.numTF.text.length==0?@"0":self.alertView.numTF.text;
        }
        model.changeRemark = self.alertView.BZTV.text;

        if (![model.changeRemark isEqualToString:model.Remark] || ![model.changeQuantityCheck isEqualToString:model.QuantityCheck]){
            [cell loadContent];
            //数据处理 添加进入数组
            //数据处理 添加进入数组
            NSMutableDictionary *currentDic= [NSMutableDictionary dictionary];
            [currentDic setValue:model.changeRemark forKey:@"Remark"];
            [currentDic setValue:model.changeQuantityCheck forKey:@"QuantityCheck"];
            [currentDic setValue:model.ModId forKey:@"ModId"];
            [currentDic setValue:model.Id forKey:@"Id"];

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", model.Id];
            NSMutableDictionary *havDic = [self.updateArray filteredArrayUsingPredicate:predicate].firstObject;
            if (havDic) {
                if (![[havDic valueForKey:@"Remark"] isEqualToString:[currentDic valueForKey:@"Remark"]] || ![[havDic valueForKey:@"QuantityCheck"] isEqualToString:[currentDic valueForKey:@"QuantityCheck"]]) {
                    [havDic setValue:model.changeRemark forKey:@"Remark"];
                    [havDic setValue:model.changeQuantityCheck forKey:@"QuantityCheck"];
                    //                    [havDic setValue:model.ModId forKey:@"ModId"];
                    //                    [havDic setValue:model.Id forKey:@"Id"];
                }
            }else{
                [self.updateArray addObject:currentDic];
            }
            NSLog(@"%@", self.updateArray);
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
    //    if([textField.text hasPrefix:@"0"] || [textField.text hasPrefix:@"00"]){
    //        textField.text = @"0";
    //    }
    //    if (textField.text.integerValue > self.maxNumThis) {
    //        textField.text = [textField.text substringToIndex:@(self.maxNumThis).stringValue.length];
    //    }
    okAction.enabled = textField.text.length || self.alertView.BZTV.text.length;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str =[textField.text stringByAppendingString:string];
    if (![NSString isAvailableStr:str WithFormat:@"^(0|[1-9][0-9]*)$"]) {
        return NO;
    }
    if ( str.integerValue > self.maxNumThis) {
        return NO;
    }
    return YES;
}

#pragma mark ---------------- 系统 UIAlertController处理
//-(void)clickReceiveGoodsDetialCell:( XCSHRecordDetialCell *)cell alertViewWithModel:(XCSHRecordDetialModel*)model{
//    NSInteger maxNumThis =  model.Quantity.integerValue - model.QuantityReceive.integerValue;
//    NSString *maxNum = @(maxNumThis).stringValue;
//    NSString *messageStr = [NSString stringWithFormat:@"本次输入值的范围在0 ~ %@ 之间",maxNum];
//    if (maxNumThis == 0) {
//        return;
//    }
//    if (self.navBar.rightButton.hidden) {
//        return;
//    }
//    self.maxNumThis = maxNumThis;
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:model.Name message:messageStr preferredStyle:UIAlertControllerStyleAlert];
//    //进度输入框
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder =@"请输入数量";
//        textField.keyboardType = UIKeyboardTypeNumberPad;
//        textField.text = model.changeQuantityCheck.integerValue == 0 ?nil : model.changeQuantityCheck;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
//
//    }];
//    //备注信息输入框
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder =@"请输入备注信息";
//        textField.text = model.changeRemark;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
//    }];
//    [alertVC.textFields[0] makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(35);
//    }];
//    [alertVC.textFields[1] makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(35);
//    }];
//    for (UITextField *textField in alertVC.textFields) {
//        textField.font= [UIFont systemFontOfSize:15];
//    }
//    //确定按钮
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//
//        //  cell 界面 数据 的调整
//        if ([alertVC.textFields[0].text integerValue] > maxNum.integerValue ) {
//            model.changeQuantityCheck = maxNum;
//            [QMUITips showInfo:@"超出范围上限" inView:self.view hideAfterDelay:1.2];
//        }else if([alertVC.textFields[0].text integerValue] < 0){
//            model.changeQuantityCheck = @"0";
//            [QMUITips showInfo:@"超出范围下限" inView:self.view hideAfterDelay:1.2];
//        }else{
//            model.changeQuantityCheck = alertVC.textFields.firstObject.text;
//        }
//        model.changeRemark = alertVC.textFields.lastObject.text;
//
//        if (![model.changeRemark isEqualToString:model.Remark] || ![model.changeQuantityCheck isEqualToString:model.QuantityCheck]){
//            [cell loadContent];
//            //数据处理 添加进入数组
//            //数据处理 添加进入数组
//            NSMutableDictionary *currentDic= [NSMutableDictionary dictionary];
//            [currentDic setValue:model.changeRemark forKey:@"Remark"];
//            [currentDic setValue:model.changeQuantityCheck forKey:@"QuantityCheck"];
//            [currentDic setValue:model.ModId forKey:@"ModId"];
//            [currentDic setValue:model.Id forKey:@"Id"];
//
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", model.Id];
//            NSMutableDictionary *havDic = [self.updateArray filteredArrayUsingPredicate:predicate].firstObject;
//            if (havDic) {
//                if (![[havDic valueForKey:@"Remark"] isEqualToString:[currentDic valueForKey:@"Remark"]] || ![[havDic valueForKey:@"QuantityCheck"] isEqualToString:[currentDic valueForKey:@"QuantityCheck"]]) {
//                    [havDic setValue:model.changeRemark forKey:@"Remark"];
//                    [havDic setValue:model.changeQuantityCheck forKey:@"QuantityCheck"];
//                }
//            }else{
//                [self.updateArray addObject:currentDic];
//            }
//            NSLog(@"%@", self.updateArray);
//            //
//            //            NSDictionary *currentDic= @{@"Id":model.Id,@"Remark": model.changeRemark,@"QuantityCheck": model.changeQuantityCheck,@"ModId":model.ModId};
//        }
//    }];
//    //取消按钮
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//    }]];
//    confirmAction.enabled = NO;
//    [alertVC addAction:confirmAction];
//    [self presentViewController:alertVC animated:YES completion:nil];
//}
//
//- (void)alertTextFieldDidChange:(NSNotification *)notification{
//    UITextField *TF = (UITextField *)notification.object;
//
//    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
//    if (alertController) {
//        UITextField *textField = alertController.textFields.firstObject;
//        UITextField *bzTF = alertController.textFields.lastObject;
//        UIAlertAction *okAction = alertController.actions.lastObject;
//
//        if (TF == textField) {
//            if([textField.text hasPrefix:@"0"] || [textField.text hasPrefix:@"0"]){
//                textField.text = @"0";
//            }
//            if (textField.text.integerValue > self.maxNumThis) {
//                textField.text = [textField.text substringToIndex:@(self.maxNumThis).stringValue.length];
//            }
//        }
//        okAction.enabled = textField.text.length || bzTF.text.length;
//    }
//}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
}



@end
