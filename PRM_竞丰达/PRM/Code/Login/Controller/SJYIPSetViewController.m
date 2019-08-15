//
//  SJYIPSetViewController.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//
#include <netinet/in.h>
#import "SJYIPSetViewController.h"
#define BackView_H 44
#define TF_Padding_Left 7


@interface SJYIPSetViewController ()
@property (strong, nonatomic)QMUITextField *ipAddressTF;
@property (strong, nonatomic)QMUITextField *ipPortTF;

@end

@implementation SJYIPSetViewController


-(void)viewWillAppear:(BOOL)animated{
    BOOL isFirst = [[SJYDefaultManager shareManager]getFirstRun];
    if (isFirst) {
        self.ipAddressTF.text = @"";
        self.ipPortTF.text = @"";
    } else {
        self.ipAddressTF.text = [[SJYDefaultManager shareManager] getIPAddress];
        self.ipPortTF.text = [[SJYDefaultManager shareManager] getIPPort];
    }
}

- (void)setUpNavigationBar{
    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = @"服务器IP地址和端口设置";
}


-(void)buildSubviews{
    Weak_Self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //IP提示
    UILabel *ipAddressLab = [[UILabel alloc] init];
    ipAddressLab.font = SJYFont(16);
    ipAddressLab.textColor =Color_TEXT_HIGH;
    ipAddressLab.text = @"IP地址:";
    [self.view addSubview:ipAddressLab];
    //IP 格式提示
    UILabel *ipMenLab = [[UILabel alloc] init];
    ipMenLab.numberOfLines = 0;
    ipMenLab.font = SJYFont(14);
    ipMenLab.textColor =Color_Gray;
    ipMenLab.text = @"(格式：222.222.222.222，每个数字在0-255，第一个数字不能是0，最后一个数字不能是0或255)";
    [self.view addSubview:ipMenLab];

    // IP 地址
    UIView *addressView = [[UIView alloc]init];
    addressView.backgroundColor = UIColorClear;
    [self.view addSubview:addressView];

    QMUITextField *addressTF = [[QMUITextField alloc] init];
    addressTF.font = SJYFont(16);
    addressTF.keyboardType = UIKeyboardTypeDecimalPad;
    addressTF.borderStyle = UITextBorderStyleNone;
    addressTF.placeholder = IP_Default_Address;
    addressTF.placeholderColor =Color_TEXT_WEAK;
    [addressView addSubview: addressTF];
    self.ipAddressTF = addressTF;

    QMUILabel *ipSepLine = [[QMUILabel alloc]init];
    ipSepLine.backgroundColor = Color_Gray;
    [addressView addSubview: ipSepLine];


    //端口提示
    UILabel *ippotLab = [[UILabel alloc] init];
    ippotLab.text = @"端   口:";
    ippotLab.font = SJYFont(16);
    ippotLab.textColor =Color_TEXT_HIGH;
    [self.view addSubview:ippotLab];
    //端口 格式提示
    UILabel *ippotMenLab = [[UILabel alloc] init];
    ippotMenLab.font = SJYFont(14);
    ippotMenLab.numberOfLines = 0;
    ippotMenLab.textColor =Color_Gray;
    ippotMenLab.text = @"(格式：1-65535)";
    [self.view addSubview:ippotMenLab];
    //  IP端口
    UIView *ippotView = [[UIView alloc]init];
    ippotView.backgroundColor = UIColorClear;
    [self.view addSubview:ippotView];

    QMUITextField *ipportTF = [[QMUITextField alloc] init];
     ipportTF.font = SJYFont(16);
    ipportTF.keyboardType = UIKeyboardTypeNumberPad;
    ipportTF.borderStyle = UITextBorderStyleNone;
    ipportTF.placeholder = IP_Default_Port;
    ipportTF.placeholderColor = Color_TEXT_WEAK;
    [ippotView addSubview: ipportTF];
    self.ipPortTF = ipportTF;

    QMUILabel *portSepLine = [[QMUILabel alloc]init];
    portSepLine.backgroundColor = Color_Gray;
    [ippotView addSubview: portSepLine];
    // 登录
    QMUIFillButton *saveBtn = [[QMUIFillButton alloc] init];
    saveBtn.fillColor =Color_NavigationLightBlue; //Color_RGB_HEX(0x22cc65, 1);
    [saveBtn setTitle:@"保        存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont  boldSystemFontOfSize:SJYNUM(18)];
    [self.view addSubview:saveBtn];
    [saveBtn clickWithBlock:^{
        [weakSelf.view endEditing:YES];
        if (weakSelf.ipAddressTF.text.length == 0) {
            [QMUITips showWithText:@"请输入IP地址" inView:weakSelf.view  hideAfterDelay:1.3];
            return ;
        }
        if ( weakSelf.ipPortTF.text.length == 0) {
            [QMUITips showWithText:@"请输入端口" inView:weakSelf.view  hideAfterDelay:1.3];
            return ;
        }
        if (![weakSelf isValidatIPaddress:weakSelf.ipAddressTF.text] || ![weakSelf isValidatIPport:weakSelf.ipPortTF.text]) {
            [QMUITips showError:@"IP地址格式或端口格式不正确,请重新输入" inView:weakSelf.view  hideAfterDelay:3];
            return;
        }


        [QMUITips showSucceed:@"保存成功" inView:weakSelf.view  hideAfterDelay:1.0];
        [[SJYDefaultManager shareManager] saveIPAddress:weakSelf.ipAddressTF.text IPPort:weakSelf.ipPortTF.text];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];

    [ipAddressLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.navBar.height +10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(20);
        make.width.equalTo(SJYNUM(310));
    }];
    [ipMenLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ipAddressLab.mas_bottom).offset(SJYNUM(5));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(SJYNUM(310));
    }];
    [addressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ipMenLab.mas_bottom).offset(SJYNUM(10));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(SJYNUM(BackView_H));
        make.width.equalTo(SJYNUM(310));
    }];
