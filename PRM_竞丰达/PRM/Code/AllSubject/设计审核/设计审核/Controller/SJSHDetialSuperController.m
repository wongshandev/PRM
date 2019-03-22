//
//  SJSHDetialSuperController.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJSHDetialSuperController.h"

#import "BJQDListViewController.h"
#import "WJQDListViewController.h"
#import "GCJDListViewController.h"

@interface SJSHDetialSuperController ()<ZJScrollPageViewDelegate,QMUITextViewDelegate>
@property(nonatomic,strong)ZJScrollPageView *pageScrollView;
@property(nonatomic,strong)NSArray *titles;

@property(nonatomic,strong)QMUIButton *rejectBtn;
@property(nonatomic,strong)QMUIButton *agreeBtn; 
@end

@implementation SJSHDetialSuperController 

-(void)setUpNavigationBar{
    //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    [self createSaveagreeBtn];
}
-(void)createSaveagreeBtn{
    if(!self.sjshListModel.isCanSH ){
        return;
    }
    Weak_Self;
    QMUIButton *rejectBt = [[QMUIButton  alloc]init];
    [rejectBt setTitle:@"驳回" forState:UIControlStateNormal];
    [rejectBt setTitleColor:Color_White forState:UIControlStateNormal];
    rejectBt.titleLabel.font = Font_System(16);
    [self.navBar addSubview:rejectBt];
    self.rejectBtn = rejectBt;
    [self.rejectBtn clickWithBlock:^{
        [weakSelf alertRejectView];
    }];
    
    QMUIButton *agreeBt = [QMUIButton  buttonWithType:UIButtonTypeCustom];
    [agreeBt setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBt setTitleColor:Color_White forState:UIControlStateNormal];
    agreeBt.titleLabel.font = Font_System(16);
    [self.navBar addSubview:agreeBt];
    self.agreeBtn = agreeBt;
    [self.agreeBtn clickWithBlock:^{
        [weakSelf alertAgreeView];
    }];
    [self.rejectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.navBar.mas_right).offset(-10);
        make.height.equalTo(44);
        make.width.equalTo(45);
    }];
    [self.agreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self.rejectBtn.mas_left);
        make.height.equalTo(44);
        make.width.equalTo(45);
    }];
    [self.navBar.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navBar.rightButton.mas_left).offset(-SJYNUM(56));
    }];
}
-(void)buildSubviews{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.titleFont= Font_ListTitle;
    style.showLine = YES;
    style.scrollTitle= NO;
    style.autoAdjustTitlesWidth= YES;
    style.adjustCoverOrLineWidth= YES;
    //style.adjustCoverOrLineWidth= YES;
    style.segmentHeight=SJYNUM(44);
    style.scrollLineHeight=SJYNUM(3);
    style.scrollLineColor=Color_NavigationLightBlue;
    style.normalTitleColor=Color_TEXT_HIGH;
    style.selectedTitleColor=Color_NavigationLightBlue;
    style.contentViewBounces = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    // 初始化
    self.pageScrollView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.navBar.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navBar.height) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:self.pageScrollView];
}

#pragma mark ======================= 数据绑定

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (index == 0) {
        BJQDListViewController*bjqdVC = [[BJQDListViewController alloc] init];
        bjqdVC.sjshListModel = self.sjshListModel;
        childVc = bjqdVC;
    }else if(index == self.titles.count - 1) {//最右侧
        GCJDListViewController*gcjdVC = [[GCJDListViewController alloc] init];
        gcjdVC.sjshListModel = self.sjshListModel;
        childVc = gcjdVC;
    }else{
        WJQDListViewController*wjqdVC = [[WJQDListViewController alloc] init];
        wjqdVC.sjshListModel = self.sjshListModel;
        childVc = wjqdVC;
    }
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    
}
-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"报价清单",@"文件清单",@"工程进度"];
    }
    return _titles;
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


-(void)alertAgreeView{
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"提醒";
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
    contentView.backgroundColor = UIColorWhite;
    QMUILabel *label = [[QMUILabel alloc] init];
    label.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    label.font = Font_ListTitle;
    label.textColor = Color_TEXT_NOMARL;
    label.text = @"确定审核通过吗?";
    label.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [SJYRequestTool requestSJSHWithAPI:API_SJSH_SH parameters:@{
                                                                    @"AEmp":[[SJYUserManager sharedInstance].sjyloginUC   modelToJSONString],
                                                                    @"DeepenDesignID":self.sjshListModel.Id,
                                                                    @"EmployeeID":[SJYUserManager sharedInstance].sjyloginUC.Id,
                                                                    @"State":@"7",
                                                                    @"InquiryId":[SJYUserManager sharedInstance].sjyloginUC.InquiryId//(驳回时必要回传参数)
                                                                    } success:^(id responder) {
                                                                        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                                                                        if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJSHListView" object:nil];
                                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                            });
                                                                        }
                                                                    } failure:^(int status, NSString *info) {
                                                                        [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
                                                                    }];
        
        [aDialogViewController hide];
    }];
    [dialogViewController show];
}

