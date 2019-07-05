//
//  SJYMenuViewController.m
//  PRM
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYMenuViewController.h"

#define  CellHigh  50

@interface SJYMenuViewController ()<QMUITableViewDelegate,QMUITableViewDataSource>

@property (nonatomic, strong) QMUITableView *tableView;

@end
@implementation SJYMenuViewController

- (void)setUpNavigationBar{
    self.navBar.hidden = YES;
}

-(void)buildSubviews{
    self.tableView = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, MainDrawerWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 250)];
    headerView.backgroundColor = Color_NavigationLightBlue;

    UIImageView *imgView  = [UIImageView new];
    imgView.image = SJYCommonImage(@"zxlogo");
    [headerView addSubview:imgView];

    QMUILabel *welcomeLab = [[QMUILabel alloc]init];
    welcomeLab.textAlignment = NSTextAlignmentCenter;
    welcomeLab.numberOfLines = 0;
    welcomeLab.font = SJYBoldFont(17);
    welcomeLab.textColor = UIColorWhite;
    welcomeLab.text = [@"您好，" stringByAppendingString:[SJYDefaultManager shareManager].getEmployeeName];
    [headerView addSubview:welcomeLab];


    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_left).offset(MainDrawerWidth/2);
        make.centerY.equalTo(headerView.mas_centerY);
        make.width.equalTo(80);
        make.height.equalTo(80);
    }];
    [imgView rounded:4];

    [welcomeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(20);
        make.centerX.equalTo(headerView.mas_left).offset(MainDrawerWidth/2);
        make.width.equalTo(MainDrawerWidth/2-15);
    }];

    self.tableView.tableHeaderView = headerView;
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc]
                                                initWithCellDataSections:@[
                                                                           @[
                                                                               ({
        QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
        cellData.identifier = 0;
        cellData.style = UITableViewCellStyleValue1;
        cellData.text = @"当前版本";
        cellData.detailText = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cellData.height = CellHigh;
        //            cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            cell.textLabel.font = Font_ListTitle;
            cell.textLabel.textColor = Color_TEXT_HIGH;
            cell.detailTextLabel.font = Font_ListTitle;
            cell.detailTextLabel.textColor = Color_TEXT_NOMARL;
        };
        cellData; })
                                                                               //                                                                            ,({
                                                                               //            QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
                                                                               //            cellData.identifier = 1;
                                                                               //            cellData.style = UITableViewCellStyleValue1;
                                                                               //            cellData.text = @"服务器";
                                                                               //            cellData.detailText = [[SJYDefaultManager shareManager].getIPAddress stringByAppendingFormat:@":%@",[SJYDefaultManager shareManager].getIPPort] ;
                                                                               //            cellData.height = CellHigh;
                                                                               //            cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
                                                                               //                cell.textLabel.font = Font_ListTitle;
                                                                               //                cell.detailTextLabel.font = Font_ListTitle;
                                                                               //                cell.textLabel.textColor = Color_TEXT_HIGH;
                                                                               //                cell.detailTextLabel.textColor = Color_TEXT_NOMARL;
                                                                               //            };
                                                                               //            cellData; })
                                                                               ],
                                                                           @[
                                                                               //                                                                                ({
                                                                               //                QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
                                                                               //                cellData.identifier = 2;
                                                                               //                cellData.style = UITableViewCellStyleSubtitle;
                                                                               //                //                cellData.image = SJYCommonImage(@"zx");
                                                                               //                cellData.text = @"注销";
                                                                               //                cellData.detailText = @"注销将清除缓存的用户信息";
                                                                               //                cellData.height = CellHigh;
                                                                               //                cellData.didSelectTarget = self;
                                                                               //                cellData.didSelectAction = @selector(selectCellAction:);
                                                                               //                cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                                                                               //                cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
                                                                               //                    cell.textLabel.font = Font_ListTitle;
                                                                               //                    cell.detailTextLabel.font = Font_ListOtherTxt;
                                                                               //                    cell.textLabel.textColor = Color_TEXT_HIGH;
                                                                               //                    cell.detailTextLabel.textColor = Color_TEXT_NOMARL;
                                                                               //                };
                                                                               //                cellData; }),
                                                                               //                                                                                ({
                                                                               //        QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
                                                                               //        cellData.identifier = 4;
                                                                               //        cellData.style = UITableViewCellStyleSubtitle;
                                                                               //        //                cellData.image = SJYCommonImage(@"zx");
                                                                               //        cellData.text = @"修改密码";
                                                                               ////        cellData.detailText = @"注销将清除缓存的用户信息";
                                                                               //        cellData.height = CellHigh;
                                                                               //        cellData.didSelectTarget = self;
                                                                               //        cellData.didSelectAction = @selector(selectCellAction:);
                                                                               //        cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                                                                               //        cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
                                                                               //            cell.textLabel.font = Font_ListTitle;
                                                                               //            cell.detailTextLabel.font = Font_ListOtherTxt;
                                                                               //            cell.textLabel.textColor = Color_TEXT_HIGH;
                                                                               //            cell.detailTextLabel.textColor = Color_TEXT_NOMARL;
                                                                               //        };
                                                                               //        cellData; }),

                                                                               ({
        QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
        cellData.identifier = 3;
        cellData.style = UITableViewCellStyleSubtitle;
        cellData.text = @"退出";
        // cellData.detailText = @"退出不清除缓存";
        cellData.height = CellHigh;
        cellData.didSelectTarget = self;
        cellData.didSelectAction = @selector(selectCellAction:);
        cellData.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            cell.textLabel.font = Font_ListTitle;
            cell.detailTextLabel.font = Font_ListOtherTxt;
            cell.textLabel.textColor = Color_TEXT_HIGH;
            cell.detailTextLabel.textColor = Color_TEXT_NOMARL;

        };
        cellData; }) ] ]];
}


