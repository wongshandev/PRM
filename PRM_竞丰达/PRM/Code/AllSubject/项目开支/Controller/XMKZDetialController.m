//
//  XMKZDetialController.m
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMKZDetialController.h"
#import "XMKZLabTFCell.h"
#import "QDMultipleImagePickerPreviewViewController.h"
#import "KZSHApprovelAlertView.h"

#define  CellHigh  50

#define  PickHigh   isHighterThanIPhone5 ? 80 : 70

#define ImagePickerPadding 20.0f
#define LeftPadding 20.0f
@interface XMKZDetialController ()<
QMUITableViewDelegate,
QMUITableViewDataSource,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
PYPhotosViewDelegate,
QMUIAlbumViewControllerDelegate,
QMUIImagePickerViewControllerDelegate,
QDMultipleImagePickerPreviewViewControllerDelegate,
QMUITextFieldDelegate,QMUITextViewDelegate>{
    dispatch_group_t _group;
    dispatch_queue_t queue;
}
@property (nonatomic, strong) KZSHApprovelAlertView *approvelAlertView;
@property (nonatomic, strong)UIImagePickerController *photoPicker;

@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) PYPhotosView *imagesPicker;
@property(strong ,nonatomic)NSMutableArray *fjImgArray;
@property(strong ,nonatomic)NSMutableArray *fjImgURLArray;
@property(strong ,nonatomic)NSMutableArray *spendTypeArray;

@property(nonatomic,strong)QMUIButton *deleteBtn;
@property(nonatomic,strong)QMUIButton *submitBtn;
@property(nonatomic,strong)QMUIButton *saveBtn;
@property(nonatomic,strong)QMUIButton *approvelBtn;
@property(nonatomic,strong)QMUIButton *approvelPayBtn;
@property(nonatomic,strong)NSMutableDictionary *viewDataDic;
@property(nonatomic,assign) CGFloat  footViewHigh;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)QMUITextView *bzTV;

@end

@implementation XMKZDetialController
-(UIImagePickerController *)photoPicker{
    if (!_photoPicker) {
        _photoPicker = [[UIImagePickerController alloc] init];
        _photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _photoPicker.delegate = self;
    }
    return _photoPicker;
}

