//
//  XMBGAlertContentView.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMBGAlertContentView.h"



@interface XMBGAlertContentView ()
 

@end
@implementation XMBGAlertContentView

-(QMUILabel *)xmbgTypeLab{
    if (!_xmbgTypeLab) {
        _xmbgTypeLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListOtherTxt numberOfLines:1];
        _xmbgTypeLab.text = @"变更类型:";
        [self addSubview:_xmbgTypeLab];
    }
    return _xmbgTypeLab;
}


-(QMUIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.imagePosition =  QMUIButtonImagePositionRight;
        [_typeBtn setTitleColor:Color_TEXT_NOMARL forState:UIControlStateDisabled];
        [_typeBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
         _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _typeBtn.titleLabel.font = Font_ListTitle;
        [_typeBtn setTitle:@"签证变更" forState:UIControlStateNormal];
        [self addSubview:_typeBtn];
    }
    return  _typeBtn;
}

-(QMUILabel *)xmbgDescriptLab{
    if (!_xmbgDescriptLab) {
        _xmbgDescriptLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListOtherTxt numberOfLines:1];
        _xmbgDescriptLab.text = @"变更描述:";
        [self addSubview:_xmbgDescriptLab];
    }
    return _xmbgDescriptLab;
}


-(QMUITextView *)xmbgDescriptTV{
    if (!_xmbgDescriptTV) {
        _xmbgDescriptTV = [[QMUITextView alloc] init];
        _xmbgDescriptTV.font = Font_ListTitle;
        _xmbgDescriptTV.maximumHeight = 10;
        _xmbgDescriptTV.placeholder = @"请输入变更描述";
         [_xmbgDescriptTV rounded:5 width:2 color:Color_LINE_NOMARL];
         [self addSubview:_xmbgDescriptTV];
    }
    return _xmbgDescriptTV;
}


-(QMUIButton *)fujianBtn{
    if (!_fujianBtn) {
        _fujianBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _fujianBtn.imagePosition =  QMUIButtonImagePositionLeft;
        _fujianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_fujianBtn setTitleColor:Color_TEXT_NOMARL forState:UIControlStateDisabled];
        [_fujianBtn setTitleColor:Color_TEXT_HIGH forState:UIControlStateNormal];
        _fujianBtn.titleLabel.font = Font_ListTitle;
        _fujianBtn.titleLabel.numberOfLines = 0;
        [self addSubview:_fujianBtn];
    }
    return _fujianBtn;
}
-(UIImageView *)fjImgView{
    if (!_fjImgView) {
        _fjImgView = [[UIImageView alloc] init];
        [self addSubview:_fjImgView];
    }
    return _fjImgView;
}

-(UIImageView *)rightTypeImgView{
    if (!_rightTypeImgView) {
        _rightTypeImgView = [[UIImageView alloc] init];
        _rightTypeImgView.image = SJYCommonImage(@"down");
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

-(void)setDetailModel:(XMBGDetailModel *)detailModel{
    _detailModel = detailModel;
    NSString *typeStr = detailModel.ChangeType.integerValue == 1 ? @"签证变更" : @"乙方责任";
    [self.typeBtn setTitle:typeStr forState:UIControlStateNormal];
    self.xmbgDescriptTV.text = detailModel.Remark;

    self.fujianBtn.hidden = !(detailModel.Url.lastPathComponent.length && [detailModel.Url.lastPathComponent containsString:@"."]) && !detailModel.isNewAdd;
    [self.fujianBtn setTitle:detailModel.Url.lastPathComponent forState:UIControlStateNormal];
    [self.fujianBtn setTitle:detailModel.Url.lastPathComponent forState:UIControlStateNormal];
    self.fjImgView.image = detailModel.isNewAdd?SJYCommonImage(@"addfj") : SJYCommonImage([NSString matchType:detailModel.Url.lastPathComponent]);

    self.typeBtn.enabled = detailModel.isNewAdd;
    self.xmbgDescriptTV.editable = detailModel.isNewAdd;
    self.xmbgDescriptTV.textColor = detailModel.isNewAdd?Color_TEXT_HIGH: Color_TEXT_NOMARL;
}

@end
