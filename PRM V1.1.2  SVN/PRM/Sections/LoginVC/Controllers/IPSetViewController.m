//
//  IPSetViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/7.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "IPSetViewController.h"

@interface IPSetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *ipPortTF;

@end

@implementation IPSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BOOL isFirst = [[UserDefaultManager shareUserDefaultManager]getFirstRun];
    if (isFirst) {
        self.ipAddressTF.text = @"";
        self.ipPortTF.text = @"";
    } else {
        self.ipAddressTF.text = [[UserDefaultManager shareUserDefaultManager]getIPAddress];
        self.ipPortTF.text = [[UserDefaultManager shareUserDefaultManager] getIPPort];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)frontPageView:(UIBarButtonItem *)sender {
    [self.ipPortTF endEditing:YES];
    [self.ipAddressTF endEditing:YES];
    if (self.ipAddressTF.text.length!= 0 && self.ipPortTF.text.length != 0){
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self showMessageLabel:@"地址或端口信息不完善"withBackColor:kGeneralColor_lightCyanColor];
    }
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self.ipPortTF endEditing:YES];
    [self.ipAddressTF endEditing:YES];
    if (self.ipAddressTF.text.length!= 0 && self.ipPortTF.text.length != 0){
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self showMessageLabel:@"地址或端口信息不完善"withBackColor:kGeneralColor_lightCyanColor];
    }
}
- (IBAction)saveButtonAction:(UIButton *)sender {
    [self showProgressHUD];
    [self.ipPortTF endEditing:YES];
    [self.ipAddressTF endEditing:YES];    if (self.ipAddressTF.text.length!= 0 && self.ipPortTF.text.length != 0) {
        [[UserDefaultManager shareUserDefaultManager] saveIPAddress:self.ipAddressTF.text IPPort:self.ipPortTF.text];
        [self hideProgressHUD];
        [self showMessageLabel:@"保存完成"withBackColor:kGeneralColor_lightCyanColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    }else{
        [self hideProgressHUD];
        [self showMessageLabel:@"地址或端口信息不完善"withBackColor:kGeneralColor_lightCyanColor];
    }
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
