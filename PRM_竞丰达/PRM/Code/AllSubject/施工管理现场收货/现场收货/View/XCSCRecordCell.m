//
//  XCSCRecordCell.m
//  PRM
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XCSCRecordCell.h"
#import "XCSHRecordModel.h"
@interface XCSCRecordCell ()

@property (nonatomic, strong) QMUILabel *leftCircleLab;
@property (nonatomic, strong) QMUILabel *titleLab;

 @property (nonatomic, strong) QMUILabel *codeLab;

 @property (nonatomic, strong) QMUILabel *receivePersonLab;
 
@end
@implementation XCSCRecordCell



-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_ListLeftCircle numberOfLines:0];
    leftCircle.textAlignment = NSTextAlignmentCenter;
    leftCircle.backgroundColor = Color_NavigationBlue;
    [self addSubview:leftCircle];
    self.leftCircleLab = leftCircle;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *codeLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:codeLab];
    self.codeLab = codeLab;

    QMUILabel *receivePersonLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:receivePersonLab];
    self.receivePersonLab = receivePersonLab;

}
-(void)buildSubview{
    [self.leftCircleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(10);
        make.height.equalTo(50);
        make.width.equalTo(50);
    }];
    [self.leftCircleLab rounded:25];

    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];

    [self.codeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.right.equalTo(self.titleLab.mas_right);
    }];

    [self.receivePersonLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.right.equalTo(self.titleLab.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];

}
-(void)loadContent{
    XCSHRecordModel *model = self.data;
    self.leftCircleLab.text = model.StateName;
    self.titleLab.text = model.titleName;
    self.codeLab.text =  model.Code;
    self.receivePersonLab.text = [@"接收人:  " stringByAppendingString: model.Employee];
}







@end
