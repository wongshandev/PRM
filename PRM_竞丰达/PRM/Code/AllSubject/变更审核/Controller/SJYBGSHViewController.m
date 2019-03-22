//
//  SJYBGSHViewController.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYBGSHViewController.h"

#import "BGSHListCell.h"
#import "BGSHListModel.h"
#import "SJYBGSHSearchAlertView.h"

#define  STATEArray  @[@"全部",@"未审核",@"已审核"]
#define  ListSTATEColorArray  @[[UIColor whiteColor],UIColorHex(#EF5362),UIColorHex(#007BD3)]

@interface SJYBGSHViewController ()<UIDocumentInteractionControllerDelegate,QMUITextFieldDelegate>
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;
@property (nonatomic, strong) SJYBGSHSearchAlertView * searchAlertView;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger totalNum;
@property(nonatomic,assign)NSInteger  shStateType;
@property(nonatomic,copy)NSString * searchCode;

@end

@implementation SJYBGSHViewController


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
    
    self.searchAlertView = [[SJYBGSHSearchAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.searchAlertView.backgroundColor = UIColorWhite;
    self.searchAlertView.codeTF.delegate = self;
    self.searchAlertView.codeTF.text = self.searchCode;
    [self.searchAlertView.stateBtn  setTitle:[STATEArray objectAtIndex:self.shStateType +1] forState:UIControlStateNormal];
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
        [weakSelf requestData_BGSH];
    }];
    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        
        [weakSelf requestData_BGSH];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)requestData_BGSH{
    //    NSString *stateString = [stateStr isEqual: @"未审核"]?@"0":([stateStr  isEqual:@"全部"]?@"2":@"1");
    
    [SJYRequestTool requestBGSHListWithEmployID:[SJYUserManager sharedInstance].sjyloginUC.Id SearchStateID:@(self.shStateType).stringValue SearchCode:self.searchCode page:self.page success:^(id responder) {
        
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.totalNum = [[responder objectForKey:@"total"] integerValue];
        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects]; 
        }
        for (NSDictionary *dic in rowsArr) {
            BGSHListModel *model = [BGSHListModel  modelWithDictionary:dic];
            model.titleStr = [model.Name  stringByAppendingFormat:@" (%@)", model.Code];
            NSString *string = model.ChangeType.integerValue == 1 ? @"签证变更":@"乙方责任";
            model.subtitleStr = [model.CName  stringByAppendingFormat:@"(%@)", string];
            BOOL isYSH = model.ApprovalID.integerValue>0;
            model.stateStr = isYSH ?STATEArray.lastObject:[STATEArray objectAtIndex:1];
            model.stateColor = isYSH ?ListSTATEColorArray.lastObject:[ListSTATEColorArray objectAtIndex:1];
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
    BGSHListCell *cell = [BGSHListCell cellWithTableView:tableView];
    BGSHListModel *model =  self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.data = model;
    [cell loadContent];
    [cell.fujianBtn clickWithBlock:^{
        [self downLoadOrLookFile:model];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BGSHListModel *model =  self.dataArray[indexPath.row];
    if (model.ApprovalID.integerValue > 0) {  // 已审核
        [QMUITips showWithText:@"该项目变更已审核" inView:self.view hideAfterDelay:1.2];
        return;
    }
    QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"提醒" message:@"确认该记录审核通过?" preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        [SJYRequestTool requestBGSHSubmitWithEmployID:[SJYUserManager sharedInstance].sjyloginUC.Id ChangeOrderID:model.Id success:^(id responder) {
            [QMUITips showSucceed:[responder objectForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                [self.tableView.mj_header beginRefreshing];
            }
        } failure:^(int status, NSString *info) {
            [QMUITips showSucceed:info inView:self.view hideAfterDelay:1.2];
        }];
    }]];
    [alert addCancelAction];
    [alert showWithAnimated:YES];
}

-(void)downLoadOrLookFile:(BGSHListModel *)model {
    NSString *fileNameString = model.Url.lastPathComponent;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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

#pragma mark ------------ 附件查看 ------------ UIDocumentInteractionControllerdelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
#pragma mark ------------ 附件下载

-(void)downLoadFileWithCellModeUrl:(NSString  *)downloadUrl saveAtPath:(NSString *)saveFilePath{
    NSURL * url = [NSURL URLWithString:[downloadUrl stringByReplacingOccurrencesOfString:@".." withString:API_ImageUrl]];
    [HttpClient downLoadFilesWithURLStringr:url progress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips showLoading:[NSString stringWithFormat:@"%.2f%%",(downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount*100)] inView:self.view];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:saveFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips hideAllTips];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"查看附件?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openFileAtPath:filePath];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        });
        NSLog(@" 附件 : %@",filePath);
        
    }];
    
}
#pragma mark ***************查看文件
//-(void)openFileAtPath:(NSURL *)filePath{
//    if (filePath) {
//        if ([[NSString stringWithFormat:@"%@",filePath] hasSuffix:@"TTF"]) {
//            [QMUITips showWithText:@"不支持的文件格式" inView:self.view hideAfterDelay:1.5];
//        }else{
//            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
//            //self.documentInteractionController
//            [self.documentInteractionController setDelegate:self];
//            [self.documentInteractionController presentPreviewAnimated:YES];
//        }
//    } else {
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"打开失败" message:@"打开文档失败，可能文档损坏，请重试" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}

-(void)openFileAtPath:(NSURL *)filePath{
    if (filePath) {
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
        [self.documentInteractionController setDelegate:self];
        if ([self.documentInteractionController presentPreviewAnimated:YES]){
            NSLog(@"打开成功");
        } else{
            CGRect navRect = self.navigationController.navigationBar.frame;
            navRect.size =CGSizeMake(SCREEN_W*3,40.0f);
            [self.documentInteractionController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
            NSLog(@"打开失败");
        }
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"打开失败" message:@"打开文档失败，可能文档损坏，请重试" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.searchCode;
    self.searchAlertView.sepLine.backgroundColor = Color_NavigationLightBlue;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = textField.text.length ?textField.text:@"";
    self.searchAlertView.sepLine.backgroundColor = Color_SrprateLine;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
}


@end