//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if (self.footView) {
//        CGFloat high = [self.footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        if (high!= self.footView.frame.size.height) {
//       self.footView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame), CGRectGetMinY(self.tableView.tableFooterView.frame), CGRectGetWidth(self.tableView.tableFooterView.frame), self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100);
//            self.tableView.tableFooterView = self.footView;
//        }}
//}
-(NSMutableArray *)spendTypeArray{
    if (!_spendTypeArray) {
        _spendTypeArray = [NSMutableArray arrayWithArray:[SJYDefaultManager shareManager].getXMKZSpendTypeArray];
        [_spendTypeArray sortUsingComparator:^NSComparisonResult(XMKZSpendTypeModel *  _Nonnull obj1, XMKZSpendTypeModel *  _Nonnull obj2) {
            return  [obj1.Id compare: obj2.Id] == NSOrderedDescending;
        }];
    }
    return _spendTypeArray;
}
-(NSMutableArray *)fjImgArray{
    if (!_fjImgArray) {
        _fjImgArray = [NSMutableArray new];
    }
    return _fjImgArray;
}
-(NSMutableArray *)fjImgURLArray{
    if (!_fjImgURLArray) {
        _fjImgURLArray = [NSMutableArray new];
    }
    return _fjImgURLArray;
}
-(void)setUpNavigationBar{
    self.navBar.titleLabel.text = self.title;
    Weak_Self;
    [self.navBar.backButton clickWithBlock:^{
        [weakSelf.bzTV endEditing:YES];
        [weakSelf.tableView endEditing:YES];
        if (![weakSelf.detialModel.OccurDateChange isEqualToString:weakSelf.detialModel.OccurDate]
            || ![weakSelf.detialModel.SpendingTypeIDChange isEqualToString:weakSelf.detialModel.SpendingTypeID]
            ||  weakSelf.detialModel.AmountChange.floatValue != weakSelf.detialModel.Amount.floatValue
            || ![weakSelf.detialModel.RemarkChange isEqualToString:weakSelf.detialModel.Remark]) {
            [weakSelf alertWithSaveMention:@"信息已修改 , 需要保存吗?" withAction:@selector(request_SaveFunction)];
            return ;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    [self createSaveagreeBtn];
}

-(void)bindViewModel{
    //    int ProjectBranchID
    //    int SpendingID(开支Id，新增:0,修改:开支列表Id)
    //    int EmployeeID(操作人Id)
    //    int: SpendingTypeID(开支类型)
    //    string OccurDate(开支时间)
    //    string Remark(备注 maxlength:1024)
    //decimal:Amount
    //    Request.Files(开支凭证，限制图片类型上传，可以为空)
    self.viewDataDic = [NSMutableDictionary dictionary];
    if (self.detialModel.modelType == ModelType_XMKZ) {
        [self.viewDataDic setObject:self.listModel.Id forKey:@"ProjectBranchID"];
    }
    [self.viewDataDic setObject:self.detialModel.Id forKey:@"SpendingID"];
    [self.viewDataDic setObject:KEmployID forKey:@"EmployeeID"];
    [self.viewDataDic setObject:self.detialModel.SpendingTypeIDChange forKey:@"SpendingTypeID"];
    [self.viewDataDic setObject:self.detialModel.OccurDateChange forKey:@"OccurDate"];
    [self.viewDataDic setObject:self.detialModel.RemarkChange forKey:@"Remark"];
    [self.viewDataDic setObject:self.detialModel.AmountChange forKey:@"Amount"];

#pragma mark ----------------------- 静态数据源
    Weak_Self;
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[@[({
        QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
        cellData.accessoryType = self.saveBtn.hidden?QMUIStaticTableViewCellAccessoryTypeNone: QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        cellData.style = UITableViewCellStyleValue1;
        cellData.height = CellHigh;
        cellData.identifier = 0;
        cellData.text = @"消费时间";
        cellData.detailText =  self.detialModel.OccurDateChange;
        cellData.didSelectTarget = self;
        cellData.didSelectAction = @selector(selectCellAction:);
        cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
            cell.textLabel.font = Font_ListTitle;
            cell.textLabel.textColor = Color_TEXT_HIGH;
            cell.detailTextLabel.font = Font_ListTitle;
            cell.detailTextLabel.textColor = Color_TEXT_NOMARL;
        };
        cellData; }) ,({
            QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
            cellData.accessoryType = self.saveBtn.hidden?QMUIStaticTableViewCellAccessoryTypeNone: QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
            cellData.style = UITableViewCellStyleValue1;
            cellData.height = CellHigh;
            cellData.identifier = 1;
            cellData.text = @"报销类型";
            cellData.detailText =  self.detialModel.SpndingTypeNameChange ;
            cellData.didSelectTarget = self;
            cellData.didSelectAction = @selector(selectCellAction:);
            cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
                cell.textLabel.font = Font_ListTitle;
                cell.detailTextLabel.font = Font_ListTitle;
                cell.textLabel.textColor = Color_TEXT_HIGH;
                cell.detailTextLabel.textColor = Color_TEXT_NOMARL;
            };
            cellData; }), ({
                QMUIStaticTableViewCellData *cellData = [[QMUIStaticTableViewCellData alloc] init];
                cellData.style = UITableViewCellStyleValue1;
                cellData.cellClass = [XMKZLabTFCell class];
                cellData.height = CellHigh;
                cellData.identifier = 2;
                cellData.text = @"报销金额(元)";
                cellData.detailText =  [NSString numberMoneyFormattor:self.detialModel.Amount];
                cellData.didSelectTarget = self;
                cellData.didSelectAction = @selector(selectCellAction:);
                cellData.cellForRowBlock = ^(UITableView *tableView, __kindof QMUITableViewCell *cell, QMUIStaticTableViewCellData *cellData) {
                    XMKZLabTFCell *TFCell = (XMKZLabTFCell *)cell;
                    //    TFCell.detailTextLabel.text = @"";
                    TFCell.textField.text = cellData.detailText;
                    TFCell.textField.delegate = weakSelf;
                    TFCell.textField.enabled = !weakSelf.saveBtn.hidden;
                    //   TFCell.textField.placeholder =  weakSelf.saveBtn.hidden?@"":@"请输入";
                };
                cellData; })  ]]];
#pragma mark --------------键盘监听
    if (self.detialModel.modelType == ModelType_XMKZ) {
        //监听键盘出现和消失
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

-(void)createSaveagreeBtn{
    self.footViewHigh =  PickHigh;
    CGFloat saveWidth = (self.detialModel.State == 1 || self.detialModel.State == 3 || self.detialModel.State == 0 ) && self.detialModel.modelType == ModelType_XMKZ ?45: 0;
    CGFloat deleteWidth =(self.detialModel.State == 1 || self.detialModel.State == 3)&& self.detialModel.modelType == ModelType_XMKZ ?45: 0;
    CGFloat submitWidth = (self.detialModel.State == 1) && self.detialModel.modelType == ModelType_XMKZ  ?45: 0;
    CGFloat approvelPayWidth = (self.detialModel.PayID == 0) && self.detialModel.modelType == ModelType_KZFK  ?45: 0;

     CGFloat approvelWidth = ((self.detialModel.State == 2 && (self.detialModel.EmployeeID == 1 || self.detialModel.EmployeeID == self.eld ))
                             ||  (self.detialModel.State == 4 && (self.detialModel.ApprovalID == 0 || self.detialModel.ApprovalID == self.eld ) &&  !(self.eld ==self.detialModel.EmployeeID || self.eld == self.detialModel.ManagerID || self.eld == self.detialModel.BossID))
                             ||  (self.detialModel.State == 5 && (self.detialModel.ManagerID == 0 || self.detialModel.ManagerID == self.eld ) &&  !(self.eld ==self.detialModel.EmployeeID || self.eld == self.detialModel.ApprovalID || self.eld == self.detialModel.BossID))
                             ||  (self.detialModel.State == 6 && (self.detialModel.BossID == 0 || self.detialModel.BossID == self.eld ) &&  !(self.eld ==self.detialModel.EmployeeID || self.eld == self.detialModel.ApprovalID || self.eld == self.detialModel.ManagerID))
                             ) && self.detialModel.modelType == ModelType_KZSH ?45: 0;

    //(row.State == 2 && row.EmployeeID.inArray(1, eId))
    //|| (row.State == 4 && row.ApprovalID.inArray(0, eId) && !eId.inArray([row.EmployeeID, row.ManagerID, row.BossID]))
    //|| (row.State == 5 && row.ManagerID.inArray(0, eId) && !eId.inArray([row.EmployeeID, row.ApprovalID, row.BossID]))
    //|| (row.State == 6 && row.BossID.inArray(0, eId) && !eId.inArray([row.EmployeeID, row.ApprovalID, row.ManagerID]))

 #pragma mark -----------------------项目开支 删除

    Weak_Self;
    QMUIButton *deleteBtn = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:Color_White forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = Font_System(16);
    [self.navBar addSubview:deleteBtn];
    self.deleteBtn.hidden = deleteWidth ==0;
    self.deleteBtn = deleteBtn;
    [self.deleteBtn clickWithBlock:^{
        [weakSelf request_DeleteFunction];
    }];
#pragma mark -----------------------项目开支   提交

    QMUIButton *submitBtn = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:Color_White forState:UIControlStateNormal];
    submitBtn.titleLabel.font = Font_System(16);
    [self.navBar addSubview:submitBtn];
    self.submitBtn = submitBtn;
    self.submitBtn.hidden = submitWidth==0;
    [self.submitBtn clickWithBlock:^{
        [weakSelf request_SubmitFunction];
    }];

#pragma mark -----------------------项目开支  保存

    QMUIButton *saveBtn = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:Color_White forState:UIControlStateNormal];
    saveBtn.titleLabel.font = Font_System(16);
    [self.navBar addSubview:saveBtn];
    self.saveBtn = saveBtn;
    self.saveBtn.hidden = saveWidth == 0;
    [self.saveBtn clickWithBlock:^{
        [weakSelf request_SaveFunction];
    }];

#pragma mark -----------------------开支审核  审核
    
    QMUIButton *approvelBtn = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [approvelBtn setTitle:@"审核" forState:UIControlStateNormal];
    [approvelBtn setTitleColor:Color_White forState:UIControlStateNormal];
    approvelBtn.titleLabel.font = Font_System(16);
    [self.navBar addSubview:approvelBtn];
    self.approvelBtn = approvelBtn;
    self.approvelBtn.hidden = approvelWidth == 0;
    [self.approvelBtn clickWithBlock:^{
        [weakSelf alertApprovelViewFunction];
    }];

#pragma mark -----------------------开支付款  报销
    QMUIButton *approvelPayBtn = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [approvelPayBtn setTitle:@"报销" forState:UIControlStateNormal];
    [approvelPayBtn setTitleColor:Color_White forState:UIControlStateNormal];
    approvelPayBtn.titleLabel.font = Font_System(16);
    [self.navBar addSubview:approvelPayBtn];
    self.approvelPayBtn = approvelPayBtn;
    self.approvelPayBtn.hidden = approvelPayWidth == 0;
    [self.approvelPayBtn clickWithBlock:^{
        [weakSelf request_ApprovelPayAlertFunction];
    }];

    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.navBar.mas_right).offset(-10);
        make.height.equalTo(44);
        make.width.equalTo(deleteWidth);
    }];
    [self.submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.deleteBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(submitWidth);
    }];
    [self.saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.submitBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(saveWidth);
    }];
    [self.approvelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.saveBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(approvelWidth);
    }];
    [self.approvelPayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.approvelBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(approvelPayWidth);
    }];
    [self.navBar.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navBar).offset(- (saveWidth + deleteWidth +submitWidth +approvelWidth +approvelPayWidth));
    }];
}

