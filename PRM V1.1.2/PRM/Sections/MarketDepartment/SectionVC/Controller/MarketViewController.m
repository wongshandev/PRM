//
//  EngineerController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MarketViewController.h"
//项目分配
#import "ProjectApprovalHeaderView.h"
#import "ProjectApprovalCell.h"
#import "ProjectApprovelModel.h"
#import "CellSelectView.h"
#import "PopSelectTypeTableView.h"
#import "MultiSelectView.h"

#import "DistributionPerson.h"



//交接确认
#import "FileTransferHeaderView.h"
#import "FileTransferCell.h"
#import "FileTransferModel.h"
#import "ProjectHandoverCellAlertView.h"
#import "TransferCellClickModel.h"

@interface MarketViewController ()<
UIPopoverPresentationControllerDelegate,
UITableViewDelegate,
UITableViewDataSource>{
    PopSelectTypeTableView *tableVC;
    
    dispatch_queue_t  queue;
    BOOL _isMainDesignClicked;
    
    NSString * _ProjectBranchID;
    NSString * _InquiryID;
    NSString * _DesignID;
    NSString *_AidIds;
    NSString * _EngineeringID;
    
    BOOL cellClickRequestSuccessed;
    
    BOOL HaveAgreement;
    BOOL HaveDeepenDesign;
    BOOL HaveProgram;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;


@property (assign, nonatomic) NSInteger page; //!< 数据页数.表示下次请求第几页的数据.

@property(nonatomic,strong)CellSelectView *cellAlertView;
@property(nonatomic,strong)ProjectHandoverCellAlertView *mutliSelectView;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *mainLeaderArray;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *PMArray;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *designerArray;
@property(nonatomic,strong)NSMutableArray<DistributionPerson *> *assistArray;



//@property(nonatomic,strong)NSMutableArray *selectCheckBoxArray;




@end
@implementation MarketViewController
-(NSMutableArray<DistributionPerson *> *)mainLeaderArray{
    if (!_mainLeaderArray) {
        self.mainLeaderArray = [NSMutableArray new];
    }
    return _mainLeaderArray;
}
-(NSMutableArray<DistributionPerson *> *)PMArray{
    if (!_PMArray) {
        self.PMArray = [NSMutableArray new];
    }
    return _PMArray;
}
-(NSMutableArray<DistributionPerson *> *)designerArray{
    if (!_designerArray) {
        self.designerArray = [NSMutableArray new];
    }
    return _designerArray;
}
-(NSMutableArray<DistributionPerson *> *)assistArray{
    if (!_assistArray) {
        self.assistArray = [NSMutableArray new];
    }
    return _assistArray;
}
//-(NSMutableArray *)selectCheckBoxArray{
//    if (!_selectCheckBoxArray) {
//        self.selectCheckBoxArray = [NSMutableArray array];
//    }
//    return _selectCheckBoxArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self setNavigationItems];
    [self setCurrentViewTableView];
    
}
#pragma mark ------------------------配置NavigationItems
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
}

-(void)setCurrentViewTableView{
    [self registerDifferentSectionHeadersAndListCells];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)requestData_PMWithURL:(NSString *)urlStr WithDic:(NSDictionary *)paraDic{
    
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:paraDic finish:^(id responder) {
        kMyLog(@"%@%@",paraDic,responder);
        NSArray *array = responder;
        for (NSDictionary *dic in array) {
            DistributionPerson *person = [DistributionPerson new];
            [person setValuesForKeysWithDictionary:dic];
            if ([[paraDic objectForKey:@"DepartmentID"]integerValue]  ==1) {
                [self.mainLeaderArray addObject:person];
            }
            if ([[paraDic objectForKey:@"DepartmentID"]integerValue]  ==2) {
                [self.designerArray addObject:person];
            }
            if ([[paraDic objectForKey:@"DepartmentID"]integerValue]  ==3) {
                [self.PMArray addObject:person];
            }
        }
        
    } conError:^(NSError *error) {
        
    }];
}


