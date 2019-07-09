//
//  SJYRKPSViewController.m
//  PRM
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYRKPSViewController.h"
#import "RKPSListCell.h"
#import "RKPSDetialViewController.h"
#import "RKPSApproveAlertView.h"

#define  STATEArray  @[@"全部",@"待通过",@"已通过"]
#define  ListRKPSStateArray  @[@"",@"未审核",@"已驳回",@"已通过",@"弃权"]
 //待审核  ，已通过， 已驳回 ， 弃权
@interface SJYRKPSViewController ()
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;
@property(nonatomic,assign)NSInteger shStateType;
@property(nonatomic,strong)QMUIButton *searchBtn;
@property(nonatomic,strong)QMUIButton *selectBtn;
@property(nonatomic,strong)QMUIButton *mutableSelectBtn;
@property(nonatomic,strong)UIView *headSelectView;

@property(nonatomic,strong)RKPSApproveAlertView *approvelAlertView;

@property(nonatomic,assign)BOOL canEdit;
@property(nonatomic,assign)NSInteger originalType;

@end

@implementation SJYRKPSViewController

-(void)setUpNavigationBar{
    self.navBar.titleLabel.text = self.title;
    self.shStateType = 0;
    self.canEdit = NO;
    [self createSaveselectBtn];
}
-(void)createSaveselectBtn{
    //FIXME: 查询/取消按钮
    CGFloat searchWidth =  45 ;
    Weak_Self;
    QMUIButton *rejectBt = [[QMUIButton  alloc]init];
    [rejectBt setTitle:@"查询" forState:UIControlStateNormal];
    [rejectBt setTitleColor:Color_White forState:UIControlStateNormal];
    rejectBt.titleLabel.font = Font_System(16);
    [self.navBar addSubview:rejectBt];
    self.searchBtn = rejectBt;
    [self.searchBtn clickWithBlock:^{
        if ([weakSelf.searchBtn.currentTitle isEqualToString:@"查询"]) {
            [weakSelf alertSearch];
        }else{
            [weakSelf.searchBtn setTitle:@"查询" forState:UIControlStateNormal];
            [weakSelf.selectBtn setTitle:@"多选" forState:UIControlStateNormal];
             weakSelf.canEdit = NO;
            [weakSelf.headSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
//            [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                RKPSListModelFrame *frameModel  = obj;
//                frameModel.model.isSelect = NO;
//                 frameModel.model.canEdit = TabCanEditDefault;
//            }];
//            [weakSelf.tableView reloadData];
            weakSelf.shStateType = weakSelf.originalType;
            [weakSelf refreshRKPSListView];
        }
    }];
    //FIXME: 多选/审核按钮
     QMUIButton *agreeBt = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [agreeBt setTitle:@"多选" forState:UIControlStateNormal];
     [agreeBt setTitleColor:Color_White forState:UIControlStateNormal];
    agreeBt.titleLabel.font = Font_System(16);
    [self.navBar addSubview:agreeBt];
    self.selectBtn = agreeBt;

    [self.selectBtn clickWithBlock:^{
        NSLog(@"%@",weakSelf.selectBtn.currentTitle);
        if([weakSelf.selectBtn.currentTitle isEqualToString:@"多选"]){
            [weakSelf.searchBtn setTitle:@"取消" forState:UIControlStateNormal];
            [weakSelf.selectBtn setTitle:@"审核" forState:UIControlStateNormal];
            weakSelf.originalType = weakSelf.shStateType;
             weakSelf.shStateType = 0;
            weakSelf.mutableSelectBtn.selected = NO;
            [weakSelf refreshRKPSListView];
             weakSelf.canEdit = YES;
            [weakSelf.headSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
            }];
        }else if ([weakSelf.selectBtn.currentTitle isEqualToString:@"审核"]){
            NSMutableArray *appvoelArr = [NSMutableArray new];
            [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RKPSListModelFrame *frameModel  = obj;
                if(frameModel.model.isSelect){
                    [appvoelArr addObject:frameModel.model.Id];
                }
            }];
            NSString *idStr = @"";
            if (appvoelArr.count) {
                idStr = [appvoelArr componentsJoinedByString:@","];
            }
            if (idStr.length) {
                [weakSelf alertSHViewWithIdStr:idStr];
            }else{
                [QMUITips showWithText:@"请选择要审核的数据" inView:kWindow hideAfterDelay:1.3];
            }
        }else{

        }
      }];

    [self.searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.navBar.mas_right).offset(-10);
        make.height.equalTo(44);
        make.width.equalTo(searchWidth);
    }];
    [self.selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.searchBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(searchWidth);
    }];
    [self.navBar.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.right.mas_equalTo(self.navBar.rightButton.mas_left).offset(-SJYNUM(56));
        make.right.mas_equalTo(self.navBar).offset(- (searchWidth + searchWidth + 15));
    }];
}