-(void)buildSubviews{
#pragma mark ----------------------- 创建 TableView
    self.tableView = [[QMUITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).offset(UIEdgeInsetsMake(self.navBar.height, 0, 0, 0 ));
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;

    self.tableView.showNoData = YES;
    self.tableView.customImg = SJYCommonImage(@"empty");
    self.tableView.customMsg = @"没有数据了,休息下吧";
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, CGFLOAT_MIN)];

#pragma mark -----------------------  创建 底部视图

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100)];
    self.footView = footerView;

    QMUILabel *pzLab = [[QMUILabel alloc] init];
    pzLab.text = @"报销凭证";
    pzLab.textColor = Color_TEXT_HIGH;
    pzLab.font = Font_ListTitle;
    [footerView addSubview:pzLab];

    QMUILabel *bzLab = [[QMUILabel alloc] init];
    bzLab.text = @"备注";
    bzLab.textColor = Color_TEXT_HIGH;
    bzLab.font = Font_ListTitle;
    [footerView addSubview:bzLab];
#pragma mark ----------------------- 备注 TextView
    QMUITextView *bzTV = [[QMUITextView alloc] init];
    bzTV.shouldCountingNonASCIICharacterAsTwo = YES;
    bzTV.shouldResponseToProgrammaticallyTextChanges = YES;
    bzTV.delegate = self;
    bzTV.placeholderColor = Color_TEXT_WEAK;
    bzTV.maximumTextLength = 1024;
    bzTV.placeholder = self.saveBtn.hidden?@"":@"请输入(限512字)";
    bzTV.text = self.detialModel.RemarkChange;
    bzTV.textColor = Color_TEXT_HIGH;
    bzTV.font = Font_ListTitle;
    [footerView addSubview:bzTV];
    self.bzTV = bzTV;
    self.bzTV.editable = !self.saveBtn.hidden;
