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
@property(nonatomic,strong)NSMutableDictionary <NSString *, NSMutableDictionary *>*insertDic;

@end
@implementation XCSHRecordDetialController
-(NSMutableDictionary<NSString *,NSMutableDictionary *> *)insertDic{
    if (!_insertDic) {
        _insertDic = [NSMutableDictionary new];
    }
    return _insertDic;
}

-(NSMutableArray<NSMutableDictionary *> *)updateArray{
    if (!_updateArray) {
        self.updateArray = [NSMutableArray new];
    }
    return _updateArray;
}
-(void)setUpNavigationBar{
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.recordModel.titleName;
    [self.navBar.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    Weak_Self;
    [self.navBar.rightButton clickWithBlock:^{
        [weakSelf submit_RecordChangeData];
    }];
    //    [self alertMention];
    [self alertMention_JFD];
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

-(void)alertMention_JFD{
    
    /**
     SiteState：
     1-采购接收;State=7,弹出接收详情，State=8,提示该发货已接收完成，State<7,提示该发货还未付款
     2-总部发货接收:State>2&&State<5,弹出接收详情，State<3提示未发货记录不能接收， State>=5提示该发货已接收完成
     
     SiteState=1
     采购接收;State=7,弹出接收详情，State=8,提示该发货已接收完成，State<7,提示该发货还未付款
     SiteState=2
     总部发货接收:State>2&&State<5,弹出接收详情，State<3提示未发货记录不能接收， State>=5提示该发货已接收完成
     */
    if ((self.recordModel.SiteState.integerValue == 1 && self.recordModel.State.integerValue == 7) || (self.recordModel.SiteState.integerValue == 2 && (self.recordModel.State.integerValue >2  &&   self.recordModel.State.integerValue < 5 ))) {
        self.navBar.rightButton.hidden= NO;
    }
    
    if (self.recordModel.SiteState.integerValue == 1) {
        if (self.recordModel.State.integerValue < 7) {
            SJYAlertShow(@"该发货尚未付款", @"确定");
        }
        if (self.recordModel.State.integerValue== 8) {
            SJYAlertShow(@"该发货已接收完成", @"确定");
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
    //    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"ModId != %@", @"0"];
    //    NSArray *updateArr = [self.updateArray filteredArrayUsingPredicate:predicate1];
    //    NSString *updateString = [updateArr modelToJSONString];
    
    if (self.updateArray.count == 0) {
        [QMUITips showWithText:@"无数据修改,无须提交" inView:self.view hideAfterDelay:1.5];
    }else{
        NSString *updateString = [self.updateArray modelToJSONString];
        NSDictionary *  paraDic = @{
            @"EmployeeID":KEmployID,
            @"Version":self.recordModel.Version,
            @"SiteState":self.recordModel.SiteState,
            @"RealID":self.recordModel.RealID,
            @"updated":updateString
        };
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestXCSHRecordChangeWithParam:paraDic success:^(id responder) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
            });
        } failure:^(int status, NSString *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips hideAllTips];
                [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
            });
        }];
    }
}

-(void)requestData_RecordDetial{
    [SJYRequestTool requestXCSHRecordDetialListWithRealID:self.recordModel.RealID SiteState:self.recordModel.SiteState success:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *rowsArr = [responder objectForKey:@"rows"];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.dataArray removeAllObjects];
                [self.insertDic removeAllObjects];
                [self.updateArray removeAllObjects];
            }
            for (NSDictionary *dic in rowsArr) {
                XCSHRecordDetialModel *model = [XCSHRecordDetialModel  modelWithDictionary:dic];
                NSString *titStr = model.Model.length!=0?[model.Name stringByAppendingFormat:@"(%@)",model.Model]:model.Name;
                model.titleStr =  model.Unit.length!=0?[titStr stringByAppendingFormat:@"(%@)",model.Unit]:titStr;
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
    XCSHRecordDetialCell *cell = [XCSHRecordDetialCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    XCSHRecordDetialModel *model  = self.dataArray[indexPath.row];
    Weak_Self;
    kWeakSelf(cell);
    cell.savDataBlock = ^(NSMutableDictionary * cellDic) {
        if (
            //![cellDic[@"QuantityReceive"]  isEqualToString:model.QuantityReceive]
            ![cellDic[@"QuantityCheck"] isEqualToString:model.QuantityCheck]
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
    XCSHRecordDetialCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XCSHRecordDetialModel *model  = self.dataArray[indexPath.row];
    [self  click_ReceiveGoodsDetialCell:cell alertViewWithModel:model];
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
    self.alertView.numTF.text = [cell.cellDic[@"QuantityCheck"] integerValue] == 0 ?@"" :cell.cellDic[@"QuantityCheck"];
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
    dialogViewController.contentView = self.alertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [self.alertView.BZTV endEditing:YES];
        //FIXME:  cell  界面 数据cellDic 的调整
        if ([self.alertView.numTF.text integerValue] > maxNum.integerValue ) {
            cell.cellDic[@"QuantityCheck"] = @(maxNumThis).stringValue;
            [QMUITips showInfo:@"超出范围上限" inView:self.view hideAfterDelay:1.2];
        }else if([self.alertView.numTF.text integerValue] <0){
            cell.cellDic[@"QuantityCheck"] = @"0";
            [QMUITips showInfo:@"超出范围下限" inView:self.view hideAfterDelay:1.2];
        }else{
            cell.cellDic[@"QuantityCheck"] = self.alertView.numTF.text.length==0?@"0":self.alertView.numTF.text;
        }
        cell.cellDic[@"Remark"] = self.alertView.BZTV.text;
        cell.cellDic = cell.cellDic;
        //FIXME: 新建并存储 修改后的内容到更新数组
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", model.Id];
        NSMutableDictionary *havDic = [self.updateArray filteredArrayUsingPredicate:predicate].firstObject;
        if (![cell.cellDic[@"Remark"] isEqualToString:model.Remark] || ![cell.cellDic[@"QuantityCheck"] isEqualToString:model.QuantityCheck]){
            //数据处理 添加进入数组
            NSMutableDictionary *currentDic= [NSMutableDictionary dictionary];
            [currentDic setValue:cell.cellDic[@"Remark"] forKey:@"Remark"];
            [currentDic setValue:cell.cellDic[@"QuantityCheck"] forKey:@"QuantityCheck"];
            [currentDic setValue:cell.cellDic[@"ModId"] forKey:@"ModId"];
            [currentDic setValue:cell.cellDic[@"Id"] forKey:@"Id"];
            
            if (havDic) {
                if (![[havDic valueForKey:@"Remark"] isEqualToString:[currentDic valueForKey:@"Remark"]] || ![[havDic valueForKey:@"QuantityCheck"] isEqualToString:[currentDic valueForKey:@"QuantityCheck"]]) {
                    [havDic setValue:[havDic valueForKey:@"Remark"] forKey:@"Remark"];
                    [havDic setValue:[havDic valueForKey:@"QuantityCheck"] forKey:@"QuantityCheck"];
                    // [havDic setValue:model.ModId forKey:@"ModId"];
                    // [havDic setValue:model.Id forKey:@"Id"];
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
    if ( str.integerValue > self.maxNumThis) {
        return NO;
    }
    return YES;
}

#pragma mark ---------------- 系统 UIAlertController处理



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