#pragma mark ------------------------注册 cell
-(void)registerDifferentSectionHeadersAndListCells{
    // 任务分配
    if ([self.mainModel.url isEqualToString:@"ProjectApproval"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ProjectApprovalHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"ProjectApprovalCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        //        self.tableView.tableHeaderView = [[ProjectApprovalHeaderView alloc]initWithReuseIdentifier:self.mainModel.url];
        //数据请求
        {
            _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.page = 0;
                [self requestAppPBAssignListData_RWFP];
            }];
            _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self endRefresh];
                });
            }];
            NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppEmployeeByDPList"];
            //负责人
            queue= dispatch_queue_create("com.JoinupTech.www", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                [self.tableView.mj_header beginRefreshing];
            });
            dispatch_async(queue, ^{
                NSDictionary *LeaderParaDic = @{@"DepartmentID":@"1"};
                [self requestData_PMWithURL:urlStr WithDic:LeaderParaDic];
            });
            queue= dispatch_queue_create("com.JoinupTech.www", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                //工程经理
                NSDictionary *PMParaDic = @{@"DepartmentID":@"3",@"Dt":@"1"};
                [self requestData_PMWithURL:urlStr WithDic:PMParaDic];
                
            });
            
            queue= dispatch_queue_create("com.JoinupTech.www", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                NSDictionary * desiginParaDic = @{@"DepartmentID":@"2"};
                [self requestData_PMWithURL:urlStr WithDic:desiginParaDic]; //设计人员
            });
        } 
    }
    //项目交接
    if ([self.mainModel.url isEqualToString:@"FileTransfer"]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:self.mainModel.url];
        [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferCell" bundle:nil] forCellReuseIdentifier:self.mainModel.url];
        [self requestProjectApprovalData_XMJJ];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self requestProjectApprovalData_XMJJ];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            //            [self requestProjectApprovalData_XMJJ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endRefresh];
            });
        }];
    }
}

#pragma mark ------------------------请求数据
//任务分配
-(void)requestAppPBAssignListData_RWFP{
    [self.dataArray removeAllObjects];
    [self showProgressHUD];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppPBAssignList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"1",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        [self hideProgressHUD];
        [self endRefresh];
        NSInteger total = [[responder objectForKey:@"total"] integerValue];
        NSInteger totalPages = total;
        NSArray *rows = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rows.firstObject];
        for (NSDictionary *dic in rows) {
            if (dic != (NSDictionary* )[NSNull null]) {
                ProjectApprovelModel *model = [[ProjectApprovelModel alloc] init];
                [model setValuesForKeysWithDictionary:[self changeNullWithDic:[dic mutableCopy]]];
                [self.dataArray addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self hideProgressHUD];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kWarningColor_lightRedColor];
        
    }];
}
//项目交接
-(void)requestProjectApprovalData_XMJJ{
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"FileTransferInquiryList"];
    [self showProgressHUD];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"rows":@"20",@"page":@(self.page++),@"EmployeeID":kEmployeeID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        [self endRefresh];
        NSArray *rows = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rows.firstObject];
        for (NSDictionary *dic in rows) {
            FileTransferModel *model = [[FileTransferModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self hideProgressHUD];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        
        [self hideProgressHUD];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kWarningColor_lightRedColor];
        
    }];
}

//更新视图.


/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