#pragma mark ----------------------- PYPhotosView
    // 1. 常见一个发布图片时的photosView
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    [self configFJImageArray];
    if (isHighterThanIPhone5) {
        publishPhotosView.photoWidth  = 80;
        publishPhotosView.photoHeight = 80;
    }
    publishPhotosView.photosMaxCol = (NSInteger) (SCREEN_W - 2*LeftPadding) / publishPhotosView.photoWidth;
    publishPhotosView.photoMargin =  (SCREEN_W - 2*LeftPadding - publishPhotosView.photoWidth *publishPhotosView.photosMaxCol)/(publishPhotosView.photosMaxCol -1);
    publishPhotosView.oneImageFullFrame =NO;
    publishPhotosView.pageType = PYPhotosViewPageTypeLabel;
    // 3. 设置代理
    publishPhotosView.imagesMaxCountWhenWillCompose =  1;// NSIntegerMax;//
    publishPhotosView.autoLayoutWithWeChatSytle = NO;
    publishPhotosView.delegate = self;
    // 4. 添加photosView
    [footerView addSubview:publishPhotosView];
    self.imagesPicker = publishPhotosView;
#pragma mark ----------------------- 布局子视图
    [pzLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footerView.mas_top).mas_offset(ImagePickerPadding/2);
        make.left.mas_equalTo(footerView.mas_left).mas_offset(LeftPadding);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-LeftPadding);
        make.height.mas_equalTo( ImagePickerPadding );
    }];
    [self.imagesPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pzLab.mas_bottom).mas_offset(ImagePickerPadding/2);
        make.left.mas_equalTo(footerView.mas_left).mas_offset(LeftPadding);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-LeftPadding);
        make.height.mas_greaterThanOrEqualTo(ImagePickerPadding + self.imagesPicker.photoHeight);
    }];

    [bzLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imagesPicker.mas_bottom).mas_offset(ImagePickerPadding/2);
        make.left.mas_equalTo(footerView.mas_left).mas_offset(LeftPadding);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-LeftPadding);
        make.height.mas_equalTo( ImagePickerPadding );
    }];
    [bzTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bzLab.mas_bottom).mas_offset(ImagePickerPadding/2);
        make.left.mas_equalTo(footerView.mas_left).mas_offset(LeftPadding);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-LeftPadding);
        make.height.mas_equalTo( 100);
        make.bottom.mas_equalTo(footerView.mas_bottom).mas_offset(-ImagePickerPadding/2);
    }];
    [bzTV rounded:5 width:1.5 color:Color_LINE_NOMARL];
    self.tableView.tableFooterView = self.footView;
}
-(void)keyboardWillShow:(NSNotification*)note{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0,0, keyBoardRect.size.height,0);
}
-(void)keyboardWillHide:(NSNotification*)note{
    self.tableView.contentInset= UIEdgeInsetsZero;
}

