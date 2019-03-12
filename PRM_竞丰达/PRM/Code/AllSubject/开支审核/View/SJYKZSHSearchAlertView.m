//
//  SJYKZSHSearchAlertView.m
//  PRM
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYKZSHSearchAlertView.h"

@implementation SJYKZSHSearchAlertView
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
-(UIImageView *)rightStateImgView{
    if (!_rightStateImgView) {
        _rightStateImgView = [[UIImageView alloc] init];
        [self addSubview:_rightStateImgView];
    }
    return _rightStateImgView;
}
-(QMUILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
        _typeLab.text = @"类       型:";
        [self addSubview:_typeLab];
    }
    return _typeLab;
}
-(QMUIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.imagePosition =  QMUIButtonImagePositionRight;
        [_typeBtn setTitleColor:Color_TEXT_NOMARL forState:UIControlStateDisabled];
        [_typeBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
        _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _typeBtn.titleLabel.font = Font_ListTitle;
        [_typeBtn setTitle:@"全部" forState:UIControlStateNormal];
        [self addSubview:_typeBtn];
    }
    return  _typeBtn;
}
-(UIImageView *)rightTypeImgView{
    if (!_rightTypeImgView) {
        _rightTypeImgView = [[UIImageView alloc] init];
        [self addSubview:_rightTypeImgView];
    }
    return _rightTypeImgView;
}


-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}

@end
