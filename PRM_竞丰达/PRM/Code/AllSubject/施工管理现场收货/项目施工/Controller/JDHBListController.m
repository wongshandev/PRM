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

@interface JDHBListController()
@property(nonatomic,strong)NSMutableArray *updateArray;
@property(nonatomic,strong)QMUIFillButton *updateBtn;
@end


@implementation JDHBListController

-(void)setUpNavigationBar{
    self.navBar.hidden = YES;
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
        }
        
        
        for (NSDictionary *dic in rowsArr) {
            JDHBListModel *model = [JDHBListModel  modelWithDictionary:dic];
            model.canChangeRate = model.CompletionRate;
            model.canChangeRemark = model.Remark;
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
    //    NSString *jsonStr = [self.updateArray modelToJSONString];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.updateArray options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *jsonStr = [[[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    [SJYRequestTool requestJDHBUpdateWithEmployeeID:[SJYUserManager sharedInstance].sjyloginData.Id updated:jsonStr success:^(id responder) {
        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [self.updateArray removeAllObjects];
            [self.tableView.mj_header beginRefreshing];
        }
    } failure:^(int status, NSString *info) {
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
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
#pragma mark -----------------------------tableView delegate / dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDHBListCell *cell = [JDHBListCell cellWithTableView:tableView];
    cell .indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDHBListModel *model = self.dataArray[indexPath.row];
    JDHBListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self clickProgressReportCell:cell alertViewWithModel:model];
}
-(void)clickProgressReportCell:(JDHBListCell *)cell alertViewWithModel:(JDHBListModel *)model{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:model.Name message:[NSString stringWithFormat:@"进度及备注信息设置, 输入的进度范围在%@ ~ 100 之间",model.CompletionRate] preferredStyle:UIAlertControllerStyleAlert];
    //进度输入框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"请输入进度";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = model.canChangeRate;
    }];
    //备注信息输入框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"请输入备注信息";
        textField.text = model.Remark;
    }];
    [alertVC.textFields[0] makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    [alertVC.textFields[1] makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    for (UITextField *textField in alertVC.textFields) {
        textField.font= Font_ListTitle;
    }
    //确定按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //  cell 界面 数据 的调整
            if ([alertVC.textFields[0].text integerValue] > 100 ) {
                model.canChangeRate = @"100";
                [QMUITips showInfo:@"超出默认范围上限" inView:self.view hideAfterDelay:1.2];
            }else if([alertVC.textFields[0].text integerValue] < model.CompletionRate.integerValue){
                model.canChangeRate = model.CompletionRate;
                [QMUITips showInfo:@"超出默认范围下限" inView:self.view hideAfterDelay:1.2];
            }else{
                model.canChangeRate = alertVC.textFields[0].text;
            }
            
            if (![model.canChangeRate isEqualToString:model.CompletionRate] || ![model.Remark isEqualToString:model.canChangeRemark]) {
                [cell loadContent];
                //数据处理 添加进入数组
                NSDictionary *currentDic= @{@"Id":model.Id,@"Remark":model.canChangeRemark,@"CompletionRate":model.canChangeRate};
                if (self.updateArray.count== 0) {
                    [self.updateArray addObject:currentDic];
                }else{
                    NSLog(@"%@", self.updateArray);
                    for (int i = 0;  i < self.updateArray.count; i++) {
                        NSDictionary *dic = self.updateArray[i];
                        if ([[dic valueForKey:@"Id"] isEqualToString:[currentDic valueForKey:@"Id"]]) {
                            [self.updateArray removeObject:dic];
                            if (![[dic valueForKey:@"Remark"] isEqualToString:[currentDic valueForKey:@"Remark"]] || ![[dic valueForKey:@"CompletionRate"] isEqualToString:[currentDic valueForKey:@"CompletionRate"]]) {
                                [self.updateArray addObject:currentDic];
                            }
                        }else{
                            [self.updateArray addObject:currentDic];
                        }
                    }
                }
            }
        });
    }]];
    //取消按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
}

-(NSMutableArray *)updateArray{
    if (!_updateArray) {
        _updateArray= [NSMutableArray new];
    }
    return _updateArray;
}
@end