-(void)configFJImageArray{
    [self.fjImgArray removeAllObjects];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _group = dispatch_group_create();
    NSArray *fjArr= [self.detialModel.Url componentsSeparatedByString:@","];
    if (fjArr.count != 0) {
        for (NSString *urlStr in fjArr) {
            NSString *url = @"";
            if([urlStr  hasPrefix:@"../"]){
                url =  [urlStr stringByReplacingOccurrencesOfString:@".." withString:API_ImageUrl];
            }else{
                url = [API_ImageUrl stringByAppendingString:urlStr];
            }
            url =  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self.fjImgURLArray addObject: url];
            dispatch_group_enter(_group);
            dispatch_group_async(_group, queue, ^{ /*任务a */
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderLowPriority  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image!= nil) {
                        [image setAccessibilityIdentifier:[urlStr stringByDeletingLastPathComponent]];
                        [self.fjImgArray addObject:image];
                    }
                    dispatch_group_leave(self->_group);
                }];
            });
        }
    }
    dispatch_group_notify(_group,dispatch_get_main_queue(), ^{
        self.imagesPicker.photosState = self.saveBtn.hidden? PYPhotosViewStateDidCompose:PYPhotosViewStateWillCompose;
        if (self.saveBtn.hidden) { //不可修改新增
            //网络图片
            self.imagesPicker.thumbnailUrls = self.fjImgURLArray;
            self.imagesPicker.height =   [self.imagesPicker sizeWithPhotoCount:self.imagesPicker.thumbnailUrls.count photosState:PYPhotosViewStateDidCompose].height;
            [ self.tableView.tableFooterView layoutSubviews];
            self.footViewHigh = self.imagesPicker.height;
            //            if ( self.footViewHigh< PickHigh) {
            //                self.footViewHigh = PickHigh;
            //            }
            self.footView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame), CGRectGetMinY(self.tableView.tableFooterView.frame), CGRectGetWidth(self.tableView.tableFooterView.frame), self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100);
            self.tableView.tableFooterView = self.footView;

        }else{
            //修改新增
            self.imagesPicker.images = self.fjImgArray;
            [self.imagesPicker reloadDataWithImages:self.imagesPicker.images];
            self.imagesPicker.height =   [self.imagesPicker sizeWithPhotoCount:self.imagesPicker.images.count photosState:PYPhotosViewStateWillCompose].height;//.height;
            [ self.tableView.tableFooterView layoutSubviews];
            self.footViewHigh = self.imagesPicker.height;
            //            if ( self.footViewHigh< PickHigh) {
            //                self.footViewHigh = PickHigh;
            //            }
            self.footView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame), CGRectGetMinY(self.tableView.tableFooterView.frame), CGRectGetWidth(self.tableView.tableFooterView.frame), self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100);
            self.tableView.tableFooterView = self.footView;

        }
    });
}
#pragma mark -----------------------项目开支 ==保存 / 提交 / 删除

