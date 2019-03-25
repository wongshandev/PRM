//
//  XMBGDetialController.m
//  PRM
//
//  Created by apple on 2019/1/19.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMBGDetialController.h"
#import "XMBGDetailModel.h"
#import "XMBGDetailCell.h"
#import "XMBGAlertContentView.h"
#import "FileModel.h"
#import "FileSelectView.h"
#import "XMBGNewAddController.h"

@interface XMBGDetialController ()<UIDocumentInteractionControllerDelegate,PYPhotoBrowseViewDelegate,PYPhotoBrowseViewDataSource>
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;

@property(nonatomic,assign)NSInteger DState;
@property(nonatomic,assign)NSInteger WaitChange;
@property (nonatomic, strong) XMBGAlertContentView * alertContentView;
//@property (nonatomic, strong) PYPhotoBrowseView *browserView;;

@end

@implementation XMBGDetialController
-(UIDocumentInteractionController *)documentInteractionController{
    if (!_documentInteractionController) {
        _documentInteractionController = [[UIDocumentInteractionController alloc]init];
        _documentInteractionController.delegate = self;
    }
    return _documentInteractionController;
}
//-(PYPhotoBrowseView *)browserView{
//    if (!_browserView) {
//        _browserView = [[PYPhotoBrowseView alloc]init];
//        _browserView.delegate = self;
//        _browserView.dataSource = self;
//     }
//    return _browserView;
//}


-(void)setUpNavigationBar{
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.listModel.Name;
    [self.navBar.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    Weak_Self;
    [self.navBar.rightButton clickWithBlock:^{
        XMBGNewAddController *newAddVC = [[XMBGNewAddController alloc]init];
        XMBGDetailModel *model = [[XMBGDetailModel alloc]init];
        model.isNewAdd = YES;
        model.Id = @"0";
        model.ChangeType = @"1";
        
        newAddVC.title =@"新增变更";
        newAddVC.projectBranchID = weakSelf.listModel.Id;
        newAddVC.detialModel = model;
        [weakSelf.navigationController pushViewController:newAddVC animated:YES];
    }];
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
        [weakSelf requestData_XMBGDetial];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)requestData_XMBGDetial{
    [SJYRequestTool requestXMBGDetialWithProjectBranchID:self.listModel.Id SearchCode:@"" success:^(id responder) {
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.DState = [[responder objectForKey:@"DState"] integerValue];
        self.WaitChange = [[responder objectForKey:@"WaitChange"] integerValue];
        if (self.DState == 7 && self.WaitChange== 0 ) {
            self.navBar.rightButton.hidden = NO;
        }

        if (self.tableView.mj_header.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in rowsArr) {
            XMBGDetailModel *model = [XMBGDetailModel  modelWithDictionary:dic];
            NSString *string = model.ChangeType.integerValue == 1 ? @"签证变更":@"乙方责任";
            model.titleStr = model.CreateDate.length ? [string stringByAppendingFormat:@"(%@)", model.CreateDate]:string;
            model.Url =[model.Url stringByReplacingOccurrencesOfString:@".." withString:API_ImageUrl];
            model.isNewAdd= NO;
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
    XMBGDetailCell *cell = [XMBGDetailCell cellWithTableView:tableView];
    XMBGDetailModel *model =  self.dataArray[indexPath.row];
    cell.cellType = CellType_XMBGDetial;
    cell.indexPath = indexPath;
    cell.data = model;
    [cell loadContent];
    Weak_Self;
    [cell.fujianBtn clickWithBlock:^{
        [weakSelf downLoadOrLookFile:model];
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMBGDetailModel *model =  self.dataArray[indexPath.row];

    XMBGNewAddController *newAddVC = [[XMBGNewAddController alloc]init];
    model.isNewAdd = NO;
    newAddVC.title = @"变更详情";
    newAddVC.projectBranchID = self.listModel.Id;
    newAddVC.detialModel = model;
    [self.navigationController pushViewController:newAddVC animated:YES];

 }






-(void)downLoadOrLookFile:(XMBGDetailModel *)model {
    NSString *fileNameString = model.Url.lastPathComponent;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savefilePath = [document stringByAppendingPathComponent:fileNameString];
    if ([fileManager fileExistsAtPath:savefilePath]) {
        //存在  --------弹窗提示直接打开 //重新新下载
        [self openFileAtPath:[NSURL fileURLWithPath:savefilePath]];
    }else {
        //不存在-------下载保存
        [self downLoadFileWithCellModeUrl:model.Url saveAtPath:savefilePath];
    }
//    if ([fileManager fileExistsAtPath:savefilePath]) {
//        //存在  --------弹窗提示直接打开 //重新新下载
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认" message:@"文件已存在是否重新下载" preferredStyle:UIAlertControllerStyleAlert];
//        [alertVC addAction: [UIAlertAction actionWithTitle:@"直接打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //快速预览
//            [self openFileAtPath:[NSURL fileURLWithPath:savefilePath]];
//        }]];
//        [alertVC addAction: [UIAlertAction actionWithTitle:@"重新下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [fileManager removeItemAtPath:savefilePath error:nil];
//            [self downLoadFileWithCellModeUrl:model.Url saveAtPath:savefilePath];
//        }]];
//        [alertVC addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alertVC animated:YES completion:nil];
//    }else {
//        //不存在-------下载保存
//        [self downLoadFileWithCellModeUrl:model.Url saveAtPath:savefilePath];
//    }
}

#pragma mark ------------ 附件查看代理事件 ------------ UIDocumentInteractionControllerdelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
#pragma mark ------------ 附件下载

-(void)downLoadFileWithCellModeUrl:(NSString  *)downloadUrl saveAtPath:(NSString *)saveFilePath{
    //    NSURL * url = [NSURL URLWithString:[downloadUrl stringByReplacingOccurrencesOfString:@".." withString:API_ImageUrl]];
    NSURL * url = [NSURL URLWithString: downloadUrl];
    [HttpClient downLoadFilesWithURLStringr:url progress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips showLoading:[NSString stringWithFormat:@"%.2f%%",(downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount*100)] inView:self.view];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:saveFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [QMUITips hideAllTips];
//            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"查看附件?" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self openFileAtPath:filePath];
//            }]];
//            [self presentViewController:alert animated:YES completion:nil];
//
//        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips hideAllTips];
            [self openFileAtPath:filePath];
        });
        NSLog(@" 附件 : %@",filePath);

    }];

}
#pragma mark ***************查看文件
-(void)openFileAtPath:(NSURL *)filePath{
    if (filePath) {
        self.documentInteractionController.URL = filePath;
        if ([self.documentInteractionController presentPreviewAnimated:YES]){
            NSLog(@"打开成功");
        } else{
            CGRect navRect = self.navigationController.navigationBar.frame;
            navRect.size =CGSizeMake(SCREEN_W*3,40.0f);
            [self.documentInteractionController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
            NSLog(@"打开失败");
        }
    } else {
        SJYAlertShow(@"打开文档失败，可能文档损坏，请重试", @"确认"); 
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
}


@end
