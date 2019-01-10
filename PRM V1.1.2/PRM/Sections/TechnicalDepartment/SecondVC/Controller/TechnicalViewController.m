//
//  EngineerController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "TechnicalViewController.h"

//设计审核
#import "DesignAllApproveHeaderView.h"
#import "DesignAllApproveCell.h"

//交接确认
#import "FileTransferHeaderView.h"
#import "FileTransferCell.h"
#import "FileTransferModel.h"

#import "ProjectHandoverCellAlertView.h"
#import "TransferCellClickModel.h"

//采购付款
#import "PurchaseOrderPayHeaderView.h"
#import "PurchaseOrderPayCell.h"
#import "PurchaseOrderPayModel.h"

//辅料报销
#import "ProcurementApproveHeaderView.h"
#import "ProcurementApproveCell.h"

//项目进度
#import "ProjectProcessHeaderView.h"
#import "ProjectProcessCell.h"

@interface TechnicalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL cellClickRequestSuccessed;
    BOOL HaveAgreement;
    BOOL HaveDeepenDesign;
    BOOL HaveProgram;
}
@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)ProjectHandoverCellAlertView *mutliSelectView;

@property (assign, nonatomic) NSInteger page; //!< 数据页数.表示下次请求第几页的数据.


@end
@implementation TechnicalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self setNavigationItems];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {  make.edges.mas_equalTo(self.view).mas_offset(UIEdgeInsetsMake(kTopStatusAndNavBarHeight, 0, 0, 0));
    }];
    [self registerDifferentSectionHeadersAndListCells];
}
#pragma mark ------------------------配置NavigationItems
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
}

#pragma mark ------------------------注册 cell
-(void)registerDifferentSectionHeadersAndListCells{
    //设计审核
    if ([self.mainModel.url isEqualToString:@"DesignAllApprove"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"DesignAllApproveHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"DesignAllApproveCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self requestDesignAllApproveData_SJSH];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];

    }
    //交接确认
    if ([self.mainModel.url isEqualToString:@"FileTransferDesign"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
          [self requestFileTransferDesignListData_JJQR];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    //采购付款
    if ([self.mainModel.url isEqualToString:@"PurchaseOrderPay"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseOrderPayHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseOrderPayCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self requestAppPOListData_CGFK];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    //辅料报销
    if ([self.mainModel.url isEqualToString:@"ProcurementApprove"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ProcurementApproveHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"ProcurementApproveCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
         [self requestData_FLBX];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    //项目进度
    if ([self.mainModel.url isEqualToString:@"ProjectProcess"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ProjectProcessHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"ProjectProcessCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
                    [self requestData_XMJD];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark ------------------------请求数据
//http://58.216.202.186:8811/Pro/ApproveDeepenDesignList?page=1&rows=20
//设计审核
-(void)requestDesignAllApproveData_SJSH{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"ApproveDeepenDesignList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);

        
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
//交接确认
-(void)requestFileTransferDesignListData_JJQR{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"FileTransferDesignList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
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
        [self hideProgressHUD];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}
//采购付款
-(void)requestAppPOListData_CGFK{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppPOList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            PurchaseOrderPayModel *model = [[PurchaseOrderPayModel alloc] init];
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
//辅料报销
//http://58.216.202.186:8811/Pro/SpotProjectBranchList
-(void)requestData_FLBX{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"SpotProjectBranchList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);

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
//项目进度
//http://58.216.202.186:8811/Pro/ProcessProjectBranchList
-(void)requestData_XMJD{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"ProcessProjectBranchList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);

        
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
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.mainModel.url];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id commonModel = [self.dataArray objectAtIndex:indexPath.row];
    id commonCell  = [tableView  dequeueReusableCellWithIdentifier:self.mainModel.url forIndexPath:indexPath];
    if ([self.mainModel.url isEqualToString:@"DesignAllApprove"]) { //设计审核
        DesignAllApproveCell *cell = commonCell;
        
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"FileTransferDesign"]) {//交接确认
        FileTransferCell *cell = commonCell;
        FileTransferModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"PurchaseOrderPay"]) {//采购付款
        PurchaseOrderPayCell *cell = commonCell;
        PurchaseOrderPayModel *model = commonModel;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"ProcurementApprove"]) {//辅料报销
        ProcurementApproveCell *cell = commonCell;
        
        return cell;
        
    }else if ([self.mainModel.url isEqualToString:@"ProjectProcess"]) {//项目进度
        ProjectProcessCell *cell = commonCell;
        
        return cell;
    }else{
        UITableViewCell *cell1=commonCell;
        return cell1;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.mainModel.url isEqualToString:@"DesignAllApprove"]) { //设计审核
        
    }
    if ([self.mainModel.url isEqualToString:@"FileTransferDesign"]) {//交接确认
        cellClickRequestSuccessed = NO;
        FileTransferModel *model = [self.dataArray objectAtIndex:indexPath.row];
        self.mutliSelectView = [[[NSBundle mainBundle]loadNibNamed:@"ProjectHandoverCellAlertView" owner:nil options:nil] firstObject];
        [self requestAppGetFTInfoWithProjectBranchID:model.Id];
        
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
    if ([self.mainModel.url isEqualToString:@"PurchaseOrderPay"]) {//采购付款

    }
    if ([self.mainModel.url isEqualToString:@"ProcurementApprove"]) {//辅料报销
       
    }
    if ([self.mainModel.url isEqualToString:@"ProjectProcess"]) {//项目进度
       
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
        if (cellClickRequestSuccessed) {
            self.mutliSelectView.projectContractButton.selected = [model.HaveAgreement boolValue];
            self.mutliSelectView.deviceListButton.selected = [model.HaveDeepenDesign boolValue];
            self.mutliSelectView.ProjectDrawingButton.selected = [model.HaveProgram boolValue];

            self.mutliSelectView.projectContractButton.userInteractionEnabled = NO;
            self.mutliSelectView.deviceListButton.userInteractionEnabled = NO;
            self.mutliSelectView.ProjectDrawingButton.userInteractionEnabled = NO;
        }
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
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppFTDesignApproval"];
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
        if ([[responder objectForKey:@"success"] boolValue]) {
            [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
            [self performSelectorOnMainThread:@selector(requestFileTransferDesignListData_JJQR) withObject:nil waitUntilDone:YES];
            [self.mutliSelectView removeFromSuperview];
        }else{
            [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
            [self.mutliSelectView removeFromSuperview];
        }
        [self hideProgressHUD];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self hideProgressHUD];
        [self.mutliSelectView removeFromSuperview];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
       _tableView.estimatedRowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