-(void)request_SubmitFunction{
    [self.tableView endEditing:YES];
    if (![self.detialModel.OccurDateChange isEqualToString:self.detialModel.OccurDate]
        || ![self.detialModel.SpendingTypeIDChange isEqualToString:self.detialModel.SpendingTypeID]
        || self.detialModel.AmountChange.floatValue != self.detialModel.Amount.floatValue
        || ![self.detialModel.RemarkChange isEqualToString:self.detialModel.Remark]) {
        [QMUITips showWithText:@"数据已更改,请先保存" inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
        return;
    }

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
    label.text = @"确定提交吗?";
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) { 
    [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
    [SJYRequestTool requestXMKZDetialSubmitWithParaDic:@{@"Id":self.detialModel.Id,
                                                         @"State":@(2),
                                                         @"EmployeeID":KEmployID
                                                         } success:^(id responder) {
                                                             [QMUITips hideAllTips];
                                                             if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                 [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                 [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];

                                                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJYXMKZDetiallList" object:nil];
                                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 });
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

-(void)request_SaveFunction{
    //    if (![self.detialModel.OccurDateChange isEqualToString:self.detialModel.OccurDate] ||
    //        ![self.detialModel.SpendingTypeIDChange isEqualToString:self.detialModel.SpendingTypeID] || ![self.detialModel.SpendingTypeIDChange isEqualToString:self.detialModel.SpendingTypeID]) {
    //
    //    }
    [self.bzTV endEditing:YES];
    [self.tableView endEditing:YES];
    if (self.detialModel.OccurDateChange.length == 0 ) {
        [QMUITips showWithText:@"请选择消费时间" inView:self.view hideAfterDelay:1.2];
        return;
    }
    if (self.detialModel.SpendingTypeIDChange.length == 0 ) {
        [QMUITips showWithText:@"请选择报销类型" inView:self.view hideAfterDelay:1.2];
        return;
    }
    if (self.detialModel.AmountChange.length == 0 || self.detialModel.AmountChange.floatValue == 0.00) {
        [QMUITips showWithText:@"请输入报销金额" inView:self.view hideAfterDelay:1.2];
        return;
    }
    //    if (self.detialModel.RemarkChange.length == 0) {
    //        [QMUITips showWithText:@"" inView:self.view hideAfterDelay:1.2];
    //        return;
    //    }
    [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
    [SJYRequestTool requestXMKZDetialSaveWithParaDic:self.viewDataDic imageArray:self.imagesPicker.images fileName:@"" progerss:^(id progress) {
        [QMUITips hideAllTips];
        NSProgress *uploadProgress = progress;
        CGFloat    pro = uploadProgress.fractionCompleted *100;
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips showLoading:[NSString stringWithFormat:@"%.0f%%", pro] inView:[UIApplication sharedApplication].keyWindow];
        });
    } success:^(id responder) {
        [QMUITips hideAllTips];
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJYXMKZDetiallList" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
        }
    } failure:^(int status, NSString *info) {
        [QMUITips hideAllTips];
        [QMUITips showError:info inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
    }];
}
-(void)request_DeleteFunction{
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
    label.text = @"确定删除吗?";
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestXMKZDetialDeleteWithParaDic:@{@"Id":self.detialModel.Id, @"EmployeeID":KEmployID } success:^(id responder) {
            [QMUITips hideAllTips];
            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJYXMKZDetiallList" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
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


#pragma mark -----------------------开支审核
-(void)alertApprovelViewFunction{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.footerSeparatorColor = UIColorClear;
    dialogViewController.headerSeparatorColor = UIColorClear;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
    dialogViewController.headerViewHeight  = 10;
    dialogViewController.footerViewHeight  = 40;

    self.approvelAlertView = [[KZSHApprovelAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W - 15*2, 250)];
    self.approvelAlertView.backgroundColor = UIColorWhite;

    dialogViewController.contentView = self.approvelAlertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        NSString *content =  [self.approvelAlertView.bzTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ((self.approvelAlertView.state == KZSHApproveState_BH  ||  self.approvelAlertView.state == KZSHApproveState_ZF ) && content.length == 0) {
            NSString *mention = [[@"请输入"  stringByAppendingString:self.approvelAlertView.bzMenLab.text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]];
            [QMUITips showWithText:mention inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            [self.approvelAlertView.bzTV becomeFirstResponder];
            return ;
        }
        [self.approvelAlertView.bzTV endEditing:YES];

        NSDictionary *paradic =@{
                                 @"Id":self.detialModel.Id,
                                 @"EmployeeID":KEmployID,
                                 @"AEmp":[[SJYUserManager sharedInstance].ucAemp  modelToJSONString],
                                 @"State":@(self.approvelAlertView.state).stringValue, //State=7(同意) =3(驳回) =-1(作废)
                                 @"RejectReason":content
                                 };
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestXMKZDetialSubmitWithParaDic:paradic
                                                   success:^(id responder) {
                                                       [QMUITips hideAllTips];
                                                       if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                           [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                           [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
                                                           [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJYKZSHListView" object:nil];
                                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           });
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
#pragma mark -----------------------开支支付/付款
-(void)request_ApprovelPayAlertFunction{

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
    label.text = @"确定报销吗?";
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestXMKZDetialSubmitWithParaDic:@{
                                                             @"Id":self.detialModel.Id,
                                                             @"EmployeeID":KEmployID,
                                                             @"State":@(8)
                                                             } success:^(id responder) {
                                                                 [QMUITips hideAllTips];
                                                                 if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                     [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
                                                                     [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                     [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJYKZFKListView" object:nil];
                                                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                     });
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
#pragma mark - <QMUITableViewDataSource,  QMUITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  tableView.qmui_staticCellDataSource.cellDataSections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.qmui_staticCellDataSource.cellDataSections[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView.qmui_staticCellDataSource cellForRowAtIndexPath:indexPath];
    return cell;
}

-(void)selectCellAction:(QMUIStaticTableViewCellData *)cellData{
    if (self.saveBtn.hidden) {
        [self.tableView deselectRowAtIndexPath:cellData.indexPath animated:YES];
        return;
    }
    QMUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellData.indexPath];
    if (cellData.identifier == 0) {
        [cell.parentTableView endEditing:YES];
        [BRDatePickerView showDatePickerWithTitle:cellData.text dateType:BRDatePickerModeYMD defaultSelValue:cellData.detailText minDate:nil maxDate:nil isAutoSelect:NO themeColor:Color_NavigationBlue resultBlock:^(NSString *selectValue) {
            cellData.detailText = selectValue;
            self.detialModel.OccurDateChange = selectValue;
            [self.viewDataDic setObject:selectValue forKey:@"OccurDate"];
            cell.detailTextLabel.text = selectValue;
        }];
    } else if (cellData.identifier == 1) {
        [cell.parentTableView endEditing:YES];
        
        //        NSArray *spendingTypeArray =  [SJYDefaultManager shareManager].getXMKZSpendTypeArray;
        //        NSArray *spendingNameArray = [spendingTypeArray valueForKeyPath:@"@distinctUnionOfObjects.name"];
        //        NSArray *spendingIdArray = [spendingTypeArray valueForKeyPath:@"@distinctUnionOfObjects.Id"];
        NSMutableArray *spendingIdArray = [NSMutableArray new];
        NSMutableArray *spendingNameArray = [NSMutableArray new];
        [self.spendTypeArray enumerateObjectsUsingBlock:^(XMKZSpendTypeModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [spendingIdArray addObject:obj.Id];
            [spendingNameArray addObject:obj.name];
        }];

        [BRStringPickerView showStringPickerWithTitle:cellData.text dataSource:spendingNameArray  defaultSelValue:cellData.detailText isAutoSelect:NO themeColor:Color_NavigationBlue resultBlock:^(id selectValue) {
            cellData.detailText =  selectValue;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",selectValue];
            XMKZSpendTypeModel *model = [self.spendTypeArray filteredArrayUsingPredicate:predicate].firstObject;
            if (model) {
                self.detialModel.SpendingTypeIDChange = model.Id;
                self.detialModel.SpndingTypeNameChange = cellData.detailText;
            }else{
                self.detialModel.SpendingTypeIDChange =spendingIdArray.firstObject;
                self.detialModel.SpndingTypeNameChange = spendingNameArray.firstObject;
            }
            [self.viewDataDic setObject:self.detialModel.SpendingTypeIDChange forKey:@"SpendingTypeID"];
            [self.viewDataDic setObject:self.detialModel.SpndingTypeNameChange forKey:@"SpndingTypeName"];
            cell.detailTextLabel.text = self.detialModel.SpndingTypeNameChange;
        }];
    }else  if (cellData.identifier == 2) {
        XMKZLabTFCell *TFcell = (XMKZLabTFCell *)cell;
        [TFcell.textField becomeFirstResponder];
    }
    [self.tableView deselectRowAtIndexPath:cellData.indexPath animated:YES];
}

#pragma mark ---------------------------------------------------------- PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images {
    // 在这里做当点击添加图片按钮时，你想做的事。
    // 这里我利用导入的图片，模拟从相册选图片或者拍照。(这里默认最多导入9张，超过时取前九张)
    [self.footView endEditing:YES];
    [self.tableView endEditing:YES];
    UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleTakePhotoButtonClick:nil];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
            [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentAlbumViewControllerWithTitle:@"选择图片"];
                });
            }];
        } else {
            [self presentAlbumViewControllerWithTitle:@"选择图片"];
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex{
    [photosView reloadDataWithImages:self.imagesPicker.images ];
    photosView.height =   [self.imagesPicker sizeWithPhotoCount:self.imagesPicker.images.count photosState:PYPhotosViewStateWillCompose].height;
    [self.tableView.tableFooterView layoutSubviews];
    self.footViewHigh = self.imagesPicker.height;
    self.footView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame), CGRectGetMinY(self.tableView.tableFooterView.frame), CGRectGetWidth(self.tableView.tableFooterView.frame), self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100);
    self.tableView.tableFooterView = self.footView;
}

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr {
    [self.footView endEditing:YES];
    [self.tableView endEditing:YES];
}
- (void)handleTakePhotoButtonClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:self.photoPicker animated:YES completion:^(void) {
        }];
    } else {
        [QMUITips showError:@"检测不到该设备中有可使用的摄像头" inView:self.view hideAfterDelay:2];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dealTheImageWithMediaInfo:info];
        });
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(void) {
    }];
}

