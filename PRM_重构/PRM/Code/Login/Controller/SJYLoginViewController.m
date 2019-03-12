//
//  SJYLoginViewController.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYLoginViewController.h"

#define BackView_H 44
#define TF_Padding_Left 7  
@interface SJYLoginViewController()

@property(nonatomic,strong)QMUIButton *remberPasswordBtn;
@property(nonatomic,strong)QMUITextField *nameTF;
@property(nonatomic,strong)QMUITextField *passwordTF;

@end


@implementation SJYLoginViewController

- (void)setUpNavigationBar{
    Weak_Self;
    self.navBar.hidden = NO;
    self.navBar.titleLabel.text = DisplayName;
    self.navBar.rightButton.hidden = NO;

    [self.navBar.rightButton setImage:SJYCommonImage(@"set") forState:UIControlStateNormal];
    [self.navBar.rightButton clickWithBlock:^{
        [weakSelf.view endEditing:YES];
        SJYIPSetViewController *ipVC = [[SJYIPSetViewController alloc]init];
        [weakSelf.navigationController qmui_pushViewController:ipVC animated:NO completion:^{
        }];
    }];
    [self.navBar.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navBar.leftButton.mas_right).offset(-SJYNUM(56)/2);
    }]; 
}

-(void)bindViewModel{
    [self visionCheckFromAppStore];
}
//版本更新检测
-(void)visionCheckFromAppStore{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/lookup?id=1218072711"]];
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSInteger resultCount = [[resultDic objectForKey:@"resultCount"] integerValue];
    NSDictionary *appStorInfoDic = [[resultDic objectForKey:@"results"] firstObject];
    if (error == nil  && resultCount ) {
        NSString *appVisionInfo = [appStorInfoDic valueForKey:@"version"];
        //获取本地的版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        if (![appVisionInfo isEqualToString:currentVersion]) {
            NSString *message = appStorInfoDic[@"releaseNotes"];
            NSString *trackViewUrl = appStorInfoDic[@"trackViewUrl"];

            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新版本%@啦",appVisionInfo] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:[self paragraphAlignment] }];
            [alertVC setValue:messageString forKey:@"attributedMessage"];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"马上尝鲜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:trackViewUrl]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                }
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}
//配置对齐方式
- (NSMutableParagraphStyle*)paragraphAlignment{
    NSMutableParagraphStyle*_paragraph = [[NSMutableParagraphStyle alloc]init] ;
    _paragraph.alignment=NSTextAlignmentLeft;
    return _paragraph ;
}

- (void)buildSubviews{
    Weak_Self;
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *backImgView  = [UIImageView new];
    backImgView.image = SJYCommonImage(@"loginBackImg");
    backImgView.userInteractionEnabled = YES;
    [self.view addSubview:backImgView];

    UIView *topView = [UIView new];
     [self.view addSubview:topView];

    UIImageView *imgView  = [UIImageView new];
    imgView.image = SJYCommonImage(@"AppIcon");
    [topView addSubview:imgView];

    // 手机号码
    UIView *nameView = [[UIView alloc]init];
    nameView.backgroundColor = Color_RGB_HEX(0xf0f0f0, 1);
    [self.view addSubview:nameView];

    QMUITextField *nameTF = [[QMUITextField alloc] init];
    nameTF.font = SJYFont(16);
    nameTF.borderStyle = UITextBorderStyleNone;
    nameTF.placeholder = @"用户名";
    nameTF.placeholderColor = Color_RGB_HEX(0xc6c6cc, 1);
    [nameView addSubview: nameTF];
    [nameTF addTarget:self action:@selector(textFieldsDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    self.nameTF = nameTF;


    // 密码
    UIView *passwordView = [[UIView alloc]init];
    passwordView.backgroundColor = Color_RGB_HEX(0xf0f0f0, 1);
    [self.view addSubview:passwordView];

    QMUITextField *passwordTF = [[QMUITextField alloc] init];
    passwordTF.font = SJYFont(16);
    passwordTF.borderStyle = UITextBorderStyleNone;
    passwordTF.secureTextEntry = YES;
    passwordTF.placeholder = @"密码";
    passwordTF.placeholderColor = Color_RGB_HEX(0xc6c6cc, 1);
    [passwordView addSubview: passwordTF];
    self.passwordTF = passwordTF;

    // 登录
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] init];
    loginBtn.fillColor =Color_NavigationLightBlue; //Color_RGB_HEX(0x22cc65, 1);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont  boldSystemFontOfSize:SJYNUM(18)];
    [self.view addSubview:loginBtn];
    [loginBtn clickWithBlock:^{
        [weakSelf.view endEditing:YES];
        if (weakSelf.nameTF.text.length == 0 ||  weakSelf.passwordTF.text.length == 0) {
            [QMUITips showWithText:@"登录信息不完善" inView:weakSelf.view
                    hideAfterDelay:1.3];
            return ;
        }
        [QMUITips showLoading:@"加载中..." inView:weakSelf.view];
        [SJYRequestTool loginInfoWithUserName:weakSelf.nameTF.text passworld:weakSelf.passwordTF.text success:^(LoginModel *loginInfo) {
            [QMUITips hideAllTipsInView: weakSelf.view];
            [SJYUserManager sharedInstance].loginModel= loginInfo;
            [[SJYUserManager sharedInstance]updateLoginModel];
            
            [SJYUserManager sharedInstance].sjyloginData= loginInfo.uc;
            [[SJYUserManager sharedInstance] updateLoginData];
            
            [QMUITips showSucceed:@"登录成功" inView:weakSelf.view hideAfterDelay:0.6];
            if ([[SJYDefaultManager shareManager] isRemberPassword]) {
                [[SJYDefaultManager shareManager] saveUserName:weakSelf.nameTF.text password:weakSelf.passwordTF.text];
            }
            [[SJYDefaultManager shareManager] saveEmployeeName:loginInfo.employeeName Dt_Info:loginInfo.dt EmployeeID:loginInfo.employeeID DepartmentID:loginInfo.departmentID PositionID:loginInfo.positionID];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SJYMainViewController *mainVC = [[SJYMainViewController alloc] init];
                [weakSelf.navigationController qmui_pushViewController:mainVC animated:YES completion:^{
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate gotoMainVC];
                }];
            });
            
        } failure:^(int status, NSString *info) {
            [QMUITips hideAllTipsInView: weakSelf.view];
            [QMUITips showError:info inView:weakSelf.view hideAfterDelay:1.5];
        }];
        //        [SJYRequestTool loginWithUserName:weakSelf.nameTF.text passworld:weakSelf.passwordTF.text complete:^(id responder){
        //            [QMUITips hideAllTipsInView: weakSelf.view];
        //            NSDictionary *dic = responder;
        //            if ([[dic  valueForKey:@"success"] boolValue] == YES) {
        //                [QMUITips showSucceed:@"登录成功" inView:weakSelf.view hideAfterDelay:0.6];
        //                if ([[SJYDefaultManager shareManager] isRemberPassword]) {
        //                    [[SJYDefaultManager shareManager] saveUserName:weakSelf.nameTF.text password:weakSelf.passwordTF.text];
        //                }
        //                [[SJYDefaultManager shareManager] saveEmployeeName:[dic valueForKey:@"employeeName"] Dt_Info:[dic valueForKey:@"dt"] EmployeeID:[dic valueForKey:@"employeeID"] DepartmentID:[dic valueForKey:@"departmentID"] PositionID:[dic valueForKey:@"positionID"]];
        //
        //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                    SJYMainViewController *mainVC = [[SJYMainViewController alloc] init];
        //                    [weakSelf.navigationController qmui_pushViewController:mainVC animated:YES completion:^{
        //                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //                        [delegate gotoMainVC];
        //                    }];
        //                });
        //            }else{
        //                [QMUITips showError:[dic valueForKey:@"infotype"] inView:weakSelf.view hideAfterDelay:1.5];
        //            }
        //        }];
    }];

    // 记住密码
    QMUIButton *remeberPasswordBtn = [[QMUIButton alloc] init];
    remeberPasswordBtn.spacingBetweenImageAndTitle = 15;
    [remeberPasswordBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [remeberPasswordBtn setTitleColor:Color_RGB_HEX(0x3d3d45, 1) forState:UIControlStateNormal];
    [remeberPasswordBtn setImage:SJYCommonImage(@"deselect") forState:UIControlStateNormal];
    [remeberPasswordBtn setImage:SJYCommonImage(@"select") forState:UIControlStateSelected];
    remeberPasswordBtn.titleLabel.font = [UIFont  boldSystemFontOfSize:SJYNUM(16)];
    //    remeberPasswordBtn.selected = [[SJYDefaultManager shareManager]isRemberPassword];
    [self.view addSubview:remeberPasswordBtn];
    self.remberPasswordBtn = remeberPasswordBtn;

    [remeberPasswordBtn clickWithBlock:^{
        remeberPasswordBtn.selected = !remeberPasswordBtn.selected;
        [[SJYDefaultManager shareManager]saveRemberPassword:remeberPasswordBtn.selected];

    }];
    // 版权所有
    QMUILabel *visionBelongLab = [[QMUILabel alloc]init];
    visionBelongLab.textAlignment = NSTextAlignmentCenter;
    visionBelongLab.numberOfLines = 0;
    visionBelongLab.font = [UIFont  systemFontOfSize:SJYNUM(16)];
    visionBelongLab.textColor = Color_RGB_HEX(0x3d3d45, 1);
    visionBelongLab.text =  @"版权: 常州正选科技有限公司";
    [self.view addSubview:visionBelongLab];

    [backImgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [visionBelongLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(SJYNUM(310));
        make.bottom.equalTo(self.view).offset(-15);
    }];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(120);
    }];

    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView);
        make.width.equalTo(80);
        make.height.equalTo(80);
    }];
    [imgView rounded:4];
    [nameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);//.offset(SJYNUM(20));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(SJYNUM(BackView_H));
        make.width.equalTo(SJYNUM(310));
    }];
    [nameView rounded:SJYNUM(BackView_H/2)];
    [nameTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView);
        make.centerX.equalTo(nameView.mas_centerX);
        make.left.equalTo(nameView.mas_left).offset(SJYNUM(BackView_H/2-TF_Padding_Left));
        make.bottom.equalTo(nameView);
    }];

    [passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(SJYNUM(20));
        make.centerX.equalTo(nameView.mas_centerX);
        make.height.equalTo(nameView.mas_height);
        make.width.equalTo(nameView.mas_width);
    }];
    [passwordView rounded:SJYNUM(BackView_H/2)];

    [passwordTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView);
        make.centerX.equalTo(passwordView.mas_centerX);
        make.left.equalTo(passwordView.mas_left).offset(SJYNUM(BackView_H/2-TF_Padding_Left));
        make.bottom.equalTo(passwordView);
    }];

    [remeberPasswordBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(SJYNUM(10));
        make.height.equalTo( 30);
        make.right.equalTo(self.view).offset(-SJYNUM(44));
    }];
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remeberPasswordBtn.mas_bottom).offset(SJYNUM(10));
        make.centerX.equalTo(passwordView.mas_centerX);
        make.height.equalTo(BackView_H);
        make.width.equalTo(passwordView.mas_width);
    }];
}

-(void)textFieldsDidChangeText:(UITextField *)textField{
    self.passwordTF.text = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameTF.text = [[SJYDefaultManager shareManager]getUserName];
    self.passwordTF.text = [[SJYDefaultManager shareManager]getPassword];
    self.remberPasswordBtn.selected = [[SJYDefaultManager shareManager]isRemberPassword];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog("Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
}


@end
