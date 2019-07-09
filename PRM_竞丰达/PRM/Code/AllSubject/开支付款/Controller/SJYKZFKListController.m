//
//  SJYKZFKListController.m
//  PRM
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYKZFKListController.h"
#import "SJYKZSHSearchAlertView.h"
#import "XMKZDetialListCell.h"
#import "XMKZDetialController.h"

#define  STATEArray  @[@"全部",@"未审核",@"已审核"]
#define  ListKZFKStateArray  @[@"",@"计划",@"已提交",@"已驳回",@"主管已审",@"财务已审",@"总经理已审",@"待付款",@"已完成"]

@interface SJYKZFKListController ()
@property (nonatomic, strong) SJYKZSHSearchAlertView * searchAlertView;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;
@property(nonatomic,assign)NSInteger eld;
@property(nonatomic,assign)NSInteger shStateType;
@property(nonatomic,copy)NSString * spendTypeID;
@property(nonatomic,strong)NSMutableArray *spendTypeArray;

@end

@implementation SJYKZFKListController
-(NSMutableArray *)spendTypeArray{
    if (!_spendTypeArray) {
        _spendTypeArray = [NSMutableArray arrayWithArray:[SJYDefaultManager shareManager].getXMKZSpendTypeArray];
        NSString *idstring = [NSString stringWithFormat:@"0"];
        NSString *nameString = [NSString stringWithFormat:@"全部"];
        NSDictionary *nsdic = @{@"Id":idstring,@"Name":nameString};
        XMKZSpendTypeModel *modelAll  = [XMKZSpendTypeModel modelWithDictionary:nsdic];
        [_spendTypeArray addObject:modelAll];
        [_spendTypeArray sortUsingComparator:^NSComparisonResult(XMKZSpendTypeModel *  _Nonnull obj1, XMKZSpendTypeModel *  _Nonnull obj2) {
            return  [obj1.Id compare: obj2.Id] == NSOrderedDescending;
        }];
    }
    return _spendTypeArray;
}



-(void)setUpNavigationBar{
    Weak_Self;
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    self.shStateType = 0;
    
    XMKZSpendTypeModel *modelAll = self.spendTypeArray.firstObject;
    self.spendTypeID = modelAll.Id;
    
    [self.navBar.rightButton setTitle:@"查询" forState:UIControlStateNormal];
    self.navBar.rightButton.hidden = NO;
    [self.navBar.rightButton clickWithBlock:^{
        [weakSelf alertSearchView];
    }];
}

