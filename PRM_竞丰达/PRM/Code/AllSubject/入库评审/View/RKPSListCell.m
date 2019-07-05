//
//  RKPSListCell.m
//  PRM
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RKPSListCell.h"

@interface RKPSListCell()
@property (nonatomic, strong) QMUILabel *leftCircleLab;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *priceMenLab;
@property (nonatomic, strong) QMUILabel *priceLab;
@property (nonatomic, strong) QMUILabel *applyMenLab;
@property (nonatomic, strong) QMUILabel *applyPersonLab;
@property(nonatomic,strong)UIImageView *selecImgView;

@end
@implementation RKPSListCell

-(void)setupCell{
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_ListLeftCircle numberOfLines:0];
    leftCircle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:leftCircle];
    self.leftCircleLab = leftCircle;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *applyMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    applyMenLab.text = @"申请人 :";
    [self addSubview:applyMenLab];
    self.applyMenLab = applyMenLab;

    QMUILabel *applyPersonLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:applyPersonLab];
    self.applyPersonLab = applyPersonLab;

    QMUILabel *priceMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    priceMenLab.text = @"指导价 :";
    [self addSubview:priceMenLab];
    self.priceMenLab = priceMenLab;

    QMUILabel *priceLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:priceLab];
    self.priceLab = priceLab;

    UIImageView *imgView = [UIImageView new];
    [self addSubview:imgView];
    self.selecImgView = imgView;

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
 CGSize titleSize = [self.applyMenLab.text sizeWithFont:Font_ListOtherTxt constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    [self.applyMenLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.width.equalTo(titleSize.width);
    }];
    [self.applyPersonLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyMenLab.mas_top);
        make.left.equalTo(self.applyMenLab.mas_right);
        make.right.equalTo(self.titleLab.mas_right);
    }];

    [self.priceMenLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyMenLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.width.equalTo(self.applyMenLab.mas_width);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.priceLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceMenLab.mas_top);
        make.left.equalTo(self.priceMenLab.mas_right);
        make.right.equalTo(self.titleLab.mas_right);
    }];
    [self.selecImgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
}
-(void)loadContent{
    RKPSListModelFrame *frameModel = self.data;
    RKPSListModel *model = frameModel.model;
    self.leftCircleLab.text = model.stateString;
    self.titleLab.text = model.titleName;
    self.applyPersonLab.text = model.EmployeeName;
    self.priceLab.text =  model.PriceListStr;
    self.selecImgView.image = model.canEdit == TabCanEditDefault ? nil :  (model.canEdit == TabCanEditSelect ?   SJYCommonImage(@"CellButtonSelected") : SJYCommonImage(@"CellButton"));

 }


// 处理点击时控件颜色变化
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];//加上这句哦
    RKPSListModelFrame *frameModel = self.data;
    RKPSListModel *model = frameModel.model;
    _leftCircleLab.backgroundColor = model.stateColor;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];//加上这句哦
    RKPSListModelFrame *frameModel = self.data;
    RKPSListModel *model = frameModel.model;
    _leftCircleLab.backgroundColor =   model.stateColor;
}


@end