-(void)dealTheImageWithMediaInfo:(NSDictionary *)info{
    UIImage *origImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (origImg!=nil) {
        UIImage *newImage =  [self zipNSDataWithImage:origImg scaledToSize:CGSizeMake(480, 500)];
        [self.imagesPicker.images addObject:newImage];
        [self.imagesPicker reloadDataWithImages:self.imagesPicker.images];
        self.imagesPicker.height =   [self.imagesPicker sizeWithPhotoCount:self.imagesPicker.images.count photosState:PYPhotosViewStateWillCompose].height;//.height + ImagePickerPadding;
        [self.tableView.tableFooterView layoutSubviews];
        self.footViewHigh = self.imagesPicker.height;
        //        if ( self.footViewHigh< PickHigh) {
        //            self.footViewHigh = PickHigh;
        //        }
        self.footView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame), CGRectGetMinY(self.tableView.tableFooterView.frame), CGRectGetWidth(self.tableView.tableFooterView.frame), self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100);
        self.tableView.tableFooterView = self.footView;
    }
}

//   跳转至 相簿列表
- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = title;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];

    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];

        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }

    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark ------------------------- <QMUIAlbumViewControllerDelegate>

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = self.imagesPicker.imagesMaxCountWhenWillCompose;//MaxSelectedImageCount;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.minimumImageWidth = self.imagesPicker.photoWidth;
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:QMUIAlbumContentTypeOnlyPhoto userIdentify:nil];
    [self sendImageWithImagesAssetArray:imagesAssetArray];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    QDMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDMultipleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.maximumSelectImageCount = self.imagesPicker.imagesMaxCountWhenWillCompose;//MaxSelectedImageCount
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
    return imagePickerPreviewViewController;
}