-(void)alertSearchView{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"查询";
    
    self.searchAlertView = [[SJYKZSHSearchAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.searchAlertView.backgroundColor = UIColorWhite;
    [self.searchAlertView.stateBtn  setTitle:[STATEArray objectAtIndex:self.shStateType + 1] forState:UIControlStateNormal];
    XMKZSpendTypeModel *modelAll = self.spendTypeArray.firstObject;
    [self.searchAlertView.typeBtn  setTitle:modelAll.name forState:UIControlStateNormal];
    
    self.searchAlertView.rightStateImgView.image = SJYCommonImage(@"downBlack");
    self.searchAlertView.rightTypeImgView.image = SJYCommonImage(@"downBlack");
    [self.searchAlertView.stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchAlertView.mas_top).offset(10);
        make.left.mas_equalTo(self.searchAlertView.mas_left).offset(10);
        make.width.mas_equalTo(70);
    }];
    [self.searchAlertView.typeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchAlertView.stateLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.searchAlertView.stateLab.mas_left);
        make.width.mas_equalTo(self.searchAlertView.stateLab.mas_width);
        make.bottom.mas_equalTo(self.searchAlertView.mas_bottom).offset(-10);
        make.height.mas_equalTo(self.searchAlertView.stateLab.mas_height);
    }];
    
    [self.searchAlertView.stateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.stateLab.mas_centerY);
        make.left.mas_equalTo(self.searchAlertView.stateLab.mas_right).offset(5);
        make.right.mas_equalTo( self.searchAlertView.mas_right).offset(-10);
        make.height.mas_equalTo(self.searchAlertView.stateLab.mas_height);
    }];
    
    [self.searchAlertView.rightStateImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.stateLab.mas_centerY);
        make.right.mas_equalTo( self.searchAlertView.stateBtn.mas_right);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(20);
    }];
    
    [self.searchAlertView.typeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.typeLab.mas_centerY);
        make.left.mas_equalTo(self.searchAlertView.typeLab.mas_right).offset(5);
        make.right.mas_equalTo( self.searchAlertView.mas_right).offset(-10);
        make.height.mas_equalTo(self.searchAlertView.typeLab.mas_height);
    }];
    
    [self.searchAlertView.rightTypeImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.typeLab.mas_centerY);
        make.right.mas_equalTo( self.searchAlertView.typeBtn.mas_right);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(20);
    }];
    
    __block NSInteger shStateType = self.shStateType;
    __block NSString * spendTypeID = self.spendTypeID;
    Weak_Self;
    [self.searchAlertView.stateBtn clickWithBlock:^{
        [weakSelf.searchAlertView endEditing:YES];
        [BRStringPickerView showStringPickerWithTitle:@"状态" dataSource:STATEArray defaultSelValue:weakSelf.searchAlertView.stateBtn.currentTitle isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
            [weakSelf.searchAlertView.stateBtn setTitle:selectValue forState:UIControlStateNormal];
            NSInteger index = [STATEArray indexOfObject:selectValue] -1;
            shStateType = index;
        }];
    }];
    
    [self.searchAlertView.typeBtn clickWithBlock:^{
        NSMutableArray *spendingIdArray = [NSMutableArray new];
        NSMutableArray *spendingNameArray = [NSMutableArray new];
        [weakSelf.spendTypeArray enumerateObjectsUsingBlock:^(XMKZSpendTypeModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [spendingIdArray addObject:obj.Id];
            [spendingNameArray addObject:obj.name];
        }];
        [BRStringPickerView showStringPickerWithTitle:@"类型" dataSource:spendingNameArray defaultSelValue:weakSelf.searchAlertView.typeBtn.currentTitle isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",selectValue];
            XMKZSpendTypeModel *model = [weakSelf.spendTypeArray filteredArrayUsingPredicate:predicate].firstObject;
            spendTypeID = model.Id;
            [weakSelf.searchAlertView.typeBtn setTitle:selectValue forState:UIControlStateNormal];
        }];
    }];
    
    dialogViewController.contentView = self.searchAlertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:weakSelf.view animated:YES completion:nil];
    }];
    
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        weakSelf.spendTypeID = spendTypeID;
        weakSelf.shStateType = shStateType;
        [modalViewController hideInView:weakSelf.view animated:YES completion:^(BOOL finished) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }];
    modalViewController.contentViewController = dialogViewController;
    [modalViewController showInView:self.view animated:YES completion:nil];
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
        weakSelf.page = 1;
        [weakSelf  requestData_KZFK];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf  requestData_KZFK];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshListView) name:@"refreshSJYKZFKListView" object:nil];
}
-(void)requestData_KZFK{
    [SJYRequestTool requestKZFKListWithSearchStateID:self.shStateType SearchSpendTypeID:self.spendTypeID Page:self.page success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        self.eld = [[responder objectForKey:@"eId"] integerValue];
        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        NSArray *spendingTypeArray = [SJYDefaultManager shareManager].getXMKZSpendTypeArray;
        for (NSDictionary *dic in rowsArr) {
            XMKZDetialListModel  *model = [XMKZDetialListModel  modelWithDictionary:dic];
            model.modelType = ModelType_KZFK;
            model.SpendingTypeIDChange = model.SpendingTypeID;
            model.OccurDateChange = model.OccurDate;
            model.RemarkChange = model.Remark;
            model.AmountChange = model.Amount;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", model.SpendingTypeID];
            XMKZSpendTypeModel *typeModel =  [spendingTypeArray filteredArrayUsingPredicate:predicate].firstObject;
            model.SpndingTypeName = typeModel.name;
            model.SpndingTypeNameChange = model.SpndingTypeName;
            
            model.titleStr = [model.ApplyName stringByAppendingFormat:@"(%@)",model.SpndingTypeName];
            model.stateString = [ListKZFKStateArray objectAtIndex:model.State];
            StateCode idx = [StateCodeStringArray indexOfObject:model.stateString];
            model.stateColor =   [StateCodeColorHexArray objectAtIndex:idx];
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
    if (self.dataArray.count < self.totalNum) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    XMKZDetialListCell *cell = [XMKZDetialListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    //    cell.cellType = CellType_CGSHList;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMKZDetialListModel *model =  self.dataArray[indexPath.row];
    XMKZDetialController *xmkzVC = [[XMKZDetialController alloc]init];
    xmkzVC.detialModel = model;
    xmkzVC.eld = self.eld;
    xmkzVC.title =  @"开支付款";
    [self.navigationController pushViewController:xmkzVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshSJYKZFKListView" object:nil];
}
-(void)refreshListView{
    [self.tableView.mj_header beginRefreshing];
}

@end
