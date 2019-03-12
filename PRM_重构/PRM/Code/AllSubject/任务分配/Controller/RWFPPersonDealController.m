//
//  RWFPPersonDealController.m
//  PRM
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RWFPPersonDealController.h"
#import "RWFPPersonDealCell.h"
#import "DistributionPerson.h"


#define TypeArray @[@"负责人",@"工程经理",@"主设计人",@"辅助设计"]

@interface RWFPPersonDealController ()
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *mainLeaderArray;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *PMArray;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *designerArray;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *assistArray;

@property(nonatomic,strong)NSMutableDictionary *submitDic;
@property(nonatomic,strong)NSMutableDictionary *stasticDic;


@end

@implementation RWFPPersonDealController

-(void)setUpNavigationBar{
    Weak_Self;
    self.navBar.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    
    [self.navBar.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.navBar.rightButton.hidden = NO;
    [self.navBar.rightButton clickWithBlock:^{
        // 提交处理
        [weakSelf requestRWFP_submit];
    }];

}

-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}

/**
 if ([[LeaderParaDic objectForKey:@"DtType"]integerValue]  ==1) { //市场
 }

 if ([[paraDic objectForKey:@"DtType"]integerValue]  ==2) { //设计 /技术
 }
 if ([[paraDic objectForKey:@"DtType"]integerValue]  ==3) { //工程 管理
 }
 */
