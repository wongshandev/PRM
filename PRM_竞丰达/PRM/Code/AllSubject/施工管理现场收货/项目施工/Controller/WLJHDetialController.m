//
//  WLJHDetialController.m
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "WLJHDetialController.h"
#import "WLJHDetialModel.h"
#import "WLJHDetialCell.h"
#define TopViewHigh 80
@interface WLJHDetialController ()
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UILabel *basicInfoLab;
@property(nonatomic,strong)QMUIButton *datePickerBtn;

@property(nonatomic,strong)QMUIFillButton *saveBtn;
@property(nonatomic,strong)QMUIFillButton *submitBtn;


@property(nonatomic,strong)NSMutableArray *sectionArray;
@property(nonatomic,strong)NSMutableArray<NSDictionary *> *savedArray;

@property(nonatomic,assign)NSInteger maxNumThis;
@end

@implementation WLJHDetialController
-(NSMutableArray *)savedArray{
    if (!_savedArray) {
        self.savedArray = [NSMutableArray new];
    }
    return _savedArray;
}

-(void)setUpNavigationBar{
    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;

}
-(void)buildSubviews{
    [super buildSubviews];

    [self createTopView];
    [self createSaveSubmitBtn];

}
-(void)setupTableView{
    [super setupTableView];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.height + TopViewHigh);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];


    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    self.sectionArray = [NSMutableArray new];
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  request_WLJHDetialData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)createTopView{
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kTopStatusAndNavBarHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(TopViewHigh);
    }];

    UILabel *topLab = [[UILabel alloc]init];
    topLab.font = Font_ListOtherTxt;
    topLab.textColor = Color_TEXT_HIGH;
    topLab.text = @"基础信息";
    topLab.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:topLab];

    [topLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView);
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right);
        make.height.equalTo(29);
    }];

    UILabel *sepLab = [[UILabel alloc]init];
    sepLab.backgroundColor = Color_SrprateLine;
    [self.topView addSubview:sepLab];

    [sepLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLab.mas_bottom);
        make.left.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.height.equalTo(1);
    }];

    UILabel *dateLab = [[UILabel alloc]init];
    dateLab.font = Font_ListTitle;
    dateLab.textColor = Color_TEXT_HIGH;
    dateLab.text = @"到货日期";
    dateLab.textAlignment = NSTextAlignmentLeft;

    [self.topView addSubview:dateLab];

    [dateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sepLab);
        make.left.equalTo(topLab.mas_left);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    QMUIButton *dateBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [dateBtn setTitleColor:Color_TEXT_NOMARL forState:UIControlStateDisabled];
    [dateBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
    [dateBtn setImage:SJYCommonImage(@"enterRight") forState:UIControlStateNormal];

    [dateBtn setTitle:self.wlListModel.OrderDate forState:UIControlStateNormal];
    dateBtn.spacingBetweenImageAndTitle =  10;
    dateBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    dateBtn.imagePosition =  QMUIButtonImagePositionRight;
    [self.topView addSubview:dateBtn];

    [dateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sepLab);
        make.right.equalTo(self.topView).offset(-10);
        make.left.equalTo(self.topView.mas_left);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    self.datePickerBtn = dateBtn;
    dateBtn.enabled = NO;
    Weak_Self;
    [self.datePickerBtn clickWithBlock:^{
        [BRDatePickerView showDatePickerWithTitle:@"到货日期" dateType:BRDatePickerModeYMD defaultSelValue:weakSelf.datePickerBtn.currentTitle minDate:nil maxDate:nil isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(NSString *selectValue) {
            [weakSelf.datePickerBtn setTitle:selectValue forState:UIControlStateNormal];
        }];
    }];
}

