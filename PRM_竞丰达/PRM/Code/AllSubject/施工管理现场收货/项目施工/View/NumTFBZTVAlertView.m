//
//  XMBGAlertContentView.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "NumTFBZTVAlertView.h"

@interface NumTFBZTVAlertView ()
 

@end
@implementation NumTFBZTVAlertView
-(QMUILabel *)numMentionLab{
    if (!_numMentionLab) {
        _numMentionLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
         [self addSubview:_numMentionLab];
    }
    return _numMentionLab;
}
-(QMUITextField *)numTF{
    if (!_numTF) {
        _numTF = [[QMUITextField alloc] init];
        _numTF.font = Font_ListTitle;
        _numTF.textInsets = UIEdgeInsetsMake(0, 0, 0, _numTF.qmui_clearButton.width);
        _numTF.keyboardType = UIKeyboardTypeNumberPad;
        _numTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
//        _numTF.borderStyle = UITextBorderStyleNone;
//        _numTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_numTF];
    }
    return _numTF;
}
-(QMUILabel *)bzMentionLab{
    if (!_bzMentionLab) {
        _bzMentionLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
        _bzMentionLab.text = @"备注:";
        [self addSubview:_bzMentionLab];
    }
    return _bzMentionLab;
}
-(QMUILabel *)sepLine{
    if (!_sepLine) {
        _sepLine = [[QMUILabel alloc]init];
        _sepLine.backgroundColor = Color_SrprateLine;
        [self addSubview:_sepLine];
    }
    return _sepLine;
}
 
-(QMUITextView *)BZTV{
    if (!_BZTV) {
        _BZTV = [[QMUITextView alloc] init];
        _BZTV.shouldResponseToProgrammaticallyTextChanges = YES;
        _BZTV.shouldCountingNonASCIICharacterAsTwo = YES;
        _BZTV.font = Font_ListTitle;
        _BZTV.placeholder = @"请输入(限128字)";
        _BZTV.maximumTextLength = 256;
        _BZTV.maximumHeight = 90;
        [_BZTV rounded:5 width:2 color:Color_LINE_NOMARL];
        [self addSubview:_BZTV];
    }
     return _BZTV;
}

 
-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}

 

@end
