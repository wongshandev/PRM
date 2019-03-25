//
//  WJQDListViewController.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "WJQDListViewController.h"
#import "XMBGDetailCell.h"
@interface WJQDListViewController()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;
@end
@implementation WJQDListViewController

-(void)setUpNavigationBar{
    self.navBar.hidden = YES;
}

-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  requestData_SJSH_WJQD];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

#pragma mark -----------------------------进度汇报列表

-(void)requestData_SJSH_WJQD{
    [SJYRequestTool requestSJSHWithAPI:API_SJSH_WJQDList parameters:
     @{
       @"DeepenDesignID":self.sjshListModel.Id
       }   success:^(id responder) {
           if (self.tableView.mj_header.isRefreshing) {
               [self.dataArray removeAllObjects];
           }
           NSArray *rowsArr = [responder objectForKey:@"rows"];

           for (NSDictionary *dic in rowsArr) {
               XMBGDetailModel *model = [XMBGDetailModel  modelWithDictionary:dic];
               model.Url =[model.Url stringByReplacingOccurrencesOfString:@".." withString:API_ImageUrl];
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
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMBGDetailCell *cell = [XMBGDetailCell cellWithTableView:tableView];
    XMBGDetailModel *model =  self.dataArray[indexPath.row];
    cell.cellType = CellType_WJQDList;
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
    [self downLoadOrLookFile:self.dataArray[indexPath.row]];
}

-(void)downLoadOrLookFile:(XMBGDetailModel *)model {
    NSString *fileNameString = model.Url.lastPathComponent;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savefilePath = [document stringByAppendingPathComponent:fileNameString];
    if ([fileManager fileExistsAtPath:savefilePath]) {
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
        [QMUITips hideAllTips];
        [self openFileAtPath:filePath];

        NSLog(@" 附件 : %@",filePath);
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
        //        NSLog(@" 附件 : %@",filePath);
    }];

}
#pragma mark ------------ 查看文件
-(void)openFileAtPath:(NSURL *)filePath{
    if (filePath) {
        self.documentInteractionController.URL= filePath;
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
        SJYAlertShow(@"打开文档失败，可能文档损坏，请重试", @"确认");
    }
}

#pragma mark ------------ 附件查看 UIDocumentInteractionControllerdelegate
-(UIDocumentInteractionController *)documentInteractionController{
    if (!_documentInteractionController) {
        _documentInteractionController = [[UIDocumentInteractionController alloc]init];
        _documentInteractionController.delegate = self;
    }
    return _documentInteractionController;
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

@end
