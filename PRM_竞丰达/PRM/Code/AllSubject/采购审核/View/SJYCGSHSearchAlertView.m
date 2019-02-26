//
//  SJYBGSHSearchAlertView.m
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYCGSHSearchAlertView.h"

@implementation SJYCGSHSearchAlertView

-(QMUILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
        _stateLab.text = @"状       态:";
        [self addSubview:_stateLab];
    }
    return _stateLab;
}


-(QMUIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _stateBtn.imagePosition =  QMUIButtonImagePositionRight;
        [_stateBtn setTitleColor:Color_TEXT_NOMARL forState:UIControlStateDisabled];
        [_stateBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
        _stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _stateBtn.titleLabel.font = Font_ListTitle;
        [_stateBtn setTitle:@"未审核" forState:UIControlStateNormal];
        [self addSubview:_stateBtn];
    }
    return  _stateBtn;
}
-(UIImageView *)rightdownImgView{
    if (!_rightdownImgView) {
        _rightdownImgView = [[UIImageView alloc] init];
        [self addSubview:_rightdownImgView];
    }
    return _rightdownImgView;
}
-(QMUILabel *)codeLab{
    if (!_codeLab) {
        _codeLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
        _codeLab.text = @"编       号:";
        [self addSubview:_codeLab];
    }
    return _codeLab;
}


-(QMUITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [[QMUITextField alloc] init];
        _codeTF.font = Font_ListTitle;
        _codeTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
        [self addSubview:_codeTF];
    }
    return _codeTF;
}

-(QMUILabel *)sepLine{
    if (!_sepLine) {
        _sepLine = [[QMUILabel alloc]init];
        _sepLine.backgroundColor = Color_SrprateLine;
        [self addSubview:_sepLine];
        
    }
    return _sepLine;
}


-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}
@end
