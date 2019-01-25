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

@interface XMBGDetialController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;

@property(nonatomic,assign)NSInteger DState;
@property(nonatomic,assign)NSInteger WaitChange;
@property (nonatomic, strong) XMBGAlertContentView * alertContentView;

@end

@implementation XMBGDetialController

-(void)setUpNavigationBar{
    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.listModel.Name;
    [self.navBar.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    Weak_Self;
    [self.navBar.rightButton clickWithBlock:^{
        XMBGNewAddController *newAddVC = [[XMBGNewAddController alloc]init];
        XMBGDetailModel *model = [[XMBGDetailModel alloc]init];
        model.isNewAdd = YES;
        model.Id = @"0";

        newAddVC.title =@"新增变更";
        newAddVC.projectBranchID = self.listModel.Id;
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
    XMBGDetailCell *cell = [XMBGDetailCell cellWithTableView:tableView];
    XMBGDetailModel *model =  self.dataArray[indexPath.row];
    cell.cellType = CellType_XMBGDetial;
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
    XMBGDetailModel *model =  self.dataArray[indexPath.row];

    XMBGNewAddController *newAddVC = [[XMBGNewAddController alloc]init];
     model.isNewAdd = NO;
    newAddVC.title = @"变更详情";
     newAddVC.projectBranchID = self.listModel.Id;
    newAddVC.detialModel = model;
    [self.navigationController pushViewController:newAddVC animated:YES];

//    [self alertXMBGDetial:model];
}

-(void)downLoadOrLookFile:(XMBGDetailModel *)model {
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
-(void)openFileAtPath:(NSURL *)filePath{
    if (filePath) {
        if ([[NSString stringWithFormat:@"%@",filePath] hasSuffix:@"TTF"]) {
            [QMUITips showWithText:@"不支持的文件格式" inView:self.view hideAfterDelay:1.5];
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

#pragma mark *************** 弹窗查看
/*
 -(void)alertXMBGDetial:(XMBGDetailModel *)model {
 QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
 QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
 dialogViewController.title = @"项目变更";
 self.alertContentView = [[XMBGAlertContentView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
 self.alertContentView.backgroundColor = UIColorWhite;
 self.alertContentView.detailModel = model;

 [self.alertContentView.xmbgTypeLab makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(self.alertContentView.mas_top).offset(5);
 make.left.mas_equalTo(self.alertContentView.mas_left).offset(10);
 make.right.mas_equalTo( self.alertContentView.mas_right).offset(-10);
 make.height.mas_equalTo(20);
 }];

 [self.alertContentView.typeBtn makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(self.alertContentView.xmbgTypeLab.mas_bottom).offset(5);
 make.left.mas_equalTo(self.alertContentView.mas_left).offset(10);
 make.right.mas_equalTo( self.alertContentView.mas_right).offset(-10);
 make.height.mas_equalTo(35);
 }];

 [self.alertContentView.rightTypeImgView makeConstraints:^(MASConstraintMaker *make) {
 make.centerY.mas_equalTo(self.alertContentView.typeBtn.mas_centerY);
 make.right.mas_equalTo(self.alertContentView.mas_right).offset(-10);
 make.height.mas_equalTo(30);
 make.width.mas_equalTo(30);
 }];

 [self.alertContentView.xmbgDescriptLab makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(self.alertContentView.typeBtn.mas_bottom).offset(5);
 make.left.mas_equalTo(self.alertContentView.mas_left).offset(10);
 make.right.mas_equalTo( self.alertContentView.mas_right).offset(-10);
 make.height.mas_equalTo(20);
 }];

 [self.alertContentView.xmbgDescriptTV makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(self.alertContentView.xmbgDescriptLab.mas_bottom).offset(5);
 make.left.mas_equalTo(self.alertContentView.mas_left).offset(10);
 make.right.mas_equalTo( self.alertContentView.mas_right).offset(-10);
 }];
 [self.alertContentView.fjImgView makeConstraints:^(MASConstraintMaker *make) {
 make.top.mas_equalTo(self.alertContentView.xmbgDescriptTV.mas_bottom).offset(5);
 make.left.mas_equalTo(self.alertContentView.mas_left).offset(10);
 make.width.mas_equalTo(35);
 make.height.mas_equalTo(35);
 make.bottom.mas_equalTo(self.alertContentView.mas_bottom).offset(-5);
 }];
 [self.alertContentView.fujianBtn makeConstraints:^(MASConstraintMaker *make) {
 make.centerY.mas_equalTo(self.alertContentView.fjImgView.mas_centerY);
 make.left.mas_equalTo(self.alertContentView.fjImgView.mas_right).offset(10);
 make.right.mas_equalTo( self.alertContentView.mas_right).offset(-10);
 make.height.mas_equalTo(self.alertContentView.fjImgView.mas_height);
 }];

 Weak_Self;
 [self.alertContentView.typeBtn clickWithBlock:^{
 [self.alertContentView endEditing:YES];
 [BRStringPickerView showStringPickerWithTitle:@"变更类型" dataSource:@[@"签证变更",@"乙方责任"] defaultSelValue:weakSelf.alertContentView.fujianBtn isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
 [weakSelf.alertContentView.typeBtn setTitle:selectValue forState:UIControlStateNormal];
 }];
 }];
 [self.alertContentView.fujianBtn clickWithBlock:^{
 //        if (model.isNewAdd) {
 //            [self.alertContentView endEditing:YES];
 //            [weakSelf selectFileAction:weakSelf.alertContentView.fujianBtn];
 //        }else{
 [weakSelf downLoadOrLookFile:model];
 //        }
 }];
 dialogViewController.contentView = self.alertContentView;
 [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
 [modalViewController hideInView:self.view animated:YES completion:nil];
 }];

 if (model.isNewAdd) {
 [dialogViewController addSubmitButtonWithText:@"提交" block:^(QMUIDialogViewController *aDialogViewController) {
 [modalViewController hideInView:self.view animated:YES completion:^(BOOL finished) {
 [weakSelf.tableView.mj_header beginRefreshing];
 }];
 }];
 }

 modalViewController.modal = YES;
 modalViewController.contentViewController = dialogViewController;
 [modalViewController showInView:self.view animated:YES completion:nil];
 }
 */

#pragma mark *************** 文件选择   上传

/*
-(void)selectFileAction:(UIButton *)sender{
    NSLog(@"%@",[self getAllFileNames:@"Documents"]);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"文件选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getImageFromDCMI];
    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhotoFromCamera];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"沙盒获取文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *nameArr =[[self getAllFileNames:@"Documents"] mutableCopy];
        NSMutableArray *fileModelArr = [NSMutableArray new];
        for (NSString *fileName in nameArr) {
            FileModel *model = [[FileModel alloc]init];
            model.filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
            model.fileName = fileName;
            [fileModelArr addObject:model];
        }
        FileSelectView *fileSelectVC = [[FileSelectView alloc]init];
        fileSelectVC.dataArray= fileModelArr;
        fileSelectVC.selectFileCellBlock = ^(NSString *fileNameStr,NSString *filePath){
            [self.alertContentView.fujianBtn setTitle:fileNameStr forState:UIControlStateNormal];
             self.alertContentView.fjImgView.image = SJYCommonImage([NSString matchType:fileNameStr.lastPathComponent]);
        };
//        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fileSelectVC];
//        [self presentViewController:navc animated:YES completion:nil];
        [self.navigationController pushViewController:fileSelectVC animated:YES];

    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)getPhotoFromCamera{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;//设置代理
        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        //picker.showsCameraControls = NO;//默认为YES
        //创建叠加层
        UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
        //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
        UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
        UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
        [overLayView addSubview:bgImageView];
        picker.cameraOverlayView=overLayView;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//选择前置摄像头或后置摄像头
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else{
        [ QMUITips showError:@"设备无相机" inView:self.view hideAfterDelay:1.2];
    }
}

-(void)getImageFromDCMI{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
         pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
    }];

}
//从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSInteger i = 0 ;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *fileStr;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
        fileStr = [self saveImage:image withName:[NSString stringWithFormat:@"camera%ld.png",(long)i++]];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        fileStr =  [self saveImage:image withName:[NSString stringWithFormat:@"photo%ld.png",(long)i++]];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self .alertContentView.fujianBtn setTitle:fileStr.lastPathComponent forState:UIControlStateNormal];
        self.alertContentView.fjImgView.image = SJYCommonImage([NSString matchType:fileStr.lastPathComponent]);
    }];

}

//保存图片
- (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    //将选择的图片显示出来
    //    [self.photoImage setImage:[UIImage imageWithContentsOfFile:fullPath]];
    //将图片保存到disk
    UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil);
    return fullPath;
}
 - (NSArray *)getAllFileNames:(NSString *)dirName {
 // 获得此程序的沙盒路径
 NSString *patchs = NSHomeDirectory();// NSSearchPathForDirectoriesInDomains(NSHomeDirectory(), NSUserDomainMask, YES);
 NSString *fileDirectory = [patchs stringByAppendingPathComponent:dirName];
 NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
 return files;
 }
*/

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
-(void)dealloc{
    NSLog(@"释放");
 }



@end
