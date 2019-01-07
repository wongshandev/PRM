//
//  ProjectChangeViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/20.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProjectChangeViewController.h"
#import "ProjectChangeDetialCell.h"
#import "ProjectChangeDetialModel.h"

#import "ReviseProjectChangeView.h"

#import "PopSelectTypeTableView.h"

#import "FileSelectView.h"
#import "FileModel.h"

@interface ProjectChangeViewController ()<
UITableViewDelegate,UITableViewDataSource,
UIDocumentInteractionControllerDelegate,
UIPopoverPresentationControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>{
    PopSelectTypeTableView *tableVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;
@property(nonatomic,strong)ReviseProjectChangeView *reviseProjectView;

@property(nonatomic,copy)NSString *uploadFilePath;


@property(nonatomic,copy)NSString *DState;
@property(nonatomic,copy)NSString *WaitChange;

@property(nonatomic,assign)BOOL isNewAdd;

@end

@implementation ProjectChangeViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // 配置数据源  注册 cell 配置 tableView
    self.dataArray = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectChangeDetialCell" bundle:nil] forCellReuseIdentifier:@"ProjectChangeDetialCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight= 80;
    
    // 数据请求
    [self requestCurrentViewData];
    
    //设置 navigation
    [self setNavigationItems];
    //键盘监听事件
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark ***************设置 navigationBar

-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    if (self.DState.integerValue == 7 && self.WaitChange.integerValue== 0 ) {
        UIBarButtonItem *queding_Item = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewProjectChangeAction:)];
        [self.navigationItem setRightBarButtonItem:queding_Item];
    }
}
-(void)addNewProjectChangeAction:(UIBarButtonItem *)sender{
    self.isNewAdd= YES;
    self.reviseProjectView = [[[NSBundle mainBundle] loadNibNamed:@"ReviseProjectChangeView" owner:nil options:nil] firstObject];
    [self.view addSubview:self.reviseProjectView];
    [self.reviseProjectView  reloadInputViews];
    [self.reviseProjectView.changeTypeButton setTitle:@"变更类型" forState:UIControlStateNormal];
    
    [self.reviseProjectView.changeTypeButton  addTarget:self action:@selector(showSelectTypeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviseProjectView.selectFileButton addTarget:self action:@selector(selectFileAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviseProjectView.cancelButton addTarget:self action:@selector(removeTheReviseProjectViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviseProjectView.submitButton addTarget:self action:@selector(submitTheCellChangesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.reviseProjectView.frame = [UIScreen mainScreen].bounds;
    }];
    
    
}
#pragma mark ***************数据请求
-(void)requestCurrentViewData{
    [self showProgressHUD];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppPBCOList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"ProjectBranchID":self.projectBranchID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        self.DState = [NSString stringWithFormat:@"%@",[responder objectForKey:@"DState"]];
        self.WaitChange = [NSString stringWithFormat:@"%@",[responder objectForKey:@"WaitChange"]];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            ProjectChangeDetialModel *model = [[ProjectChangeDetialModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self hideProgressHUD];
        [self showInfoMentation];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self hideProgressHUD];
        [self showMessageLabel:@"数据请求出错..."withBackColor:kGeneralColor_lightCyanColor];
    }];
}

-(void)showInfoMentation{
    if (self.dataArray.count ==0 ) {
        [self showMessageLabel:@"后台无可加载数据.."withBackColor:kGeneralColor_lightCyanColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ***************UITableViewDelegate,UITableViewDataSource,

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectChangeDetialCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectChangeDetialCell" forIndexPath:indexPath];
    ProjectChangeDetialModel *model = self.dataArray[indexPath.row];
    [cell showCellDataWithModel:model];
    cell.downLoadButton.tag = indexPath.row;
    [cell.downLoadButton addTarget:self action:@selector(downloadFileAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.isNewAdd= NO;
    self.reviseProjectView = [[[NSBundle mainBundle] loadNibNamed:@"ReviseProjectChangeView" owner:nil options:nil] firstObject];
    ProjectChangeDetialCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    ProjectChangeDetialModel *model = self.dataArray[indexPath.row];
    
    [self.reviseProjectView.changeTypeButton setTitle:cell.changeTypeLabel.text forState:UIControlStateNormal];
    [self.reviseProjectView.changeDescriptionTV setText:cell.markLabel.text];
    
    
    self.reviseProjectView.filePathLabel.text = [model.Url componentsSeparatedByString:@"/"].lastObject;
    [self.view addSubview:self.reviseProjectView];
    [self.reviseProjectView  reloadInputViews];
    
    [self.reviseProjectView.changeTypeButton  addTarget:self action:@selector(showSelectTypeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviseProjectView.selectFileButton addTarget:self action:@selector(selectFileAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviseProjectView.cancelButton addTarget:self action:@selector(removeTheReviseProjectViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviseProjectView.submitButton addTarget:self action:@selector(submitTheCellChangesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        self.reviseProjectView.frame = [UIScreen mainScreen].bounds;
    }];
    
}
//取消移除
- (void)removeTheReviseProjectViewAction:(id)sender {
    [self.reviseProjectView removeFromSuperview];
}



- (void)uploadFileAndNewAddAndChangeProject:(NSMutableDictionary *)paradic {
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"SaveChangeOrders"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/json",@"text/javascript",nil];
    //    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject:响应体信息
     第六个参数:失败回调
     */
    [manager POST:urlStr parameters:paradic constructingBodyWithBlock:^(id  _Nonnull formData) {
        UIImage *image = [UIImage imageWithContentsOfFile:self.uploadFilePath];
        NSData *imageData = UIImagePNGRepresentation(image);
        /*
         //使用formData来拼接数据
         //             第一个参数:二进制数据 要上传的文件参数
         //             第二个参数:服务器规定的
         //             第三个参数:该文件上传到服务器以什么名称保存
         */
//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
//                [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/Cehae/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png" error:nil];
        
        if (self.uploadFilePath!= nil) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.uploadFilePath] name:@"file.png" error:nil];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);
        //            kMyLog(@"%@",[responseObject objectForKey:@"msg"]);
        [self showMessageLabel:[responseObject objectForKey:@"msg"] withBackColor:kGeneralColor_lightCyanColor];
        [self.reviseProjectView removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
        [self.reviseProjectView removeFromSuperview];
    }];
}

//提交
- (void)submitTheCellChangesAction:(id)sender {
    NSString *ChangeOrderIDStr;
    if (self.isNewAdd) {
        ChangeOrderIDStr = @"0";
    }else{
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        ProjectChangeDetialModel *model = [self.dataArray objectAtIndex:index.row];
        ChangeOrderIDStr = model.Id;
    }
    NSMutableDictionary *paradic = [@{
                                      @"ChangeOrderID":ChangeOrderIDStr,
                                      @"ProjectBranchID":self.projectBranchID,
                                      @"EmployeeID":kEmployeeID,
                                      @"ChangeType":[self.reviseProjectView.changeTypeButton.currentTitle  isEqual: @"签证变更"]?@"1":@"2",
                                      @"Remark":self.reviseProjectView.changeDescriptionTV.text,
                                      }mutableCopy];
    
    
    if (self.isNewAdd && self.uploadFilePath.length== 0) {
        [self showMessageLabel:@"新增变更附件不能为空" withBackColor:kWarningColor_lightRedColor];
    }else{
        [self uploadFileAndNewAddAndChangeProject:paradic];
    }
}
//类型选择
- (void)showSelectTypeViewAction:(UIButton *)sender {
    //注意弹出的不是popover，而是内容，他的内容会呈现在popover中
    NSMutableArray *dataArr = [@[@"签证变更", @"乙方责任"] mutableCopy];
    [self  setPopSelectTypeViewwWithDataSource:dataArr
                                    SourceView:sender
                                     SoureRect: sender.bounds
                                      ViewSize:CGSizeMake(sender.frame.size.width , dataArr.count*30)];
}

-(void)setPopSelectTypeViewwWithDataSource:(NSMutableArray *)dataArray SourceView:(UIButton *)sender SoureRect:(CGRect)sourceRect  ViewSize:(CGSize )viewSize {
    tableVC = [[PopSelectTypeTableView alloc] init];
    tableVC.dataSource = dataArray;
    tableVC.selectAloneCellBlock = ^(NSString *stateString){
        [sender setTitle:stateString forState:UIControlStateNormal];
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

#pragma mark****************附件下载
-(void)downloadFileAction:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:sender.tag inSection:0];
    kMyLog(@"***%@",indexPath);
    ProjectChangeDetialModel *model = self.dataArray[indexPath.row];
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
      kMyLog(@"%@",response.MIMEType);
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
#pragma mark ***************查看文件
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


-(void)selectFileAction:(UIButton *)sender{
    kMyLog(@"%@",[self getAllFileNames:@"Documents"]);
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
            self.reviseProjectView.filePathLabel.text = fileNameStr;
            self.uploadFilePath = filePath;
        };
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fileSelectVC];
        [self presentViewController:navc animated:YES completion:nil];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}





#pragma mark - UIDocumentInteractionControllerdelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
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
        self.reviseProjectView.frame = CGRectMake(0, - keyboardRect.size.height + 40, kDeviceWidth, kDeviceHeight+ keyboardRect.size.height);
    }];
}
//键盘消失时
-(void)keyboardWillHidden{
    //定义动画
    [UIView animateWithDuration:0.25 animations:^{
        //设置view的frame，往下平移
        self.reviseProjectView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    } completion:nil];
    
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
        [self showMessageLabel:@"设备无相机" withBackColor:kGeneralColor_lightCyanColor];
    }
    
}

-(void)getImageFromDCMI{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
        self .reviseProjectView.filePathLabel.text = [fileStr componentsSeparatedByString:@"/"].lastObject;
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
