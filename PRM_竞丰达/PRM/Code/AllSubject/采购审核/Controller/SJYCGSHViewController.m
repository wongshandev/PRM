//
//  SJYBGSHViewController.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYCGSHViewController.h"
#import "CGFKListCell.h"
#import "SJYCGSHSearchAlertView.h"
#import "CGFKDetialViewController.h"
//value == 1 ? "计划" : (value == 2) ? "已提交" : (value == 3) ? "已驳回" : (value == 4) ? "财务已审" : (value == 5) ? "总经理已审" : (value == 6) ? "待付款" : (value == 7) ? "已付款" : "已入库";
#define  STATEArray  @[@"全部",@"未审核",@"已审核"]

#define  ListCGSHStateArray  @[@"",@"计划",@"已提交",@"已驳回",@"财务已审",@"总经理已审",@"待付款",@"已付款",@"已入库",@"已发运",@"接收中",@"已计划"]
@interface SJYCGSHViewController ()<QMUITextFieldDelegate>
@property (nonatomic, strong) SJYCGSHSearchAlertView * searchAlertView;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;
@property(nonatomic,assign)NSInteger eld;
@property(nonatomic,assign)NSInteger shStateType;
@property(nonatomic,copy)NSString * searchCode;

@end

@implementation SJYCGSHViewController


-(void)setUpNavigationBar{
    Weak_Self;
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    self.shStateType = 0;
    self.searchCode = @"";
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
    
    self.searchAlertView = [[SJYCGSHSearchAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.searchAlertView.backgroundColor = UIColorWhite;
    self.searchAlertView.codeTF.delegate = self;
    self.searchAlertView.codeTF.text = self.searchCode;
    [self.searchAlertView.stateBtn  setTitle:[STATEArray objectAtIndex:self.shStateType + 1] forState:UIControlStateNormal];
    self.searchAlertView.rightdownImgView.image = SJYCommonImage(@"downBlack");
    [self.searchAlertView.stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchAlertView.mas_top).offset(5);
        make.left.mas_equalTo(self.searchAlertView.mas_left).offset(10);
        make.width.mas_equalTo(70);
    }];
    [self.searchAlertView.codeLab makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.searchAlertView.rightdownImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.stateLab.mas_centerY);
        make.right.mas_equalTo( self.searchAlertView.stateBtn.mas_right);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(20);
    }];
    
    [self.searchAlertView.codeTF makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.codeLab.mas_centerY);
        make.left.mas_equalTo(self.searchAlertView.codeLab.mas_right).offset(5);
        make.right.mas_equalTo( self.searchAlertView.mas_right).offset(-10);
        make.height.mas_equalTo(self.searchAlertView.codeLab.mas_height);
    }];
    
    [self.searchAlertView.sepLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.searchAlertView.codeTF.mas_bottom);
        make.left.mas_equalTo(self.searchAlertView.codeTF.mas_left);
        make.right.mas_equalTo(self.searchAlertView.codeTF.mas_right);
        make.height.mas_equalTo(2);
    }];
    
    __block NSInteger shStateType = self.shStateType;
//    __block NSString *searchCode = self.searchCode;

    Weak_Self;
    [self.searchAlertView.stateBtn clickWithBlock:^{
        [self.searchAlertView endEditing:YES];
        [BRStringPickerView showStringPickerWithTitle:@"状态" dataSource:STATEArray defaultSelValue:weakSelf.searchAlertView.stateBtn.currentTitle isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
            [weakSelf.searchAlertView.stateBtn setTitle:selectValue forState:UIControlStateNormal];
            NSInteger index = [STATEArray indexOfObject:selectValue] -1;
            shStateType = index;
        }];
    }];
    
    dialogViewController.contentView = self.searchAlertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:weakSelf.view animated:YES completion:nil];
    }];
    
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        weakSelf.shStateType = shStateType;
        weakSelf.searchCode = weakSelf.searchAlertView.codeTF.text;
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
        weakSelf.page = 0;
        [weakSelf  requestData_CGSH];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf  requestData_CGSH];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshListView) name:@"refreshCGSHListView" object:nil];
}
-(void)requestData_CGSH{
    [SJYRequestTool requestCGSHListWithSearchStateID:self.shStateType SearchCode:self.searchCode page:self.page success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        self.eld = [[responder objectForKey:@"eId"] integerValue];
        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in rowsArr) {
            CGFKListModel *model = [CGFKListModel  modelWithDictionary:dic];
            model.isCGFK = NO;
            if(model.State < [ListCGSHStateArray count]){
                model.StateStr = [ListCGSHStateArray objectAtIndex:model.State];
                StateCode idx = [StateCodeStringArray indexOfObject:model.StateStr];
                model.StateColor =   [StateCodeColorHexArray objectAtIndex:idx];
            }else{
                model.StateStr =  ListCGSHStateArray.firstObject;
                model.StateColor = StateCodeColorHexArray.firstObject;
            }
            model.titleStr = model.CreateName.length?[NSString stringWithFormat:@"(%@)  %@",model.CreateName,model.Name]:model.Name;
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
    CGFKListCell *cell = [CGFKListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.cellType = CellType_CGSHList;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGFKListModel *model =  self.dataArray[indexPath.row];
    CGFKDetialViewController *dealVC = [[CGFKDetialViewController alloc]init];
    dealVC.listModel = model;
    dealVC.eld = self.eld;
    dealVC.title = model.Name;
    [self.navigationController pushViewController:dealVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshCGSHListView" object:nil];
}
-(void)refreshListView{
    [self.tableView.mj_header beginRefreshing];
}

@end