-(void)bindViewModel{

  self.stasticDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"FZR":@"",//(市场负责人Id)
                                                                      @"ZSJR":@"",//(主设计师Id)
                                                                      @"GCJL":@"",//(项目经理Id)
                                                                      @"FZSJ":[NSMutableArray new] //(辅助设计师Id集合，以’,’分开)
                                                                      }];


    self.submitDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                     @"ProjectBranchID":@"",
                                                                     @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id,
                                                                     @"InquiryID":@"",//(市场负责人Id)
                                                                     @"DesignID":@"",//(主设计师Id)
                                                                     @"EngineeringID":@"",//(项目经理Id)
                                                                     @"AidIds":@"" //(辅助设计师Id集合，以’,’分开)
                                                                     }];
    self.mainLeaderArray = [NSMutableArray new]; //市场
    self.designerArray = [NSMutableArray new];   //设计
    self.PMArray = [NSMutableArray new];     // 工程
    self.assistArray = [NSMutableArray new];  // 辅助设计
    [self requestPerson_SCB0];
}
//市场
-(void)requestPerson_SCB0{
    [QMUITips showLoading:@"" inView:self.view];
    NSDictionary *LeaderParaDic = @{@"DtType":@"1"};
    [SJYRequestTool requestRWFPPersonData:LeaderParaDic success:^(id responder) {
        for (NSDictionary *dic in responder) {
            DistributionPerson *person = [DistributionPerson modelWithDictionary:dic];
            [self.mainLeaderArray addObject:person];
        }
         [self requestPerson_SJB1];
    } failure:^(int status, NSString *info) {
        [QMUITips hideAllTips];
        [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
    }];
}
//设计
-(void)requestPerson_SJB1{
     NSDictionary *desiginParaDic = @{@"DtType":@"2"};
    [SJYRequestTool requestRWFPPersonData:desiginParaDic success:^(id responder) {
        for (NSDictionary *dic in responder) {
            DistributionPerson *person = [DistributionPerson modelWithDictionary:dic];
            [self.designerArray addObject:person];
        }
         [self requestPerson_GCB2];
    } failure:^(int status, NSString *info) {
        [QMUITips hideAllTips];
        [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
    }];
}
// 工程
-(void)requestPerson_GCB2{
     NSDictionary *PMParaDic = @{@"DtType":@"3",@"Dt":@"1"};
    [SJYRequestTool requestRWFPPersonData:PMParaDic success:^(id responder) {
        for (NSDictionary *dic in responder) {
            DistributionPerson *person = [DistributionPerson modelWithDictionary:dic];
            [self.PMArray addObject:person];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self  setTableViewStaticData];
            [QMUITips hideAllTips];
        });
    } failure:^(int status, NSString *info) {
        [QMUITips hideAllTips];
        [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
    }];
}
//静态列表
-(void)setTableViewStaticData{
    NSMutableArray *modelArray = [NSMutableArray new];
    NSMutableArray *dataArr = [@[
                               @{
                                 @"titleStr":@"负责人",
                                 @"subtitleStr":self.stasticDic[@"FZR"],
                                 @"IdString":@"",
                                 @"isMust":@""
                                 },
                               @{
                                 @"titleStr":@"工程经理",
                                 @"subtitleStr":self.stasticDic[@"GCJL"],
                                 @"IdString":@"",
                                 @"isMust":@""
                                 },
                               @{
                                 @"titleStr":@"主设计人",
                                 @"subtitleStr":self.stasticDic[@"ZSJR"],
                                 @"IdString":@"",
                                 @"isMust":@""
                                 },
                               @{
                                 @"titleStr":@"辅助设计",
                                 @"subtitleStr":[self.stasticDic[@"FZSJ"] componentsJoinedByString:@","],
                                 @"IdString":@"",
                                 @"isMust":@""
                                 }] mutableCopy];

    for (NSInteger i = 0; i < dataArr.count; i++) {
        RWFPDealListModel *model  = [RWFPDealListModel  modelWithDictionary:dataArr[i]];
        [modelArray addObject:model];
    }
    switch (self.listModel.ProjectTypeID.integerValue) {
        case 2:  //2：销售项目禁用工程下拉框
        {
            [modelArray removeObjectAtIndex:1];
        }
            break;
        case 3:  //3：维保项目禁用设计下拉框
        {
            if (modelArray.count>=2) {
                [modelArray removeObjectsInRange:NSMakeRange(modelArray.count - 2, 2)];
            }
        }
            break;
        default:
            break;
    }
    self.dataArray = modelArray;
    [self.tableView reloadData];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count?1:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QMUILabel *label = [[QMUILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
    label.font = Font_ListOtherTxt;
    label.textColor = Color_TEXT_NOMARL;
    label.backgroundColor = Color_White;
    label.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    label.text = @"分配详情";
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RWFPPersonDealCell  *cell = [RWFPPersonDealCell cellWithTableView:tableView];
    cell.data= self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RWFPPersonDealCell  *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    RWFPDealListModel *model = self.dataArray[indexPath.row];
    [self alertPersonSelectVCWith:model WithCell:cell];

}

-(void)alertPersonSelectVCWith:(RWFPDealListModel *)model WithCell:(RWFPPersonDealCell  *)cell{
    [self showMultipleSelectionDialogViewControllerWith:model WithCell:cell];
}

- (void)showMultipleSelectionDialogViewControllerWith:(RWFPDealListModel *)model WithCell:(RWFPPersonDealCell  *)cell {

    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    dialogViewController.tableView.separatorInset  = UIEdgeInsetsZero;
    dialogViewController.title = model.titleStr;
    dialogViewController.titleView.subtitle = [model.titleStr isEqualToString:@"辅助设计"]?@"多选":@"单选";
    dialogViewController.allowsMultipleSelection = [model.titleStr isEqualToString:@"辅助设计"]? YES:NO;// 打开多选
    //@[@"负责人",@"工程经理",@"主设计人",@"辅助设计"]
    //负责人
    NSMutableArray *fuzeRen =  [NSMutableArray new];
    [self.mainLeaderArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fuzeRen addObject:obj.Name];
    }];
    if ([model.titleStr isEqualToString: TypeArray[0]] ) {
        dialogViewController.items = fuzeRen;
        dialogViewController.selectedItemIndex = [fuzeRen indexOfObject:model.subtitleStr];
    }
    //工程经理
    NSMutableArray *gcjlRen =  [NSMutableArray new];
    [self.PMArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gcjlRen addObject:obj.Name];
    }];
    if ([model.titleStr isEqualToString: TypeArray[1]] ) {
        dialogViewController.items = gcjlRen;
        dialogViewController.selectedItemIndex = [gcjlRen indexOfObject:model.subtitleStr];
    }

    //主设计人
    NSMutableArray *zhushejiRen =  [NSMutableArray new];
    [self.designerArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [zhushejiRen addObject:obj.Name];
    }];
    if ([model.titleStr isEqualToString: TypeArray[2]]) {
        dialogViewController.items =  zhushejiRen;
        dialogViewController.selectedItemIndex = [zhushejiRen indexOfObject:model.subtitleStr];
    }

    //辅助设计
    NSMutableArray *fuzhuShejiRen = [NSMutableArray new];
    [zhushejiRen removeObject:self.stasticDic[@"ZSJR"]];
    [fuzhuShejiRen addObjectsFromArray:zhushejiRen];
    if ([model.titleStr isEqualToString:TypeArray[3]]) {
        if ([self.stasticDic[@"ZSJR"] length] == 0 ) {
            [QMUITips showWithText:@"请优先选择主设计人" inView:self.view hideAfterDelay:1.2];
            return;
        }


        dialogViewController.items = fuzhuShejiRen;
        NSMutableArray *nameArray = [[model.subtitleStr componentsSeparatedByString:@","] mutableCopy];
        [fuzhuShejiRen enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stopin) {
            if ([nameArray containsObject:obj]) {
                [dialogViewController.selectedItemIndexes addObject:@(idx)];
            }
        }];
    }
    dialogViewController.cellForItemBlock = ^(__kindof QMUIDialogSelectionViewController *aDialogViewController, __kindof QMUITableViewCell *cell, NSUInteger itemIndex) {
        if (itemIndex  == aDialogViewController.selectedItemIndex && ![model.titleStr isEqualToString:@"辅助设计"]) {
            cell.selected = YES;
        }

        if ([model.titleStr isEqualToString:@"辅助设计"]) {
            [aDialogViewController.selectedItemIndexes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
                if (obj.integerValue  == itemIndex) {
                    cell.selected =YES;
                }
            }];
        }
    };

    dialogViewController.didSelectItemBlock = ^(__kindof QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        if ([model.titleStr isEqualToString:TypeArray[0]]) { //fuzeren
            aDialogViewController.selectedItemIndex = itemIndex;
        }
        if ([model.titleStr isEqualToString:TypeArray[1]]) { //fuzeren
            aDialogViewController.selectedItemIndex = itemIndex;

        }
        if ([model.titleStr isEqualToString:TypeArray[2]]) { //fuzeren
            aDialogViewController.selectedItemIndex = itemIndex;
        }
        if ([model.titleStr isEqualToString:TypeArray[3]]) { //fuzeren
            if (![aDialogViewController.selectedItemIndexes containsObject:@(itemIndex)]) {
                [aDialogViewController.selectedItemIndexes addObject:@(itemIndex)];
            }
        }
    };
    dialogViewController.didDeselectItemBlock = ^(__kindof QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        if ([model.titleStr isEqualToString:TypeArray[3]]) { //fuzeren
            [aDialogViewController.selectedItemIndexes removeObject:@(itemIndex)];
        }
    };


    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    Weak_Self;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *dialogVC = (QMUIDialogSelectionViewController *)aDialogViewController;
        [dialogVC hide];
        //负责人
        if ([model.titleStr isEqualToString:TypeArray[0]]) {
            if (dialogVC.selectedItemIndex <= dialogVC.items.count -1 && dialogVC.selectedItemIndex>=0) {
                model.subtitleStr = dialogVC.items[dialogVC.selectedItemIndex];
            }
            [self.stasticDic setValue:model.subtitleStr forKey:@"FZR"];
        }
        //工程经理
        if ([model.titleStr isEqualToString:TypeArray[1]]) {
            if (dialogVC.selectedItemIndex <= dialogVC.items.count -1 && dialogVC.selectedItemIndex>=0) {
                model.subtitleStr = dialogVC.items[dialogVC.selectedItemIndex];
            }
            [self.stasticDic setValue:model.subtitleStr forKey:@"GCJL"];
        }
        //主设计人
        if ([model.titleStr isEqualToString:TypeArray[2]]) {
            if (dialogVC.selectedItemIndex <= dialogVC.items.count -1 && dialogVC.selectedItemIndex>=0) {
                model.subtitleStr = dialogVC.items[dialogVC.selectedItemIndex];
            }
            [self.stasticDic setValue:model.subtitleStr forKey:@"ZSJR"];
            if ([self.stasticDic[@"FZSJ"] containsObject:model.subtitleStr]) {
                [self.stasticDic[@"FZSJ"] removeObject:model.subtitleStr];
            }
        }
        //辅助设计人
        if ([model.titleStr isEqualToString:TypeArray[3]]) {
            NSMutableArray *newArr = [NSMutableArray new];
            [dialogVC.selectedItemIndexes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
                [newArr addObject:dialogVC.items[obj.intValue]];
            }];
            [self.stasticDic setValue:newArr forKey:@"FZSJ"];
            model.subtitleStr = [newArr componentsJoinedByString:@","];
        }
        [self setTableViewStaticData];
    }];
    [dialogViewController show];
}



