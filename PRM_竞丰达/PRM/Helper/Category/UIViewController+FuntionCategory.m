//
//  UIViewController+FuntionCategory.m
//  PRM
//
//  Created by apple on 2019/3/1.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "UIViewController+FuntionCategory.h"

@implementation UIViewController (FuntionCategory)

-(void)alertWithSaveMention:(NSString *)message withAction:(SEL)action{
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"提醒";

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
    contentView.backgroundColor = UIColorWhite;
    QMUILabel *label = [[QMUILabel alloc] init];
    label.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    label.font = Font_ListTitle;
    label.textColor = Color_TEXT_NOMARL;
    label.text = message;
    label.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).offset(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:^(__kindof QMUIDialogViewController *aDialogViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        if ([self respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Warc-performSelector-leaks"
            [self performSelector:action];
#pragma clang diagnostic pop
        }
        [aDialogViewController hide];
    }];
    [dialogViewController show];
}
@end