#pragma mark - <QMUITableViewDataSource,  QMUITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  tableView.qmui_staticCellDataSource.cellDataSections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.qmui_staticCellDataSource.cellDataSections[section].count;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *foot =[UIView new];
    foot.backgroundColor = UIColorGrayLighten;
    return section == 0?  foot : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView.qmui_staticCellDataSource cellForRowAtIndexPath:indexPath];
    return cell;
}

-(void)selectCellAction:(QMUIStaticTableViewCellData *)cellData{
    QMUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellData.indexPath];
    NSString *string = nil;
    if (cellData.identifier == 2) {
        string = [cellData.detailText stringByAppendingFormat:@"，确定%@吗?",cellData.text];
        [self alertMentiuonView:cellData messageStr: string];
    } else   if (cellData.identifier == 3) {
        string = [NSString stringWithFormat:@"确定%@吗?",cellData.text];
        [self alertMentiuonView:cellData messageStr: string];
    }else{
        [self changePassword];
    }
    [self.tableView deselectRowAtIndexPath:cellData.indexPath animated:YES];
}


-(void)alertMentiuonView:(QMUIStaticTableViewCellData *)cellData messageStr:(NSString *)message{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"提醒";

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    contentView.backgroundColor = UIColorWhite;
    QMUILabel *label = [[QMUILabel alloc] init];
    label.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = Color_TEXT_NOMARL;
    label.font = Font_ListTitle;
    label.numberOfLines = 0;
    label.text = message;
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        cellData.identifier == 2?({ [self loginOut];  }):({  [self quitCurrentApp];});
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    modalViewController.contentViewController = dialogViewController;
    [modalViewController showInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

-(void)quitCurrentApp{
    if (![[SJYDefaultManager shareManager] isRemberPassword]) {
        [[SJYDefaultManager shareManager]saveUserName:@"" password:@""];
        [[SJYDefaultManager shareManager] saveEmployeeName:@"" Dt_Info:@"" EmployeeID:@"" DepartmentID:@"" PositionID:@""];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.4f animations:^{
        CGAffineTransform curent =  window.transform;
        CGAffineTransform scale = CGAffineTransformScale(curent, 0.1,0.1);
        [window setTransform:scale];
    } completion:^(BOOL finished) {
        exit(0);//
    }];
}
-(void)loginOut{
    [[SJYUserManager sharedInstance] clearLoginUC];
    [[SJYUserManager sharedInstance] clearUcAemp];
    [[SJYDefaultManager shareManager] saveRemberPassword:NO];
    
    if (![[SJYDefaultManager shareManager] isRemberPassword]) {
        [[SJYDefaultManager shareManager]saveUserName:@"" password:@""];
        [[SJYDefaultManager shareManager] saveEmployeeName:@"" Dt_Info:@"" EmployeeID:@"" DepartmentID:@"" PositionID:@""];
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate setRootViewController];
}

-(void)changePassword{
    SJYAlertShow(@"功能尚未完善后需添加功能,确定修改密码吗?", @"提交");
}
@end