-(void)alertRejectView{
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"请输入驳回理由";
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    contentView.backgroundColor = UIColorWhite;
    
    QMUILabel *mentionLabel = [[QMUILabel alloc] init];
    [contentView addSubview:mentionLabel];
    mentionLabel.textColor = Color_TEXT_HIGH;
    mentionLabel.font = Font_ListTitle;
    mentionLabel.text = @"驳回至 : ";
    
    UIImageView *rightdownImgView = [[UIImageView alloc] init];
    rightdownImgView.image = SJYCommonImage(@"downBlack");
    [contentView addSubview:rightdownImgView];
    
    QMUIButton *typeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
    [typeBtn setTitle:@"合同" forState:UIControlStateNormal];
    [typeBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
    typeBtn.titleLabel.font = Font_ListTitle;
    [contentView addSubview:typeBtn];
    
    
    QMUITextView *textView = [[QMUITextView alloc] init];
    [contentView addSubview:textView];
    textView.shouldResponseToProgrammaticallyTextChanges = YES;
    textView.shouldCountingNonASCIICharacterAsTwo = YES;
    textView.font = Font_ListTitle;
    textView.delegate = self;
    textView.maximumTextLength = 64;
    textView.maximumHeight = 90;
    textView.placeholder = @"请输入(限32字)";

    [typeBtn clickWithBlock:^{
        [textView endEditing:YES];
        [BRStringPickerView showStringPickerWithTitle:@"驳回至" dataSource:@[@"合同",@"深化设计"] defaultSelValue:typeBtn.currentTitle isAutoSelect:NO themeColor:Color_NavigationLightBlue resultBlock:^(id selectValue) {
            [typeBtn setTitle:selectValue forState:UIControlStateNormal];
        }];
    }];
    
    [mentionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(5);
        make.left.mas_equalTo(contentView.mas_left).offset(10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
    }];
    [typeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(5);
        make.left.mas_equalTo(mentionLabel.mas_right).offset(5);
        make.right.mas_equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(mentionLabel.mas_height);
    }];
    [rightdownImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(typeBtn.mas_centerY);
        make.right.mas_equalTo(typeBtn.mas_right);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(20);
    }];
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mentionLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(mentionLabel.mas_left);
        make.right.mas_equalTo(typeBtn.mas_right);
        make.bottom.mas_equalTo(contentView.mas_bottom).offset(-5);
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [textView endEditing:YES];
        NSString *content =  [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; 
        if (content.length == 0) {
            [QMUITips showInfo:@"请输入驳回理由" inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.2];
            return ;
        }
        [SJYRequestTool requestSJSHWithAPI:API_SJSH_SH parameters:@{
                                                                    @"AEmp":[[SJYUserManager sharedInstance].sjyloginUC   modelToJSONString],
                                                                    @"DeepenDesignID":self.sjshListModel.Id,
                                                                    @"EmployeeID":[SJYUserManager sharedInstance].sjyloginUC.Id,
                                                                    @"State":[typeBtn.currentTitle isEqualToString:@"合同"]?@"0":@"3",
                                                                    @"RejectReason":content//(驳回时必要回传参数)
                                                                    } success:^(id responder) {
                                                                        [aDialogViewController hide];
                                                                        [QMUITips showWithText:[responder valueForKey:@"msg"] inView:self.view hideAfterDelay:1.2];
                                                                        if ([[responder valueForKey:@"success"] boolValue]== YES) {
                                                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSJSHListView" object:nil];
                                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                            });
                                                                        }
                                                                        
                                                                    } failure:^(int status, NSString *info) {
                                                                        [QMUITips showError:info inView:self.view hideAfterDelay:1.2];
                                                                        [aDialogViewController hide];
                                                                        
                                                                    }];
        
    }];
    [dialogViewController show];
    //    [textView becomeFirstResponder];
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (([text isEqualToString:@"\n"] || [text isEqualToString:@" "]) && textView.text.length == 0) {
//        return NO;
//    }
//    return YES;
//}
@end
