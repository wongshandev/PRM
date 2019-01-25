//
//  XMJDListCell.m
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMJDListCell.h"
@interface XMJDListCell ()
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *shejiMenLab;
@property (nonatomic, strong) QMUILabel *shejiPersonLab;
@property (nonatomic, strong) QMUILabel *baojiaMenLab;
@property (nonatomic, strong) QMUILabel *baojiaPersonLab;
@property (nonatomic, strong) QMUILabel *shoukuanMenLab;
@property (nonatomic, strong) QMUILabel *skMoneyLab;
@property (nonatomic, strong) QMUILabel *kaipiaoMenLab;
@property (nonatomic, strong) QMUILabel *kpMoneyLab;
@end
@implementation XMJDListCell

-(void)setupCell{
    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *shejiMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    shejiMenLab.text = @"设计人:";
    [self addSubview:shejiMenLab];
    self.shejiMenLab = shejiMenLab;

    QMUILabel *shejiPersonLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:shejiPersonLab];
    self.shejiPersonLab = shejiPersonLab;

    QMUILabel *baojiaMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    baojiaMenLab.text = @"报价人:";
    [self addSubview:baojiaMenLab];
    self.baojiaMenLab = baojiaMenLab;

    QMUILabel *baojiaPersonLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:baojiaPersonLab];
    self.baojiaPersonLab = baojiaPersonLab;

    QMUILabel *shoukuanMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    shoukuanMenLab.text = @"收款金额:";
    [self addSubview:shoukuanMenLab];
    self.shoukuanMenLab = shoukuanMenLab;

    QMUILabel *skMoneyLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:skMoneyLab];
    self.skMoneyLab = skMoneyLab;

    QMUILabel *kaipiaoMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    kaipiaoMenLab.text = @"开票金额:";
    [self addSubview:kaipiaoMenLab];
    self.kaipiaoMenLab = kaipiaoMenLab;

    QMUILabel *kpMoneyLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:kpMoneyLab];
    self.kpMoneyLab = kpMoneyLab;


}

-(void)buildSubview{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-10);

    }];

    [self.shejiMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.width.mas_equalTo(60);
     }];
    [self.shejiPersonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
         make.left.mas_equalTo(self.shejiMenLab.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.mas_centerX);
     }];

    [self.baojiaMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shejiMenLab.mas_centerY);
        make.left.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.shejiMenLab.mas_width);

    }];
    [self.baojiaPersonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baojiaMenLab.mas_centerY);
        make.left.mas_equalTo(self.baojiaMenLab.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];


    [self.shoukuanMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shejiMenLab.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.shejiMenLab.mas_left);
        make.width.mas_equalTo(self.shejiMenLab.mas_width);
        make.height.mas_equalTo(self.shejiMenLab.mas_height);
    }];
    [self.skMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shejiPersonLab.mas_bottom).mas_offset(5);
         make.left.mas_equalTo(self.shoukuanMenLab.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
     }];

    [self.kaipiaoMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shoukuanMenLab.mas_centerY);
        make.left.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.shejiMenLab.mas_width);
    }];
    [self.kpMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kaipiaoMenLab.mas_centerY);
        make.left.mas_equalTo(self.kaipiaoMenLab.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.titleLab.mas_right);

     }];
}

-(void)loadContent{
    XMJDListModel *model = self.data;

    self.titleLab.text = model.titleStr;
    self.shejiPersonLab.text = model.DesignName;
    self.baojiaPersonLab.text = model.InquiryName;


    self.skMoneyLab.text = [NSString numberMoneyFormattor: model.ReceivablesPrice];
    self.kpMoneyLab.text = [NSString numberMoneyFormattor: model.BillingPrice];


}
@end
