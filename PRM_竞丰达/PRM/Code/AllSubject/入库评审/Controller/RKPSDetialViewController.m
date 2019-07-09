//
//  RKPSDetialViewController.m
//  PRM
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RKPSDetialViewController.h"
#import "RKPSDetialView.h"
#import "RKPSApproveAlertView.h"

@interface RKPSDetialViewController ()
@property(nonatomic,strong)UIView *containerView;
//@property (nonatomic, strong) QMUILabel *titleLab;
@property(nonatomic,strong)RKPSApproveAlertView *approvelAlertView;

@end

@implementation RKPSDetialViewController


-(void)setUpNavigationBar{
    Weak_Self;
    self.navBar.titleLabel.text = self.title;
    [self.navBar.rightButton setTitle:@"审核" forState:UIControlStateNormal];
    self.navBar.rightButton.hidden = self.modelFrame.model.State > 2;
    [self.navBar.rightButton clickWithBlock:^{
        [weakSelf alertSHView];
    }];
}

-(void)buildSubviews{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.alwaysBounceVertical = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];

    UIView *containerView = [UIView  new];
    [scrollView addSubview:containerView];
    self.containerView = containerView;

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {  make.edges.mas_equalTo(self.view).offset(UIEdgeInsetsMake(self.navBar.height, 0, 0, 0));
    }]; 
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
     }];

    RKPSDetialView *view = [[RKPSDetialView alloc]init];
    [containerView addSubview:view];
    view.modelFrame = self.modelFrame;
    [containerView layoutIfNeeded];
 }



-(void)alertSHView{
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];

    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.footerSeparatorColor = UIColorClear;
    dialogViewController.headerSeparatorColor = UIColorClear;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
     dialogViewController.headerViewHeight  = 10;
    dialogViewController.footerViewHeight  = 40;

    self.approvelAlertView = [[RKPSApproveAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W - 15*2, 250)];
    self.approvelAlertView.backgroundColor = UIColorWhite;

    dialogViewController.contentView = self.approvelAlertView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        NSString *content =  [self.approvelAlertView.bzTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ((self.approvelAlertView.state == RKPSApproveState_FD  ||  self.approvelAlertView.state == RKPSApproveState_QQ ) && content.length == 0) {
//     if ((self.approvelAlertView.state == 2  ||  self.approvelAlertView.state == 4 ) && content.length == 0) {
            NSString *mention = [[@"请输入"  stringByAppendingString:self.approvelAlertView.bzMenLab.text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]];
            [QMUITips showWithText:mention inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            [self.approvelAlertView.bzTV becomeFirstResponder];
            return ;
        }
        [self.approvelAlertView.bzTV endEditing:YES];
        [QMUITips showLoading:@"数据传输中" inView:[UIApplication sharedApplication].keyWindow];
        [SJYRequestTool requestRKPSApprovelSubmitWithParaDic: @{
                                                                @"stIds":self.modelFrame.model.Id,
                                                                @"State":@(self.approvelAlertView.state),
                                                                @"Remark":content
                                                                } success:^(id responder) {
                                                                    [QMUITips hideAllTips];
                                                                    if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                        [modalViewController hideInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];

                                                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshRKPSListView" object:nil];
                                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                        });
                                                                    }else{
                                                                        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                    }
                                                                } failure:^(int status, NSString *info) {
                                                                    [QMUITips hideAllTips];
                                                                    [QMUITips showError:info inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
                                                                }];

    }];
    modalViewController.contentViewController = dialogViewController;
    [modalViewController showInView:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}















@end
