//
//  SJYLoginViewController.m
//  PRM
//
//  Created by apple on 2019/3/4.
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
    self.navBar.backView.backgroundColor = Color_Clear;
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
-(void)visionCheckFromAppStore{
         [SJYRequestTool checkUpdateWithAppID:@"1453354285" complete:^(BOOL isHaveNewVision, NSString *newVisionMessage, NSString *newVersion, NSString *newVisionURL) {
            if (!isHaveNewVision) {
                return;
            }
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新版本%@啦",newVersion ] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:newVisionMessage attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:[self paragraphAlignment] }];
            [alertVC setValue:messageString forKey:@"attributedMessage"];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"马上尝鲜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:newVisionURL]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVisionURL]];
                }
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
 }
//版本更新检测
//-(void)visionCheckFromAppStore{
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/lookup?id=1453354285"]];
//    NSError *error;
//    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    if (error) {
//        return;
//    }
//    NSInteger resultCount = [[resultDic objectForKey:@"resultCount"] integerValue];
//    NSDictionary *appStorInfoDic = [[resultDic objectForKey:@"results"] firstObject];
//    if (error == nil  && resultCount ) {
//        NSString *appVisionInfo = [appStorInfoDic valueForKey:@"version"];
//        //获取本地的版本号
//        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
//        if (![appVisionInfo isEqualToString:currentVersion]) {
//            NSString *message = appStorInfoDic[@"releaseNotes"];
//            NSString *trackViewUrl = appStorInfoDic[@"trackViewUrl"];
//
//            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新版本%@啦",appVisionInfo] message:@"" preferredStyle:UIAlertControllerStyleAlert];
//            NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:[self paragraphAlignment] }];
//            [alertVC setValue:messageString forKey:@"attributedMessage"];
//            [alertVC addAction:[UIAlertAction actionWithTitle:@"马上尝鲜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:trackViewUrl]]) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
//                }
//            }]];
//            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
//            [self presentViewController:alertVC animated:YES completion:nil];
//        }
//    }
//}
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
    imgView.image = SJYCommonImage(@"zxlogo");
    [topView addSubview:imgView];

    //FIXME: 手机号码

    UIView *nameView = [[UIView alloc]init];
    nameView.backgroundColor = UIColorClear;
    [self.view addSubview:nameView];

    UIImageView *nameImgView = [[UIImageView alloc] init];
    nameImgView.image = SJYCommonImage(@"username");
    [nameView addSubview:nameImgView];

    QMUITextField *nameTF = [[QMUITextField alloc] init];
    nameTF.font = SJYFont(16);
    nameTF.borderStyle = UITextBorderStyleNone;
    nameTF.placeholder = @"用户名";
    nameTF.placeholderColor = Color_TEXT_WEAK;
    [nameView addSubview: nameTF];
    [nameTF addTarget:self action:@selector(textFieldsDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    self.nameTF = nameTF;

    QMUILabel *nameSepLine = [[QMUILabel alloc]init];
    nameSepLine.backgroundColor = Color_SrprateLine;
    [nameView addSubview: nameSepLine];


    //FIXME:密码
    UIView *passwordView = [[UIView alloc]init];
    passwordView.backgroundColor = UIColorClear;
    [self.view addSubview:passwordView];

    UIImageView *passImgView = [[UIImageView alloc] init];
    passImgView.image = SJYCommonImage(@"mm");
    [passwordView addSubview:passImgView];

    QMUITextField *passwordTF = [[QMUITextField alloc] init];
    passwordTF.font = SJYFont(16);
    passwordTF.borderStyle = UITextBorderStyleNone;
    passwordTF.secureTextEntry = YES;
    passwordTF.placeholder = @"密码";
    passwordTF.placeholderColor = Color_TEXT_WEAK;
    [passwordView addSubview: passwordTF];
    self.passwordTF = passwordTF;

    QMUILabel *passSepLine = [[QMUILabel alloc]init];
    passSepLine.backgroundColor = Color_SrprateLine;
    [passwordView addSubview: passSepLine];

   //FIXME: 登录
    QMUIFillButton *loginBtn = [[QMUIFillButton alloc] init];
    loginBtn.fillColor =Color_NavigationLightBlue; //Color_RGB_HEX(0x22cc65, 1);
    [loginBtn setTitle:@"登        录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont  boldSystemFontOfSize:SJYNUM(18)];
    [self.view addSubview:loginBtn];
    [loginBtn clickWithBlock:^{
        [weakSelf.view endEditing:YES];
        if (IP_Address.length==0 || IP_Port.length==0) {
//            [QMUITips showError:nil detailText:[DisplayName stringByAppendingString: @"  :请点击右上角,设置服务器IP地址及端口"] inView:weakSelf.viewhideAfterDelay:1.3];
            [QMUITips showWithText:DisplayName detailText:@"请点击右上角 , 设置服务器IP地址及端口" inView:weakSelf.view hideAfterDelay:3];
            return;
        }
        if (weakSelf.nameTF.text.length == 0) {
            [QMUITips showWithText:@"请输入用户名" inView:weakSelf.view
                    hideAfterDelay:1.3];
            return ;
        }
        if (weakSelf.passwordTF.text.length == 0) {
            [QMUITips showWithText:@"请输入密码" inView:weakSelf.view
                    hideAfterDelay:1.3];
            return ;
        }
        [QMUITips showLoading:@"正在登录,请稍后..." inView:weakSelf.view];
        [SJYRequestTool loginInfoWithUserName:weakSelf.nameTF.text passworld:weakSelf.passwordTF.text success:^(LoginModel *loginInfo) {
            [QMUITips hideAllTipsInView: weakSelf.view];
            [SJYUserManager sharedInstance].loginModel= loginInfo;
            [[SJYUserManager sharedInstance]updateLoginModel];

            //
            [SJYUserManager sharedInstance].sjyloginUC= loginInfo.uc;
            [[SJYUserManager sharedInstance] updateLoginUC];

            [SJYUserManager sharedInstance].ucAemp= loginInfo.ucAemp;
            [[SJYUserManager sharedInstance] updateUcAemp];

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
    }];

    //FIXME: 记住密码
    QMUIButton *remeberPasswordBtn = [[QMUIButton alloc] init];
    remeberPasswordBtn.spacingBetweenImageAndTitle = 15;
    [remeberPasswordBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [remeberPasswordBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
    [remeberPasswordBtn setImage:[SJYCommonImage(@"deselect_login") imageByTintColor:Color_TEXT_NOMARL] forState:UIControlStateNormal];
    [remeberPasswordBtn setImage:[SJYCommonImage(@"select_login") imageByTintColor:Color_NavigationLightBlue] forState:UIControlStateSelected];
    remeberPasswordBtn.titleLabel.font = [UIFont  boldSystemFontOfSize:SJYNUM(14)];
    //    remeberPasswordBtn.selected = [[SJYDefaultManager shareManager]isRemberPassword];
    [self.view addSubview:remeberPasswordBtn];
    self.remberPasswordBtn = remeberPasswordBtn;

    [remeberPasswordBtn clickWithBlock:^{
        remeberPasswordBtn.selected = !remeberPasswordBtn.selected;
        [[SJYDefaultManager shareManager]saveRemberPassword:remeberPasswordBtn.selected];

    }];

    //FIXME: 版权所有
    QMUILabel *visionBelongLab = [[QMUILabel alloc]init];
    visionBelongLab.textAlignment = NSTextAlignmentCenter;
    visionBelongLab.hidden = YES;
    visionBelongLab.numberOfLines = 0;
    visionBelongLab.font = [UIFont  systemFontOfSize:SJYNUM(14)];
    visionBelongLab.textColor = Color_TEXT_NOMARL;
    NSString *belong = [SJYDefaultManager.shareManager getSoftwareBelong];
    if (belong == nil || belong.length == 0) {
        belong = @"常州正选软件科技有限公司";
        [SJYDefaultManager.shareManager saveSoftwareBelong:belong];
    }
    NSString *belongstr = [NSString stringWithFormat:@"Copyright © %ld ",(long)[NSDate date].year];
//    visionBelongLab.text =  [@"版权所有: " stringByAppendingString:belong];
    visionBelongLab.text =  [belongstr stringByAppendingString:belong];

    [self.view addSubview:visionBelongLab];

    [backImgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(150);
    }];

    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(topView).offset(15);
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

    [nameImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView.mas_centerY);
        make.left.equalTo(nameView);
        make.width.mas_equalTo(SJYNUM(25));
        make.height.mas_equalTo(SJYNUM(25));
    }];

    [nameTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView);
        make.left.equalTo(nameImgView.mas_right);
        make.right.equalTo(nameView.mas_right);
        make.bottom.equalTo(nameView);
    }];
    [nameSepLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameView.mas_centerX);
        make.width.equalTo(nameView);
        make.bottom.equalTo(nameView.mas_bottom);
        make.height.equalTo(2);
    }];

    [passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(SJYNUM(20));
        make.centerX.equalTo(nameView.mas_centerX);
        make.height.equalTo(nameView.mas_height);
        make.width.equalTo(nameView.mas_width);
    }];

    [passImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordView.mas_centerY);
        make.left.equalTo(passwordView);
        make.width.mas_equalTo(SJYNUM(25));
        make.height.mas_equalTo(SJYNUM(25));
    }];

    [passwordTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView);
        make.left.equalTo(passImgView.mas_right);
        make.right.equalTo(passwordView.mas_right);
        make.bottom.equalTo(passwordView);
    }];
    [passSepLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(passwordView.mas_centerX);
        make.width.equalTo(passwordView);
        make.bottom.equalTo(passwordView.mas_bottom);
        make.height.equalTo(2);
    }];
    [remeberPasswordBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(SJYNUM(10));
        make.height.equalTo(30);
        //        make.right.equalTo(self.view).offset(-SJYNUM(44));
        make.left.equalTo(passwordView.mas_left);
    }];
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remeberPasswordBtn.mas_bottom).offset(SJYNUM(10));
        make.centerX.equalTo(passwordView.mas_centerX);
        make.height.equalTo(BackView_H);
        make.width.equalTo(passwordView.mas_width);
    }];
    [visionBelongLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(SJYNUM(310));
        //        make.top.equalTo(self.view.mas_bottom).offset(-15);
        make.top.equalTo(loginBtn.mas_bottom).offset(50);
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
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
}

@end