-(void)alertSearch{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.footerSeparatorColor = UIColorClear;
    dialogViewController.headerSeparatorColor = UIColorClear;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
    dialogViewController.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    dialogViewController.rowHeight  = 55;
//    dialogViewController.contentViewMargins  = UIEdgeInsetsMake(0, 20, 0, 20);
    dialogViewController.headerViewHeight  = 10;
    dialogViewController.footerViewHeight  = 40;
    dialogViewController.allowsMultipleSelection = NO;// 打开多选
    dialogViewController.items = STATEArray;
    dialogViewController.selectedItemIndex = self.shStateType +1;


    dialogViewController.didSelectItemBlock = ^(__kindof QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        aDialogViewController.selectedItemIndex = itemIndex;
        self.shStateType = aDialogViewController.selectedItemIndex -1;
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
         [self.tableView.mj_header beginRefreshing];
    };

    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil]; 
    }];
    dialogViewController.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    dialogViewController.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);

    modalViewController.contentViewController = dialogViewController;
    [modalViewController showInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

-(void)alertSHViewWithIdStr:(NSString *)idStr{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init]; 
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.footerSeparatorColor = UIColorClear;
    dialogViewController.headerSeparatorColor = UIColorClear;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
    dialogViewController.headerViewHeight  = 10;
    dialogViewController.footerViewHeight  = 40;

    self.approvelAlertView = [[RKPSApproveAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W - 15*2, 250)];
    self.approvelAlertView.backgroundColor = UIColorWhite;

    dialogViewController.contentView = self.approvelAlertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        NSString *content =  [self.approvelAlertView.bzTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ((self.approvelAlertView.state == RKPSApproveState_FD  ||  self.approvelAlertView.state == RKPSApproveState_QQ ) && content.length == 0) {
            //     if ((self.approvelAlertView.state == 2  ||  self.approvelAlertView.state == 4 ) && content.length == 0) {
            NSString *mention = [[@"请输入"  stringByAppendingString:self.approvelAlertView.bzMenLab.text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]];
            [QMUITips showWithText:mention inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            [self.approvelAlertView.bzTV becomeFirstResponder];
            return ;
        }
        [self.approvelAlertView.bzTV endEditing:YES];
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestRKPSApprovelSubmitWithParaDic: @{
//                                                                @"Id":self.modelFrame.model.Id,
                                                                @"stIds":idStr,
                                                                 @"State":@(self.approvelAlertView.state),
                                                                @"Remark":content
                                                                } success:^(id responder) {
                                                                    [QMUITips hideAllTips];
                                                                    if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];

                                                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshRKPSListView" object:nil];
                                                                    }else{
                                                                        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                    }
                                                                } failure:^(int status, NSString *info) {
                                                                    [QMUITips hideAllTips];
                                                                    [QMUITips showError:info inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                }];

    }];
    modalViewController.contentViewController = dialogViewController;
    [modalViewController showInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

-(void)setupTableView{
    [self.view addSubview:self.headSelectView];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;

    [self.headSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headSelectView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
     }];

}
#pragma mark ======================= 数据绑定
-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf  requestData_RKPS];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf  requestData_RKPS];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRKPSListView) name:@"refreshRKPSListView" object:nil];
}
-(void)refreshRKPSListView{
    [self.tableView.mj_header beginRefreshing];
}
-(void)requestData_RKPS{
    [SJYRequestTool requestRKPSListWithSearchStateID:self.shStateType page:self.page success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
         if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        } 
        for (NSDictionary *dic in rowsArr) {
            RKPSListModel *model = [RKPSListModel  modelWithDictionary:dic];

            model.titleName = model.Model.length?[model.Name stringByAppendingFormat:@"(%@)",model.Model]:model.Name;
            model.titleNameDetial = [model.Name stringByAppendingFormat:@"(%@)",model.EmployeeName];

            model.WeightStr = model.Weight.floatValue == 0?@"": [[NSString numberMoneyFormattor:model.Weight] stringByAppendingString:model.WeightUnit];

            model.PriceListStr =  [[NSString numberMoneyFormattor:model.Guidance]   stringByAppendingFormat:@"(元/%@)",model.Unit];

            model.PriceStr =  model.Guidance.floatValue == 0?@"":[[NSString numberMoneyFormattor:model.Guidance]   stringByAppendingFormat:@"(元/%@)",model.Unit];

            NSString *stockStr = model.StockTypeName.length == 0?@"":model.StockTypeName;
             model.stockChildNameStr = model.ChildTypeName.length == 0? stockStr:[stockStr stringByAppendingFormat:@"(%@)",model.ChildTypeName];

            model.stateString = model.State < [ListRKPSStateArray count] ?[ListRKPSStateArray objectAtIndex:model.State] : ListRKPSStateArray.lastObject;

            BOOL ishav = [StateCodeStringArray containsObject:model.stateString];
            StateCode idx = ishav ? [StateCodeStringArray indexOfObject:model.stateString]:0;
            model.stateColor = [StateCodeColorHexArray objectAtIndex:idx];

            model.isSelect  = NO;
            model.canEdit  = self.canEdit ? TabCanEditDeselect : TabCanEditDefault;

            RKPSListModelFrame *frame = [[RKPSListModelFrame alloc]init];
            frame.model = model;

            [self.dataArray addObject:frame];
        }
        if (self.canEdit) {
            if (self.tableView.mj_footer.isRefreshing && self.totalNum == self.dataArray.count) {
                self.mutableSelectBtn.selected = YES;
            }else{
                self.mutableSelectBtn.selected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self endRefreshWithError:NO];
        });
    } failure:^(int status, NSString *info) {
        [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.canEdit) {
                self.mutableSelectBtn.selected = NO;
            }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     RKPSListCell *cell = [RKPSListCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.data = self.dataArray[indexPath.row];
     [cell loadContent];
    return cell;
}
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RKPSListModelFrame *frameModel   = self.dataArray[indexPath.row];
    RKPSListModel *model = frameModel.model;
    if (self.canEdit) {
        model.isSelect = !model.isSelect;
        model.canEdit = model.isSelect ? TabCanEditSelect : TabCanEditDeselect;
        RKPSListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell loadContent];
       __block NSInteger  selectCount = 0;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RKPSListModelFrame *frameModel  = obj;
            if (frameModel.model.isSelect) {
                selectCount ++;
              }
        }];
        if (selectCount == self.dataArray.count) {
            self.mutableSelectBtn.selected = YES;
        }else{
            self.mutableSelectBtn.selected = NO;
        }
      }else{
         RKPSDetialViewController*sjshSupVC = [[RKPSDetialViewController alloc]init];
        sjshSupVC.modelFrame = frameModel;
        sjshSupVC.title = @"物料详情";
        [self.navigationController pushViewController:sjshSupVC animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshRKPSListView" object:nil];
}


-(UIView *)headSelectView{
    if (!_headSelectView) {
        UIView * headView  = UIView.new;
         QMUILabel *titlab = [[QMUILabel alloc]init];
        titlab.numberOfLines = 0;
        titlab.textColor = Color_TEXT_NOMARL;
        titlab.font = Font_ListTitle;

        titlab.text = @"请选择需要审核的数据";
        [headView addSubview:titlab];
        [headView addSubview:self.mutableSelectBtn];

        [titlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(headView);
            make.left.mas_equalTo( headView).mas_offset(15);
         }];

        [self.mutableSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headView);
            make.right.mas_equalTo(headView).mas_offset(-10);
            make.width.height.mas_equalTo(20);
            make.left.mas_equalTo(titlab.mas_right).mas_offset(5);
        }];
        _headSelectView = headView;
    }
    return _headSelectView;
}
-(QMUIButton *)mutableSelectBtn{
    if (!_mutableSelectBtn) {
        QMUIButton *allSelectBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [allSelectBtn setImage:SJYCommonImage(@"CellButton") forState:UIControlStateNormal];
        [allSelectBtn setImage:SJYCommonImage(@"CellButtonSelected") forState:UIControlStateSelected];
        Weak_Self;
        [allSelectBtn clickWithBlock:^{
            allSelectBtn.selected = !allSelectBtn.selected;
            [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RKPSListModelFrame *frameModel  = obj;
                frameModel.model.isSelect = allSelectBtn.selected;
                frameModel.model.canEdit =  allSelectBtn.selected ? TabCanEditSelect: TabCanEditDeselect;
            }];
            [weakSelf.tableView reloadData];
        }];
        _mutableSelectBtn = allSelectBtn;
     }
    return _mutableSelectBtn;
}
@end
