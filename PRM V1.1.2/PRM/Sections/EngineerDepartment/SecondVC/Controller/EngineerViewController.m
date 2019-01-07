//
//  EngineerController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "EngineerViewController.h"

//交接确认
#import "FileTransferHeaderView.h"
#import "FileTransferCell.h"
#import "FileTransferModel.h"
#import "TransferCellClickModel.h"

//施工管理
#import "EngineeringHeaderView.h"
#import "EngineeringCell.h"
#import "EngineeringModel.h"
#import "EngineerInfoViewController.h"

//现场接收

#import "ReceiveGoodsViewController.h"

//项目请购
#import "MarketOrderHeaderView.h"
#import "MarketOrderCell.h"
#import "MarketOrderModel.h"
#import "ProjectPurchuseViewController.h"

//项目变更
//  #import "EngineeringHeaderView.h"
#import "ChangeOrdersCell.h"
#import "ChangeOrdersModel.h"
#import "ProjectChangeViewController.h"

//变更审核
#import "ChangeOrdersApproveHeaderView.h"
#import "ChangeOrdersApproveCell.h"
#import "ChangeOrdersApproveModel.h"
#import "SearchSelectView.h"
#import "PopSelectTypeTableView.h"

#import "ProjectHandoverCellAlertView.h"



@interface EngineerViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIDocumentInteractionControllerDelegate,
UIPopoverPresentationControllerDelegate>{
    PopSelectTypeTableView *tableVC;
    
    BOOL cellClickRequestSuccessed;
    TransferCellClickModel *cellClickModel;
    BOOL HaveAgreement;
    BOOL HaveDeepenDesign;
    BOOL HaveProgram;
    NSInteger page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;

@property(nonatomic,strong)SearchSelectView *searchView;
@property(nonatomic,strong)ProjectHandoverCellAlertView *mutliSelectView;


@end
@implementation EngineerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    
    [self setNavigationItems];
    [self registerDifferentSectionHeadersAndListCells];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}
