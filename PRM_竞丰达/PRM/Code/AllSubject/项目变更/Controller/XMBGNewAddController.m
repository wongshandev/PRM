//
//  XMBGNewAddController.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMBGNewAddController.h"
#import "FileModel.h"
#import "FileSelectView.h"
#import "SJYXMBGViewController.h"

@interface XMBGNewAddController ()<UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;
@property (nonatomic, strong) XMBGAlertContentView * alertContentView;
@property(nonatomic,copy)NSString *uploadFilePath;
@end

@implementation XMBGNewAddController

-(void)setUpNavigationBar{
    self.navBar.titleLabel.text = self.title;
    [self.navBar.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    self.navBar.rightButton.hidden = !self.detialModel.isNewAdd;
    Weak_Self;
    [self.navBar.rightButton clickWithBlock:^{
         NSMutableDictionary *paradic = [@{
                                          @"ChangeOrderID":self.detialModel.Id,
                                          @"ProjectBranchID":self.projectBranchID,
                                          @"EmployeeID":kEmployeeID,
                                          @"ChangeType":[self.alertContentView.typeBtn.currentTitle  isEqualToString: @"签证变更"]?@"1":@"2",
                                          @"Remark":self.alertContentView.xmbgDescriptTV.text,
                                          }mutableCopy];

        if (self.detialModel.isNewAdd && self.uploadFilePath.length== 0) {
            [QMUITips showError:@"新增变更,附件不能为空" inView:self.view hideAfterDelay:1.2];
        }else{
            [weakSelf uploadFileAndNewAddAndChangeProject:paradic];
        }
    }];
}

- (void)uploadFileAndNewAddAndChangeProject:(NSMutableDictionary *)paradic {
     [HttpClient uploadFileWithUrl:API_XMQGBGDetialSubmit paradic:paradic filePath:self.uploadFilePath progress:^(NSProgress *uploadProgress) {
        CGFloat    pro = uploadProgress.fractionCompleted;
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips showLoading:[NSString stringWithFormat:@"%.2f", pro] inView:self.view];
        });
    }  success:^(NSURLSessionDataTask *dataTask, id responseObjcet) {
        [QMUITips hideAllTips];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSJYXMBGViewControllerList" object:nil];
        [QMUITips showSucceed:[responseObjcet objectForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController.viewControllers  enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:SJYXMBGViewController.class]) {
                    [self.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                }
            }];
        });
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [QMUITips showSucceed:error.description inView:self.view hideAfterDelay:1.2];
    }];
}

-(void)buildSubviews{
    self.alertContentView = [[XMBGAlertContentView alloc] init];
    self.alertContentView.detailModel = self.detialModel;
    [self.view addSubview:self.alertContentView];

    UILabel *sepLab = [[UILabel alloc]init];
    sepLab.backgroundColor = Color_SrprateLine;
    [self.alertContentView addSubview:sepLab];



    [self.alertContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(250);
    }];

    self.alertContentView.backgroundColor = UIColorWhite;
    self.alertContentView.detailModel = self.detialModel;

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
    [sepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.alertContentView.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.alertContentView.fujianBtn.mas_left);
        make.right.mas_equalTo(self.alertContentView.fujianBtn.mas_right);
    }];

    Weak_Self;
    [self.alertContentView.typeBtn clickWithBlock:^{
        [weakSelf.alertContentView endEditing:YES];
        [BRStringPickerView showStringPickerWithTitle:@"变更类型" dataSource:@[@"签证变更",@"乙方责任"] defaultSelValue:weakSelf.alertContentView.fujianBtn isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
            [weakSelf.alertContentView.typeBtn setTitle:selectValue forState:UIControlStateNormal];
        }];
    }];
    [self.alertContentView.fujianBtn clickWithBlock:^{
        if (weakSelf.detialModel.isNewAdd) {
            [weakSelf.alertContentView endEditing:YES];
            [weakSelf selectFileAction:weakSelf.alertContentView.fujianBtn];
        } else{
            [weakSelf downLoadOrLookFile:weakSelf.detialModel];
        }
    }];
}
#pragma mark ------------ 附件下载

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
#pragma mark ------------ 附件下载 
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
            self.uploadFilePath = filePath;
        };
         [self presentViewController:fileSelectVC animated:YES completion:nil];

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
        self.uploadFilePath = fileStr;
    }]; 
}

//保存图片
- (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
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
        /*
         [self.quickLookArray addObject:filePath];
         NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
         NSURL *url = [NSURL fileURLWithPath:path];
         */
    }];

}
@end