-(void)requestRWFP_submit{
    /**
     int InquiryID(市场负责人Id)
     int DesignID(主设计师Id)
     string: AidIds(辅助设计师Id集合，以’,’分开)
     int EngineeringID(项目经理Id)
     */

    __block NSString *_InquiryID = @"";
    __block NSString *_DesignID= @"";
    __block NSString *_EngineeringID= @"";
    __block NSString *_AidIds= @"";

    [self.mainLeaderArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.Name isEqualToString:self.stasticDic[@"FZR"]]) {
            _InquiryID = obj.Id;
        }
    }];
    [self.designerArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.Name isEqualToString:self.stasticDic[@"ZSJR"]]) {
            _DesignID = obj.Id;
        }
    }];
    [self.PMArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.Name isEqualToString:self.stasticDic[@"GCJL"]]) {
            _EngineeringID = obj.Id;
        }
    }];

    NSMutableArray *assidArr = [NSMutableArray new];
    [self.stasticDic[@"FZSJ"] enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idxout, BOOL * _Nonnull stopout) {
        [self.designerArray enumerateObjectsUsingBlock:^(DistributionPerson * _Nonnull obj, NSUInteger idxin, BOOL * _Nonnull stop) {
            if ([obj.Name isEqualToString:name]) {
                [assidArr addObject:obj.Id];
            }
        }];
    }];
    _AidIds = [assidArr componentsJoinedByString:@","];


    if (_InquiryID.length == 0) {
        [QMUITips showWithText:@"数据不全无法保存" inView:self.view hideAfterDelay:1.2];
        return;
    }

    if (self.listModel.ProjectTypeID.integerValue == 1) { // 工程
        if (!_DesignID.length || !_EngineeringID.length) {
            [QMUITips showWithText:@"数据不全无法保存" inView:self.view hideAfterDelay:1.2];
            return;
        }
     }

    if (self.listModel.ProjectTypeID.integerValue == 2) { // 销售
        if (!_DesignID.length) {
            [QMUITips showWithText:@"数据不全无法保存" inView:self.view hideAfterDelay:1.2];
            return;
        }
    }
    if (self.listModel.ProjectTypeID.integerValue == 3) { //维保
        if ( !_EngineeringID.length) {
            [QMUITips showWithText:@"数据不全无法保存" inView:self.view hideAfterDelay:1.2];
            return;
        }
    }

    NSDictionary *paraDic = @{
                              @"InquiryID":_InquiryID,
                              @"DesignID":_DesignID,
                              @"AidIds":_AidIds,
                              @"EngineeringID":_EngineeringID,
                              @"ProjectBranchID":self.listModel.Id,
                              @"EmployeeID":[SJYUserManager sharedInstance].sjyloginData.Id
                              };

    [SJYRequestTool requestRWFPSubmit:paraDic success:^(id responder) {
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [QMUITips showError:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshRWFPListView" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } 
    } failure:^(int status, NSString *info) {
        [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
    }];
}

















-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshXMQKListView" object:nil];
} 
@end