//    [addressView rounded:SJYNUM(BackView_H/2)];
    [addressTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView);
        make.centerX.equalTo(addressView.mas_centerX);
        make.left.equalTo(addressView.mas_left);
        make.bottom.equalTo(addressView);
    }];
    [ipSepLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addressView.mas_centerX);
        make.width.equalTo(addressView);
        make.bottom.equalTo(addressView.mas_bottom);
        make.height.equalTo(2);
    }];
    [ippotLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(SJYNUM(10));
        make.centerX.equalTo(addressView.mas_centerX);
        make.height.equalTo(SJYNUM(20));
        make.width.equalTo(addressView.mas_width);
    }];
    [ippotMenLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ippotLab.mas_bottom).offset(SJYNUM(5));
        make.centerX.equalTo(addressView.mas_centerX);
        make.width.equalTo(addressView.mas_width);
    }];
    [ippotView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ippotMenLab.mas_bottom).offset(SJYNUM(10));
        make.centerX.equalTo(addressView.mas_centerX);
        make.height.equalTo(addressView.mas_height);
        make.width.equalTo(addressView.mas_width);
    }];
//    [ippotView rounded:SJYNUM(BackView_H/2)];

    [ipportTF makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ippotView);
        make.centerX.equalTo(ippotView.mas_centerX);
        make.left.equalTo(ippotView.mas_left);
        make.bottom.equalTo(ippotView);
    }];
    [portSepLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ippotView.mas_centerX);
        make.width.equalTo(ippotView);
        make.bottom.equalTo(ippotView.mas_bottom);
        make.height.equalTo(2);
    }];
    [saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ippotView.mas_bottom).offset(SJYNUM(20));
        make.centerX.equalTo(ippotView.mas_centerX);
        make.height.equalTo(BackView_H);
        make.width.equalTo(ippotView.mas_width);
    }];
}

- (BOOL)isValidatIPaddress:(NSString *)ipAddress{
//    return [NSString isAvailableStr:ipAddress WithFormat:
//            @"^([1-9]|[1-9]\\d|1\\d\\d|2[0-4]\\d|25[0-5])\\."
//            "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
//            "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
//            "([1-9]|[1-9]\\d|1\\d1\\d|2[0-4]\\d|25[0-4])$"];
    return [NSString isAvailableStr:ipAddress WithFormat: IPFormattor];
}

- (BOOL)isValidatIPport:(NSString *)ipport {
    return ipport.intValue >= 1 && ipport.intValue <= 0xFFFF && ipport.length > 0 && ![ipport hasPrefix:@"0"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     printf("Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
}
@end
