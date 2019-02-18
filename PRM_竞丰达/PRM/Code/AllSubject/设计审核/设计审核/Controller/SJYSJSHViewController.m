//
//  SJYSJSHViewController.m
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYSJSHViewController.h"
#import "SJYJJQRListCell.h"
#import "SJYSJSHSearchAlertView.h"
#import "SJSHDetialSuperController.h"

#define  STATEArray  @[@"未审核",@"已审核",@"全部"]

@interface SJYSJSHViewController ()<QMUITextFieldDelegate>
@property (nonatomic, strong) SJYSJSHSearchAlertView * searchAlertView;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;

@property(nonatomic,copy)NSString * shStateType;
@property(nonatomic,copy)NSString * searchCode;
@property(nonatomic,copy)NSString * searchName;

@end

@implementation SJYSJSHViewController

-(void)setUpNavigationBar{
    Weak_Self;
    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    self.shStateType = @"0";
    self.searchCode = @"";
    self.searchName = @"";

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

    self.searchAlertView = [[SJYSJSHSearchAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    self.searchAlertView.backgroundColor = UIColorWhite;
     self.searchAlertView.codeTF.delegate = self;
    self.searchAlertView.codeTF.text = self.searchCode;
    self.searchAlertView.nameTF.delegate = self;
    self.searchAlertView.nameTF.text = self.searchName;
    [self.searchAlertView.stateBtn  setTitle:[STATEArray objectAtIndex:self.shStateType.integerValue] forState:UIControlStateNormal];
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
         make.height.mas_equalTo(self.searchAlertView.stateLab.mas_height);
    }];
    [self.searchAlertView.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchAlertView.codeLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.searchAlertView.codeLab.mas_left);
        make.width.mas_equalTo(self.searchAlertView.codeLab.mas_width);
        make.bottom.mas_equalTo(self.searchAlertView.mas_bottom).offset(-10);
        make.height.mas_equalTo(self.searchAlertView.codeLab.mas_height);
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
    [self.searchAlertView.sepLineCode makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.searchAlertView.codeTF.mas_bottom);
        make.left.mas_equalTo(self.searchAlertView.codeTF.mas_left);
        make.right.mas_equalTo(self.searchAlertView.codeTF.mas_right);
        make.height.mas_equalTo(2);
    }];
    [self.searchAlertView.nameTF makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchAlertView.nameLab.mas_centerY);
        make.left.mas_equalTo(self.searchAlertView.nameLab.mas_right).offset(5);
        make.right.mas_equalTo( self.searchAlertView.mas_right).offset(-10);
        make.height.mas_equalTo(self.searchAlertView.nameLab.mas_height);
    }];
    [self.searchAlertView.sepLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.searchAlertView.nameTF.mas_bottom);
        make.left.mas_equalTo(self.searchAlertView.nameTF.mas_left);
        make.right.mas_equalTo(self.searchAlertView.nameTF.mas_right);
        make.height.mas_equalTo(2);
    }];


    Weak_Self;
    [self.searchAlertView.stateBtn clickWithBlock:^{
        [self.searchAlertView endEditing:YES];
        [BRStringPickerView showStringPickerWithTitle:@"项目状态" dataSource:STATEArray defaultSelValue:weakSelf.searchAlertView.stateBtn isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
            [weakSelf.searchAlertView.stateBtn setTitle:selectValue forState:UIControlStateNormal];
            weakSelf.shStateType = [@([STATEArray indexOfObject:selectValue]) stringValue];
        }];
    }];

    dialogViewController.contentView = self.searchAlertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:self.view animated:YES completion:nil];
    }];

    [dialogViewController addSubmitButtonWithText:@"提交" block:^(QMUIDialogViewController *aDialogViewController) {

        [modalViewController hideInView:self.view animated:YES completion:^(BOOL finished) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }];

    modalViewController.modal = YES;
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
        [weakSelf request_SJSHData];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf request_SJSHData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshListView) name:@"refreshSJSHListView" object:nil];
}

-(void)refreshListView{
    [self.tableView.mj_header beginRefreshing];
}

-(void)request_SJSHData{

    [SJYRequestTool requestSJSHListWithSearchStateID:self.shStateType SearchCode:self.searchCode SearchName:self.searchName page:self.page  success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];

        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in rowsArr) {
            SJSHListModel  *model = [SJSHListModel  modelWithDictionary:dic];
            model.titleStr = [model.Name stringByAppendingFormat:@" (%@)",model.Code];
            model.stateString = model.State.integerValue>0?[STATEArray objectAtIndex:1]:STATEArray.firstObject;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SJYJJQRListCell *cell = [SJYJJQRListCell cellWithTableView:tableView];
    cell .indexPath = indexPath;
    cell.cellType =CellType_SJSHList;
    cell.data = self.dataArray[indexPath.row];
    [cell loadContent];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SJSHListModel *model = self.dataArray[indexPath.row];
    SJSHDetialSuperController*sjshSupVC = [[SJSHDetialSuperController alloc]init];
    sjshSupVC.sjshListModel = model;
    sjshSupVC.title = model.Name;
    [self.navigationController pushViewController:sjshSupVC animated:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.searchAlertView.codeTF) {
        textField.text = self.searchCode;
        self.searchAlertView.sepLineCode.backgroundColor = Color_NavigationLightBlue;
    }
    if (textField == self.searchAlertView.nameTF) {
        textField.text = self.searchName;
        self.searchAlertView.sepLine.backgroundColor = Color_NavigationLightBlue;
    }

}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.searchAlertView.codeTF) {
        self.searchCode = textField.text.length !=0? textField.text:@"";
        self.searchAlertView.sepLineCode.backgroundColor = Color_SrprateLine;

    }
    if (textField == self.searchAlertView.nameTF) {
        self.searchName = textField.text.length !=0 ? textField.text:@"";
        self.searchAlertView.sepLine.backgroundColor = Color_SrprateLine;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshSJSHListView" object:nil];

}

@end
