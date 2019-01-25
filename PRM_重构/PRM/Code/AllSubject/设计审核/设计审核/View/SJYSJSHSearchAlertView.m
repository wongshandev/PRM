//
//  SJYSJSHSearchAlertView.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYSJSHSearchAlertView.h"

@implementation SJYSJSHSearchAlertView


-(QMUILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
        _nameLab.text = @"项目名称:";
        [self addSubview:_nameLab];
    }
    return _nameLab;
}


-(QMUITextField *)nameTF{
    if (!_nameTF) {
        _nameTF = [[QMUITextField alloc] init];
        _nameTF.font = Font_ListTitle;
        _nameTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
        [self addSubview:_nameTF];
    }
    return _nameTF;
}
-(QMUILabel *)sepLineCode{
    if (!_sepLineCode) {
        _sepLineCode = [[QMUILabel alloc]init];
        _sepLineCode.backgroundColor =Color_SrprateLine;
        [self addSubview:_sepLineCode];

    }
    return _sepLineCode;
}
 
@end