#pragma mark - <QMUIImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    // 在预览界面选择图片时，控制显示当前所选的图片，并且展示动画
    QDMultipleImagePickerPreviewViewController *customImagePickerPreviewViewController = (QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController;
    NSUInteger selectedCount = [imagePickerPreviewViewController.selectedImageAssetArray count];
    if (selectedCount > 0) {
        customImagePickerPreviewViewController.imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
        customImagePickerPreviewViewController.imageCountLabel.hidden = NO;
        [QMUIImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:customImagePickerPreviewViewController.imageCountLabel];
    } else {
        customImagePickerPreviewViewController.imageCountLabel.hidden = YES;
    }
}

#pragma mark - <QDMultipleImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(QDMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:QMUIAlbumContentTypeOnlyPhoto userIdentify:nil];
    [self sendImageWithImagesAssetArray:imagesAssetArray];
}

-(void)sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    for (QMUIAsset *tempAseet  in imagesAssetArray) {
        UIImage *origImg = [self zipNSDataWithImage:tempAseet.originImage scaledToSize:CGSizeMake(480, 500)];
        [self.imagesPicker.images addObject:origImg];
    }
    [self.imagesPicker reloadDataWithImages:self.imagesPicker.images ];
    self.imagesPicker.height =   [self.imagesPicker sizeWithPhotoCount:self.imagesPicker.images.count photosState:PYPhotosViewStateWillCompose].height;
    [self.tableView.tableFooterView layoutSubviews];
    self.footViewHigh = self.imagesPicker.height;
    self.footView.frame = CGRectMake(CGRectGetMinX(self.tableView.tableFooterView.frame), CGRectGetMinY(self.tableView.tableFooterView.frame), CGRectGetWidth(self.tableView.tableFooterView.frame), self.footViewHigh +  5*ImagePickerPadding/2 +2*ImagePickerPadding +100);
    self.tableView.tableFooterView = self.footView;
}

#pragma  mark  压缩图片

-(UIImage *)zipNSDataWithImage:(UIImage *)sourceImage scaledToSize:(CGSize)newSize{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    CGFloat scale = height/width;

    UIGraphicsBeginImageContext(CGSizeMake(newSize.width,newSize.width *scale));
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.width *scale)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    //    return data;
    UIImage *ima =[UIImage imageWithData:data];
    return ima;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.text.floatValue == 0) {
        textField.text = @"";
    }
   textField.placeholder = @"请输入";
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [NSString numberMoneyFormattor:textField.text];
    self.detialModel.AmountChange = [(textField.text.length == 0?@"":textField.text) stringByReplacingOccurrencesOfString:@"," withString:@""];
    [self.viewDataDic setObject:self.detialModel.AmountChange forKey:@"Amount"];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str =[textField.text stringByAppendingString:string];
    if (![NSString isAvailableStr:str WithFormat:@"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$"]) {//@"^([1-9][0-9]*)$"
        return NO;
    }
    if (str.floatValue>10000000) {
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(QMUITextView *)textView{
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.detialModel.RemarkChange = textView.text.length == 0?@"":textView.text;
    [self.viewDataDic setObject:self.detialModel.RemarkChange forKey:@"Remark"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    NSLog("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