-(void)createSaveSubmitBtn{
    Weak_Self;
    QMUIFillButton *saveBt = [QMUIFillButton  buttonWithType:UIButtonTypeCustom];
    saveBt.fillColor = Color_NavigationLightBlue;
    [saveBt setTitle:@"保存" forState:UIControlStateNormal];
    [saveBt setTitleTextColor:Color_White];
    [self.navBar addSubview:saveBt];
    saveBt.hidden = YES;
    self.saveBtn = saveBt;
    [self.saveBtn clickWithBlock:^{
        [weakSelf save_WLJHData];
    }];

    QMUIFillButton *submitBt = [QMUIFillButton  buttonWithType:UIButtonTypeCustom];
    submitBt.fillColor = Color_NavigationLightBlue;
    [submitBt setTitle:@"提交" forState:UIControlStateNormal];
    [submitBt setTitleTextColor:Color_White];
    [self.navBar addSubview:submitBt];
    submitBt.hidden = YES;
    self.submitBtn = submitBt;
    [self.submitBtn clickWithBlock:^{
        [weakSelf submit_WLJHData];
    }];

    if ((self.dState.integerValue >= 7 && (self.wlListModel.State.integerValue == 3 || self.wlListModel.State.integerValue ==1 || self.wlListModel.State.integerValue == -888  ))) {
        self.saveBtn.hidden = NO;
        self.datePickerBtn.enabled = YES;
    }
    if (self.wlListModel.State.integerValue == 1) {
        self.submitBtn.hidden = NO;
    }
    CGFloat  submitWidth = self.submitBtn.hidden ? 0: SJYNUM(56);
    [self.submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.navBar.mas_right);
        make.height.equalTo(44);
        make.width.equalTo(submitWidth);
    }];
    [self.saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.submitBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(SJYNUM(56));
    }];
}
#pragma mark ======================= 数据绑定 
-(void)request_WLJHDetialData{
    [SJYRequestTool requestWLJHDetialListWithProjectBranchID:self.projectBranchID MarketOrderID:self.marketOrderID success:^(id responder) {
        NSArray *rowsArr = [responder valueForKey:@"rows"];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
            [self.sectionArray removeAllObjects];
        }

     
        NSMutableArray *cellsArr = [NSMutableArray new];
        for (NSDictionary *dic in rowsArr) {
            WLJHDetialModel *model = [ WLJHDetialModel  modelWithDictionary:dic];
            model.canChangeQuantityThis = model.QuantityThis;
            if ([[dic valueForKey:@"_parentId"]integerValue] == 0) {
                [self.sectionArray addObject:model];
            }else{
                [cellsArr addObject:model];
            }
        }
        for (NSInteger i = 0; i < self.sectionArray.count; i ++ ) {
            WLJHDetialModel *sectionModel = self.sectionArray[i];
            NSMutableArray *sectionArr = [NSMutableArray new];
            for (NSInteger j = 0; j < cellsArr.count; j++) {
                WLJHDetialModel *cellModel = cellsArr[j];
                if (sectionModel.Id.integerValue == cellModel._parentId.integerValue) {
                    [sectionArr addObject:cellModel];
                }
            }
            [self.dataArray addObject:sectionArr];
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
    [self.tableView.mj_footer endRefreshing];
    if (self.dataArray.count == 0) {
        self.tableView.customImg = !havError ? [UIImage imageNamed:@"empty"]:SJYCommonImage(@"daoda");
        self.tableView.customMsg = !havError? @"没有数据了,休息一下吧":@"网络错误,请检查网络后重试";
        self.tableView.showNoData = YES;
        self.tableView.isShowBtn =  havError;
    }
}


-(BOOL)checkCanSave{
    if (self.datePickerBtn.currentTitle.length == 0) {
        [QMUITips showWithText:@"请选择到货日期" inView:self.view hideAfterDelay:1.5];
        return NO;
    }
    if ([self.wlListModel.State  isEqualToString: @"-888"]) {
        return self.savedArray.count;
    }else{
        return (self.savedArray.count ||  ![self.datePickerBtn.currentTitle isEqualToString: self.wlListModel.OrderDate]);
    }
 }

-(void)save_WLJHData{
    if (![self checkCanSave]) {
        [QMUITips showWithText:@"无数据需要保存" inView:self.view hideAfterDelay:1.5];
        return;
    };
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ModId == %@", @"0"];
    NSArray *insertArr = [self.savedArray filteredArrayUsingPredicate:predicate];
    NSString *insertString = [insertArr modelToJSONString];

    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"ModId != %@", @"0"];
    NSArray *updateArr = [self.savedArray filteredArrayUsingPredicate:predicate1];
    NSString *updateString = [updateArr modelToJSONString];

    NSDictionary *paraDic = @{
                              @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                              @"ProjectBranchID":self.projectBranchID,
                              @"OrderDate":self.datePickerBtn.currentTitle,
                              @"MarketOrderID":self.marketOrderID,
                              @"inserted":insertString,
                              @"updated":updateString
                              };
    [SJYRequestTool requestWLJHDetialSaveWithParam:paraDic success:^(id responder) {
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshListView" object:nil];
            [self.savedArray removeAllObjects];
            [QMUITips showSucceed:@"保存成功" inView:self.view hideAfterDelay:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
        }
    } failure:^(int status, NSString *info) {
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
    }];

}
-(void)submit_WLJHData{
    NSDictionary *paraDic = @{
                              @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                              @"State":@"2",
                              @"MarketOrderID":self.marketOrderID
                              };
    [SJYRequestTool requestWLJHDetialSubmitWithParam:paraDic success:^(id responder) {
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshListView" object:nil];
            [self.savedArray removeAllObjects];
            [QMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
        }
    } failure:^(int status, NSString *info) {
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
    }];
}

#pragma mark **************************UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WLJHListModel *model =  [self.sectionArray objectAtIndex:section];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    headview.backgroundColor = UIColor.groupTableViewBackgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-10, 40)];
    label.font = Font_ListTitle;
    label.textColor = Color_TEXT_HIGH;
    label.text = model.Name;
    [headview addSubview:label];
    return headview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WLJHDetialCell *cell = [WLJHDetialCell cellWithTableView:tableView];
    cell.data = self.dataArray[indexPath.section][indexPath.row];
    cell.indexPath = indexPath;
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLJHDetialCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WLJHDetialModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (!self.datePickerBtn.enabled) {
        return;
    }
    NSInteger maxNumThis = model.Quantity.integerValue - model.QuantityPurchased.integerValue;
//    NSString *maxNum = [NSString stringWithFormat:@"%d",(model.Quantity.integerValue - model.QuantityPurchased.integerValue)];
    NSString *maxNum = @(maxNumThis).stringValue;
    NSString *messageStr = [NSString stringWithFormat:@" 本次申请的范围:0 ~ %@",maxNum];
    if (maxNumThis == 0) {
        return;
    }
    self.maxNumThis = maxNumThis;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:model.Name message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入申请数量";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font=   Font_ListTitle;
        textField.text = model.canChangeQuantityThis.integerValue == 0 ?nil : model.canChangeQuantityThis;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [alertVC.textFields[0] makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        [alertVC.textFields[0] endEditing:YES];
        if ([alertVC.textFields[0].text integerValue] > maxNum.integerValue ) {
            model.canChangeQuantityThis = maxNum;
            [QMUITips showInfo:@"超出范围上限" inView:self.view hideAfterDelay:1.2];
        }else if([alertVC.textFields[0].text integerValue] < 0){
            model.canChangeQuantityThis = maxNum;
            [QMUITips showInfo:@"超出范围下限" inView:self.view hideAfterDelay:1.2];
        }else{
            model.canChangeQuantityThis = alertVC.textFields.firstObject.text;
        }
        if (![model.canChangeQuantityThis isEqualToString:model.QuantityThis]){
            [cell loadContent];
            //数据处理 添加进入数组
            NSDictionary *currentDic= @{@"QuantityThis":model.canChangeQuantityThis,@"BOMID":model.BOMID,@"ModId":model.ModId,@"Id":model.Id};
            if (self.savedArray.count== 0) {
                [self.savedArray addObject:currentDic];
            }else{
                NSLog(@"%@", self.savedArray);
                for (int i = 0;  i < self.savedArray.count; i++) {
                    NSDictionary *dic = self.savedArray[i];
                    if ([[dic valueForKey:@"Id"] isEqualToString:[currentDic valueForKey:@"Id"]]) {
                        [self.savedArray removeObject:dic];
                        if (![[dic valueForKey:@"QuantityThis"] isEqualToString:[currentDic valueForKey:@"QuantityThis"]]) {
                            [self.savedArray addObject:currentDic];
                        }
                    }else{
                        [self.savedArray addObject:currentDic];
                    }
                }
            }
        }
    }];
    confirmAction.enabled = NO;

    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }]];
    [alertVC addAction: confirmAction];

    [self presentViewController:alertVC animated:YES completion:nil];

}

- (void)alertTextFieldDidChange:(NSNotification *)notification{ 
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *textField = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        if([textField.text hasPrefix:@"0"]){
            textField.text = @"";
        }
        okAction.enabled = textField.text.length;

        if (textField.text.integerValue > self.maxNumThis) {
            textField.text = [textField.text substringToIndex:@(self.maxNumThis).stringValue.length];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
}

@end