-(void)showInfoMentation{
    if (self.dataArray.count==0) {
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
    return  self.tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.mainModel.url];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    if ([self.mainModel.url isEqualToString:@"ProjectApproval"]) { // 任务分配
        ProjectApprovalCell *cell = [tableView  dequeueReusableCellWithIdentifier:self.mainModel.url forIndexPath:indexPath];
        ProjectApprovelModel *model = [self.dataArray objectAtIndex:indexPath.row];;
        [cell showCellDataWithModel:model];
        return cell;
    }else if ([self.mainModel.url isEqualToString:@"FileTransfer"]) {//项目交接
        FileTransferCell *cell = [tableView  dequeueReusableCellWithIdentifier:self.mainModel.url forIndexPath:indexPath];
        FileTransferModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell showCellDataWithModel:model];
        
        return cell;
    }else{
        NSString * indetify=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indetify];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.mainModel.url isEqualToString:@"ProjectApproval"]) { // 任务分配
        ProjectApprovelModel *model = [self.dataArray objectAtIndex:indexPath.row];
        _ProjectBranchID = model.Id;
        self.cellAlertView = [[[NSBundle mainBundle]loadNibNamed:@"CellSelectView" owner:nil options:nil]firstObject];
        [self.view addSubview:self.cellAlertView];
        
        [self.cellAlertView.teamLeaderButton setTitle:model.InquiryName forState:UIControlStateNormal];
        self.cellAlertView.teamLeaderButton.tag = 1000+indexPath.row;
        _InquiryID = model.InquiryID;
        
        [self.cellAlertView.ProjectManagerButton setTitle:model.EngineeringName forState:UIControlStateNormal];
        self.cellAlertView.ProjectManagerButton.tag = 2000+indexPath.row;
        _EngineeringID = model.EngineeringID;
        
        [self.cellAlertView.mainDesignButton setTitle:model.DesignName forState:UIControlStateNormal];
        self.cellAlertView.mainDesignButton.tag = 3000+indexPath.row;
        _DesignID = model.DesignID;
        
        NSMutableString *titleStr = [NSMutableString stringWithFormat:@"%@",model.AidIds];
        for (DistributionPerson *person in self.designerArray) {
            NSString *idStr =[NSString stringWithFormat:@"%ld", (long)person.Id ];
            NSString *nameStr =[NSString stringWithFormat:@"%@", person.Name ];
            if ([titleStr containsString:idStr]) {
                titleStr = [[titleStr stringByReplacingOccurrencesOfString:idStr withString:nameStr] mutableCopy];
            }
        }

        [self.cellAlertView.assistDesignButton setTitle:titleStr forState:UIControlStateNormal];
        self.cellAlertView.assistDesignButton.tag = 4000+indexPath.row;
        _AidIds = model.AidIds;
        [self.cellAlertView.teamLeaderButton  addTarget:self action:@selector(showTeamLeaderViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellAlertView.ProjectManagerButton addTarget:self action:@selector(selectProjectManagerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellAlertView.mainDesignButton addTarget:self action:@selector(selectMainDesignAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellAlertView.assistDesignButton addTarget:self action:@selector(selectAssistDesignAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellAlertView.cancelButton addTarget:self action:@selector(removeTheCellAlertViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellAlertView.submitButton addTarget:self action:@selector(submitCellChangesAction:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.5 animations:^{
       
        } completion:^(BOOL finished) {
            self.cellAlertView.frame = [UIScreen mainScreen].bounds;
        }];
    }
    
    if ([self.mainModel.url isEqualToString:@"FileTransfer"]) { // 项目交接
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
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppFTInquiryApproval"];
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
            [self performSelectorOnMainThread:@selector(refreshListView) withObject:nil waitUntilDone:YES];
            [self.mutliSelectView removeFromSuperview];
        }else{
            [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
            [self.mutliSelectView removeFromSuperview];
        }
        [self hideProgressHUD];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self endRefresh];
        [self hideProgressHUD];
        [self.mutliSelectView removeFromSuperview];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}




#pragma mark *********************cellAlertView 按钮事件
- (void)showTeamLeaderViewAction:(UIButton *)sender {
    //注意弹出的不是popover，而是内容，他的内容会呈现在popover中
    NSMutableArray *dataArr = [NSMutableArray new];
    for (DistributionPerson *person in self.mainLeaderArray) {
        [dataArr addObject:[NSString stringWithFormat:@"%@", person.Name]];
    }
    [self  setAlerSelectViewWithDataSource:dataArr
                                SourceView:sender
                                 SoureRect: sender.bounds
                                  ViewSize:CGSizeMake(sender.frame.size.width , dataArr.count*30)];
    tableVC.selectAloneCellBlock = ^(NSString *stateString){
        [sender setTitle:stateString forState:UIControlStateNormal];
    };
}
- (void)selectProjectManagerAction:(UIButton *)sender {
    //注意弹出的不是popover，而是内容，他的内容会呈现在popover中
    NSMutableArray *dataArr = [NSMutableArray new];
    for (DistributionPerson *person in self.PMArray) {
        [dataArr addObject:[NSString stringWithFormat:@"%@", person.Name]];
    }
    [self  setAlerSelectViewWithDataSource:dataArr
                                SourceView:sender
                                 SoureRect: sender.bounds
                                  ViewSize:CGSizeMake(sender.frame.size.width , dataArr.count*30)];
    tableVC.selectAloneCellBlock = ^(NSString *stateString){
        [sender setTitle:stateString forState:UIControlStateNormal];
    };
}
- (void)selectMainDesignAction:(UIButton *)sender {
    _isMainDesignClicked = YES;
    //注意弹出的不是popover，而是内容，他的内容会呈现在popover中
    NSMutableArray *dataArr = [NSMutableArray new];
    for (DistributionPerson *person in self.designerArray) {
        [dataArr addObject:[NSString stringWithFormat:@"%@", person.Name]];
    }

    [self  setAlerSelectViewWithDataSource:dataArr
                                SourceView:sender
                                 SoureRect: sender.bounds
                                  ViewSize:CGSizeMake(sender.frame.size.width , dataArr.count*30)];

    __weak typeof(self) weakSelf = self;
    tableVC.selectAloneCellBlock = ^(NSString *stateString){
        [sender setTitle:stateString forState:UIControlStateNormal];
        NSMutableArray *array = [NSMutableArray new];
        if (weakSelf.cellAlertView.assistDesignButton.currentTitle.length!= 0) {
            [array addObjectsFromArray:[weakSelf.cellAlertView.assistDesignButton.currentTitle componentsSeparatedByString:@","]];
            if ([array containsObject:stateString]) {
                [array removeObject:stateString];
            }
            NSString *assidStr = [array componentsJoinedByString:@","];
            [weakSelf.cellAlertView.assistDesignButton setTitle:assidStr forState:UIControlStateNormal];
        }
    };
}
- (void)selectAssistDesignAction:(UIButton *)sender {
    if (self.cellAlertView.mainDesignButton.titleLabel.text.length!=0) {
        NSMutableArray *dataArr = [NSMutableArray new];
        for (DistributionPerson *person in self.designerArray) {
            if (![self.cellAlertView.mainDesignButton.currentTitle isEqual:person.Name] ) {
                [self.assistArray addObject:person];
                [dataArr addObject:[NSString stringWithFormat:@"%@", person.Name]];
            }
        }

        MultiSelectView *multiSelectVC = [[MultiSelectView alloc] init];
        multiSelectVC.dataArray = dataArr;
        multiSelectVC.selectedNameString = sender.currentTitle;
        multiSelectVC.title = @"辅助设计人员列表";
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:multiSelectVC];
        multiSelectVC.mulitSelectBlock = ^(NSString *nameString){
            [sender setTitle:nameString forState:UIControlStateNormal];
        };
        [self presentViewController:navVC animated:YES completion:^{
        }];
    }else{
        [self showMessageLabel:@"请优先选择主设计人" withBackColor:kGeneralColor_lightCyanColor];
    }
    
}



- (void)submitCellChangesAction:(UIButton *)sender {
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    UIButton *leadButton = [self.cellAlertView viewWithTag:1000 + index.row];
    UIButton *pmButton = [self.cellAlertView viewWithTag:2000 + index.row];
    UIButton *designButton = [self.cellAlertView viewWithTag:3000 + index.row];
    UIButton *assistButton = [self.cellAlertView viewWithTag:4000 + index.row];
  
    NSMutableString *leadIdsString= [NSMutableString stringWithFormat:@"%@",leadButton.currentTitle];
    for (DistributionPerson *person in self.mainLeaderArray) {
        if ([leadIdsString isEqualToString:[NSString stringWithFormat:@"%@",person.Name ]]) {
          leadIdsString=  [[leadIdsString stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@", person.Name] withString: [NSString stringWithFormat:@"%ld", (long)person.Id]]mutableCopy];
        }
    }
    _InquiryID = leadIdsString;
    if (_InquiryID.length == 0) {
        [self showMessageLabel:@"负责人不能为空" withBackColor:kWarningColor_lightRedColor];
        return;
    }
    
    NSMutableString *PMIdStr =[NSMutableString stringWithFormat:@"%@",pmButton.currentTitle];
    for (DistributionPerson *person in self.PMArray) {
        if ([PMIdStr isEqualToString:[NSString stringWithFormat:@"%@",person.Name ]]) {
           PMIdStr= [[PMIdStr stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@", person.Name] withString: [NSString stringWithFormat:@"%ld", (long)person.Id]]mutableCopy];
        }
    }
    _EngineeringID = PMIdStr;
    if (_EngineeringID.length == 0) {
        [self showMessageLabel:@"工程经理不能为空" withBackColor:kWarningColor_lightRedColor];
        return;
    }


    NSMutableString *aidIdsString= [NSMutableString stringWithFormat:@"%@",assistButton.currentTitle];
    NSMutableString *designIdStr =[NSMutableString stringWithFormat:@"%@",designButton.currentTitle];
    for (DistributionPerson *person in self.designerArray) {
        if ([designIdStr isEqualToString:[NSString stringWithFormat:@"%@",person.Name ]]) {
            designIdStr =[[designIdStr stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@", person.Name] withString: [NSString stringWithFormat:@"%ld", (long)person.Id]]mutableCopy];
        }
        if ([aidIdsString containsString:[NSString stringWithFormat:@"%@", person.Name]]) {
           aidIdsString = [[aidIdsString stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@", person.Name] withString: [NSString stringWithFormat:@"%ld", (long)person.Id]]mutableCopy];
        }
    }
    _DesignID = designIdStr;
    _AidIds = aidIdsString;
    
    NSDictionary *paraDic = @{
                              @"ProjectBranchID":_ProjectBranchID,
                              @"InquiryID":_InquiryID,
                              @"DesignID":_DesignID,
                              @"AidIds":_AidIds,
                              @"EngineeringID":_EngineeringID,
                              @"EmployeeID":kEmployeeID
                              };
    
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppProjectApprove"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:paraDic finish:^(id responder) {
        kMyLog(@"%@",responder);
        if ([[responder objectForKey:@"success"]boolValue]) {
            [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
            [self performSelectorOnMainThread:@selector(refreshListView) withObject:nil waitUntilDone:YES];
            [self removeTheCellAlertViewAction:nil];
        }else{
         [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
        }
    } conError:^(NSError *error) {
        
    }];

}
-(void)refreshListView{
    [self.tableView.mj_header beginRefreshing];
}
- (void)removeTheCellAlertViewAction:(UIButton *)sender {
    [self.cellAlertView removeFromSuperview];
    _isMainDesignClicked = NO;

}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ************************气泡选择器 弹出及代理事件
-(void)setAlerSelectViewWithDataSource:(NSMutableArray *)dataArray SourceView:(UIButton *)sender SoureRect:(CGRect)sourceRect  ViewSize:(CGSize )viewSize {
    tableVC = [[PopSelectTypeTableView alloc] init];
    tableVC.dataSource = dataArray;
    //    __weak typeof(self) weakSelf= self ;
//    tableVC.selectAloneCellBlock = ^(NSString *stateString){
//        [sender setTitle:stateString forState:UIControlStateNormal];
//    };
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
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //设置箭头的颜色
    popover.backgroundColor = [UIColor whiteColor];
    //设置代理
    popover.delegate = self;
    [self presentViewController:tableVC animated:YES completion:nil];
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

@end