#pragma mark ------------------------配置NavigationItems
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    if ([self.mainModel.url isEqualToString:@"ChangeOrdersApprove"]) {//变更审核
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(showSearchViewAction:)] ;
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
        
        self.searchView =[[[NSBundle mainBundle]loadNibNamed:@"SearchSelectView" owner:nil options:nil] firstObject];
        [self.view addSubview:self.searchView];
        [self.searchView.stateButton setTitle:@"未审核" forState:UIControlStateNormal];
        [self.searchView.stateButton addTarget:self action:@selector(showSelectTypeViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchView.cancelButton addTarget:self action:@selector(hiddenSearchViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchView.searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        self.searchView.hidden= YES;
        //注册通知,监听键盘弹出事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        //注册通知,监听键盘消失事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
        
    }
}
-(void)showSearchViewAction:(UINavigationItem *)sender{
    self.searchView.hidden = NO;
}

-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark ------------------------注册 cell
-(void)registerDifferentSectionHeadersAndListCells{
    //    [self setTableViewProperty];
    //交接确认
    if ([self.mainModel.url isEqualToString:@"FileTransferEngineering"]) {//交接确认
        
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestFileTransferEngineeringListData_JJQR];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
    }else if ([self.mainModel.url isEqualToString:@"Engineering"]) {//施工管理
        [self.tableView registerNib:[UINib nibWithNibName:@"EngineeringHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"EngineeringCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestData_SGGL];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
        
    }else if([self.mainModel.text isEqualToString:@"现场收货"]){//现场收货
#warning mark------------------xian chang shou huo
        [self.tableView registerNib:[UINib nibWithNibName:@"EngineeringHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"EngineeringHeaderView"];
        [self.tableView registerNib:[UINib nibWithNibName:@"EngineeringCell" bundle:nil] forCellReuseIdentifier:@"EngineeringCell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestData_XCSH];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
    }else if ([self.mainModel.url isEqualToString:@"MarketOrder"]) {//项目请购
        [self.tableView registerNib:[UINib nibWithNibName:@"MarketOrderHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"MarketOrderCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestAppInquiryMOListData_XMQG];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
    }else if ([self.mainModel.url isEqualToString:@"ChangeOrders"]) {//项目变更
        [self.tableView registerNib:[UINib nibWithNibName:@"EngineeringHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"ChangeOrdersCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestData_XMBG];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
    }else if ([self.mainModel.url isEqualToString:@"ChangeOrdersApprove"]) {//变更审核
        [self.tableView registerNib:[UINib nibWithNibName:@"ChangeOrdersApproveHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"ChangeOrdersApproveCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestData_BGSH_WithSearchState:self.searchView.stateButton.titleLabel.text AndSearchNum:@""];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
        
    }else if ([self.mainModel.url isEqualToString:@"ProjectProcess"]) {//项目进度
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestData_XMJD];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
        
    }else if ([self.mainModel.url isEqualToString:@"MySpending"]) {//我的报销
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self requestData_WDBX];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


#pragma mark ------------------------请求数据

//交接确认
-(void)requestFileTransferEngineeringListData_JJQR{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"FileTransferEngineeringList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            FileTransferModel *model = [[FileTransferModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}
//施工管理
-(void)requestData_SGGL{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppEngineeringList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            EngineeringModel *model = [[EngineeringModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
         [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
    
}
//现场收货
-(void)requestData_XCSH{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppProcurementProjectBranchList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            EngineeringModel *model = [[EngineeringModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
           [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}
//项目变更
-(void)requestData_XMBG{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppWaitCOList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            ChangeOrdersModel *model = [[ChangeOrdersModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
    
}
//项目请购
-(void)requestAppInquiryMOListData_XMQG{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppInquiryMOList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",kEmployeeID);
        kMyLog(@"%@",responder);
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSArray *rows = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rows.firstObject];
        for (NSDictionary *dic in rows) {
            MarketOrderModel *model = [[MarketOrderModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
         [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        [self endRefresh];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}

//变更审核
-(void)requestData_BGSH_WithSearchState:(NSString *)stateStr AndSearchNum:(NSString *)numString{
    [self.dataArray removeAllObjects];
    NSString *stateString = [stateStr isEqual: @"未审核"]?@"0":([stateStr  isEqual:@"全部"]?@"2":@"1");
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppChangeOrdersList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID,@"SearchStateID":stateString,@"SearchCode":numString} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            ChangeOrdersApproveModel *model = [[ChangeOrdersApproveModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
       [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}
-(void)requestData_XMJD{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"ProcessProjectBranchList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self endRefresh];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        [self endRefresh];
    }];
}
//我的报销
-(void)requestData_WDBX{
    [self endRefresh];
}
-(void)showInfoMentation{
    if (self.dataArray.count ==0 ) {
        [self showMessageLabel:@"后台无可加载数据.."withBackColor:kGeneralColor_lightCyanColor];
    }
}
#pragma mark ------------------------UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view;
    if([self.mainModel.text isEqualToString:@"现场收货"]){//现场收货
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EngineeringHeaderView"];
    }else{
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.mainModel.url];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id commonModel = [self.dataArray objectAtIndex:indexPath.row];
    id commonCell;
    if ([self.mainModel.text isEqualToString:@"现场收货"]){
        commonCell = [tableView  dequeueReusableCellWithIdentifier:@"EngineeringCell" forIndexPath:indexPath];
    }else{
        commonCell = [tableView  dequeueReusableCellWithIdentifier:self.mainModel.url forIndexPath:indexPath];
    }
    
    if ([self.mainModel.url isEqualToString:@"FileTransferEngineering"]) {//交接确认
        FileTransferCell *cell = commonCell;
        FileTransferModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"Engineering"]) {//施工管理
        EngineeringCell *cell = commonCell;
        EngineeringModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.text isEqualToString:@"现场收货"]) {//现场收货
        EngineeringCell *cell = commonCell;
        EngineeringModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"MarketOrder"]) {//项目请购
        MarketOrderCell *cell = commonCell;
        MarketOrderModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"ChangeOrders"])  {//项目变更
        ChangeOrdersCell *cell = commonCell;
        ChangeOrdersModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else  if ([self.mainModel.url isEqualToString:@"ChangeOrdersApprove"])  {//变更审核
        ChangeOrdersApproveCell *cell = commonCell;
        ChangeOrdersApproveModel *model = commonModel;
        [cell showCellDataWithModel:model];
        cell.downLoadButton.tag = indexPath.row+1000;
        [cell.downLoadButton addTarget:self action:@selector(downloadFileWithSender:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else  {
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row ];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.mainModel.url isEqualToString:@"FileTransferEngineering"]){
        cellClickRequestSuccessed = NO;
        cellClickModel = [self.dataArray objectAtIndex:indexPath.row];
        self.mutliSelectView = [[[NSBundle mainBundle]loadNibNamed:@"ProjectHandoverCellAlertView" owner:nil options:nil] firstObject];
        [self requestAppGetFTInfoWithProjectBranchID:cellClickModel.Id];
        
        [self.mutliSelectView.cancleButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mutliSelectView.confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.mutliSelectView];
        [self.mutliSelectView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.mutliSelectView.stateBlock = ^(BOOL isFirst,BOOL isSecond,BOOL isThird){
            HaveAgreement = isFirst;
            HaveDeepenDesign = isSecond;
            HaveProgram = isThird;
        };
    }
    if ([self.mainModel.url isEqualToString:@"Engineering"]){
        EngineeringModel *model = [self.dataArray objectAtIndex:indexPath.row];
        EngineerInfoViewController *engineerinfoVC = [[EngineerInfoViewController alloc] initWithNibName:@"EngineerInfoViewController" bundle:nil];
        engineerinfoVC.projectBranchID = [NSString stringWithFormat:@"%@",model.Id];
        engineerinfoVC.title = [NSString stringWithFormat:@"施工信息"];
        [self.navigationController pushViewController:engineerinfoVC animated:YES];
    }
    if ([self.mainModel.text isEqualToString:@"现场收货"]){
        EngineeringModel *model = [self.dataArray objectAtIndex:indexPath.row];
        ReceiveGoodsViewController *receiveGoodVC = [[ReceiveGoodsViewController alloc] initWithNibName:@"ReceiveGoodsViewController" bundle:nil];
        receiveGoodVC.projectBranchID = [NSString stringWithFormat:@"%@",model.Id];
        receiveGoodVC.title = [NSString stringWithFormat:@"收货列表"];
        [self.navigationController pushViewController:receiveGoodVC animated:YES];
    }
    if ([self.mainModel.url isEqualToString:@"MarketOrder"]) {
        MarketOrderModel *model = self.dataArray[indexPath.row];
        ProjectPurchuseViewController * projectPurchuseVC = [[ProjectPurchuseViewController alloc]initWithNibName:@"ProjectPurchuseViewController" bundle:nil];
        projectPurchuseVC.marketOrderID = [NSString stringWithFormat:@"%@",model.Id];
        projectPurchuseVC.title = [NSString stringWithFormat:@"请购详情"];
        [self.navigationController pushViewController:projectPurchuseVC animated:YES];
    }
    
    if ([self.mainModel.url isEqualToString:@"ChangeOrders"]) {
        ChangeOrdersModel *model = self.dataArray[indexPath.row];
        ProjectChangeViewController *projectChangeVC = [[ProjectChangeViewController alloc]initWithNibName:@"ProjectChangeViewController" bundle:nil];
        projectChangeVC.projectBranchID = [NSString stringWithFormat:@"%@",model.Id];
        projectChangeVC.title = [NSString stringWithFormat:@"变更详情"];
        [self.navigationController pushViewController:projectChangeVC animated:YES];
    }
    
    
    if ([self.mainModel.url isEqualToString:@"ChangeOrdersApprove"]) {
        ChangeOrdersApproveModel *model = self.dataArray[indexPath.row];
        kMyLog(@"%@",model );
        if ([self.searchView.stateButton.titleLabel.text isEqual:@"未审核"]) {
            [self alertViewMentationUsersWithMessage:@"请确认审核通过?" withModel:model];
        }else{
            [self showMessageLabel:@"此数据已审核,无法重复审核" withBackColor:kGeneralColor_lightCyanColor];
        }
    }
    if ([self.mainModel.url isEqualToString:@"ProjectProcess"]) {
        ChangeOrdersApproveModel *model = self.dataArray[indexPath.row];
        kMyLog(@"%@",model );
    }
    if ([self.mainModel.url isEqualToString:@"MySpending"]) {
        ChangeOrdersApproveModel *model = self.dataArray[indexPath.row];
        kMyLog(@"%@",model );
    }
}
-(void)requestAppGetFTInfoWithProjectBranchID:(NSString *)modelId{
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppGetFTInfo"];
    [self showProgressHUD];
    NSDictionary *paraDic = @{@"ProjectBranchID":modelId};
    __block TransferCellClickModel *model;
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:paraDic finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSMutableDictionary *ftDic = [NSMutableDictionary dictionaryWithDictionary:responder];
        if ([modelId isEqual:[ftDic objectForKey:@"ProjectBranchID"]] ) {
            cellClickRequestSuccessed = YES;
            model = [[TransferCellClickModel alloc]init];
            [model setValuesForKeysWithDictionary:[self changeNullWithDic:ftDic]];
        }else{
            cellClickRequestSuccessed = NO;
        }
        [self hideProgressHUD];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self hideProgressHUD];
        cellClickRequestSuccessed = NO;
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
    
}

-(void)cancelButtonAction:(UIButton *)sender{
    [self.mutliSelectView removeFromSuperview];
}
-(void)confirmButtonAction:(UIButton *)sender{
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    FileTransferModel *model = [self.dataArray objectAtIndex:index.row];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppFTEngineeringApproval"];
    [self showProgressHUD];
    NSDictionary *paraDic = @{
                              @"ProjectBranchID":model.Id,
                              @"EmployeeID":kEmployeeID,
                              @"HaveAgreement":@(HaveAgreement),
                              @"HaveDeepenDesign":@(HaveDeepenDesign),
                              @"HaveProgram":@(HaveProgram)
                              };
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:paraDic finish:^(id responder) {
        kMyLog(@"%@",responder);
        [self.mutliSelectView removeFromSuperview];
        if ([[responder objectForKey:@"success"] boolValue]) {
            [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
            [self performSelectorOnMainThread:@selector(requestFileTransferEngineeringListData_JJQR) withObject:nil waitUntilDone:YES];
        }else{
            [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
        }
        [self hideProgressHUD];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        //        [self endRefresh];
        [self hideProgressHUD];
        [self.mutliSelectView removeFromSuperview];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}


-(void)alertViewMentationUsersWithMessage:(NSString *)message withModel:(ChangeOrdersApproveModel *)model  {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"变更审核" message:message preferredStyle:UIAlertControllerStyleAlert];
    //确定按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestChangeorderApprovelWithModelID:model.Id];
    }]];
    //取消按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)requestChangeorderApprovelWithModelID:(NSString *)modelId{
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"SaveChangeOrders"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"ChangeOrderID":modelId,@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        [self performSelector:@selector(showMessage:) withObject:[responder objectForKey:@"msg"] afterDelay:0.01];
        
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self showMessageLabel:@"审核出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
    
}
-(void)showMessage:(NSString *)message{
    [self showMessageLabel:message withBackColor:kGeneralColor_lightCyanColor];
}

#pragma mark ************************* 变更审核 _____ 附件下载
-(void)downloadFileWithSender:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:sender.tag-1000 inSection:0];
    ChangeOrdersApproveModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *fileNameString ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if (model.Url.length == 0) {
        [self showMessageLabel:@"附件不存在" withBackColor:kGeneralColor_lightCyanColor];
    }else{
        fileNameString = [[model.Url componentsSeparatedByString:@"/"] lastObject];
        
        NSString *savefilePath = [document stringByAppendingPathComponent:fileNameString];
        if ([fileManager fileExistsAtPath:savefilePath]) {
            //存在  --------弹窗提示直接打开 //重新新下载
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认" message:@"文件已存在是否重新下载" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction: [UIAlertAction actionWithTitle:@"直接打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //快速预览
                [self openFileAtPath:[NSURL fileURLWithPath:savefilePath]];
            }]];
            [alertVC addAction: [UIAlertAction actionWithTitle:@"重新下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [fileManager removeItemAtPath:savefilePath error:nil];
                [self downLoadFileWithCellModeUrl:model.Url saveAtPath:savefilePath];
            }]];
            [alertVC addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }else {
            //不存在-------下载保存
            [self downLoadFileWithCellModeUrl:model.Url saveAtPath:savefilePath];
        }
    }
    
}
-(void)downLoadFileWithCellModeUrl:(NSString  *)downloadUrl saveAtPath:(NSString *)saveFilePath{
    NSURL * url = [NSURL URLWithString:[downloadUrl stringByReplacingOccurrencesOfString:@".." withString:kImageUrl]];
    [NewNetWorkManager downLoadFilesWithUrlStr:url progress:^(NSProgress *downloadProgress) {
        //进度
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgressHUDWithStr:[NSString stringWithFormat:@"%.2f%%",(downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount*100)]];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:saveFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"查看附件?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openFileAtPath:filePath];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        });
        kMyLog(@"%@",filePath);
        /*
         [self.quickLookArray addObject:filePath];
         NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
         NSURL *url = [NSURL fileURLWithPath:path];
         */
        
        kMyLog(@"附件");
    }];
}
-(void)openFileAtPath:(NSURL *)filePath{
    if (filePath) {
        if ([[NSString stringWithFormat:@"%@",filePath] hasSuffix:@"TTF"]) {
            [self showMessageLabel:@"不支持的文件格式" withBackColor:kGeneralColor_lightCyanColor];
        }else{
            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
            //self.documentInteractionController
            [self.documentInteractionController setDelegate:self];
            [self.documentInteractionController presentPreviewAnimated:YES];
        }
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"打开失败" message:@"打开文档失败，可能文档损坏，请重试" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}




#pragma mark - UIDocumentInteractionControllerdelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark ***************************搜索弹窗事件
#pragma mark ******************状态选择
-(void)hiddenSearchViewAction:(UIButton *)sender{
    [self.searchView endEditing:YES];
    self.searchView.hidden = YES;
}

-(void)searchAction:(UIButton *)sender{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self requestData_BGSH_WithSearchState:self.searchView.stateButton.titleLabel.text AndSearchNum:self.searchView.numberTF.text];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self.searchView endEditing:YES];
    self.searchView.hidden = YES;
}

//类型选择
- (void)showSelectTypeViewAction:(UIButton *)sender {
    //注意弹出的不是popover，而是内容，他的内容会呈现在popover中
    NSMutableArray *dataArr = [@[@"全部", @"未审核",@"已审核"] mutableCopy];
    [self  setPopSelectTypeViewwWithDataSource:dataArr
                                    SourceView:sender
                                     SoureRect: sender.bounds
                                      ViewSize:CGSizeMake(sender.frame.size.width , dataArr.count*30)];
    [self presentViewController:tableVC animated:YES completion:nil];
}

-(void)setPopSelectTypeViewwWithDataSource:(NSMutableArray *)dataArray SourceView:(id)sender SoureRect:(CGRect)sourceRect  ViewSize:(CGSize )viewSize {
    tableVC = [[PopSelectTypeTableView alloc] init];
    tableVC.dataSource = dataArray;
    __weak typeof(self) weakSelf= self ;
    tableVC.selectAloneCellBlock = ^(NSString *stateString){
        [weakSelf.searchView.stateButton setTitle:stateString forState:UIControlStateNormal];
    };
    tableVC.modalPresentationStyle = UIModalPresentationPopover;
    //设置弹出的大小
    tableVC.preferredContentSize =viewSize ;
    //注意：popover不是通过alloc init创建出来的，而是从内容控制器中的popoverPresentationController 属性 得到
    UIPopoverPresentationController *popover = tableVC.popoverPresentationController;
    //设置弹出位置
    popover.sourceView = sender;
    popover.sourceRect = sourceRect;
    //设置箭头的方向
    //UIPopoverArrowDirectionAny 让系统自动调整方向
    popover.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    //设置箭头的颜色
    popover.backgroundColor = [UIColor whiteColor];
    //设置代理
    popover.delegate = self;
}

//返回UIModalPresentationNone，按照内容控制自己指定的方式popover进行弹出
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark ********************键盘处理事件
// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification{
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    kMyLog(@"%@",keyboardObject);
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    //得到键盘的高度
    //CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    kMyLog(@"%f",duration);
    //调整放置有textView的view的位置
    [UIView animateWithDuration:duration animations:^{
        //设置view的frame，往上平移
        self.searchView.frame = CGRectMake(0, - keyboardRect.size.height + 40, kDeviceWidth, kDeviceHeight+ keyboardRect.size.height);
    }];
}
//键盘消失时
-(void)keyboardDidHidden{
    //定义动画
    [UIView animateWithDuration:0.25 animations:^{
        //设置view的frame，往下平移
        self.searchView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    } completion:nil];
    
}
@end
