//
//  CGFKListCell.m
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "CGFKListCell.h"
 
@interface CGFKListCell()
@property (nonatomic, strong) QMUILabel *leftCircleLab;

@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *subTitle;
@property (nonatomic, strong) QMUILabel *descriptionLab;
@property (nonatomic, strong) QMUILabel *moneyLab;


@end

@implementation CGFKListCell

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_ListLeftCircle numberOfLines:0];
    leftCircle.backgroundColor = Color_NavigationLightBlue;
    leftCircle.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    leftCircle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:leftCircle];
    self.leftCircleLab = leftCircle;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *subTitle = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:subTitle];
    self.subTitle = subTitle;

    QMUILabel *descriptionLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:descriptionLab];
    self.descriptionLab = descriptionLab;


    QMUILabel *moneyLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:moneyLab];
    self.moneyLab = moneyLab;

}
//-(void)buildSubview{
//    [self.leftCircleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.mas_equalTo(10);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(50);
//    }];
//    [self.leftCircleLab rounded:25];
//
//    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.leftCircleLab.mas_centerY).offset(-10);
//        make.right.mas_equalTo(self.mas_right).offset(-10);
//         make.width.mas_equalTo(70);
//    }];
//
//
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.leftCircleLab.mas_top);
//        make.left.mas_equalTo(self.leftCircleLab.mas_right).offset(10);
//        make.right.mas_equalTo(self.moneyLab.mas_left).offset(-10);
//        make.height.mas_greaterThanOrEqualTo(20);
//    }];
//    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
//        make.left.mas_equalTo(self.titleLab.mas_left);
//        make.right.mas_equalTo(self.titleLab.mas_right);
//        make.height.mas_greaterThanOrEqualTo(20);
//    }];
//    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.subTitle.mas_bottom).offset(5);
//        make.left.mas_equalTo(self.leftCircleLab.mas_centerX).offset(-5);
//        make.right.mas_equalTo(self.moneyLab.mas_left).offset(-5);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
//    }];
//}

-(void)buildSubview{
    [self.leftCircleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [self.leftCircleLab rounded:25];

    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftCircleLab.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(70);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftCircleLab.mas_top);
        make.left.mas_equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.mas_equalTo(self.moneyLab.mas_left).offset(-10);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.moneyLab.mas_right);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitle.mas_bottom).offset(5);
        make.left.mas_equalTo(self.leftCircleLab.mas_left);
        make.right.mas_equalTo(self.moneyLab.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
}
-(void)loadContent{
    CGFKListModel *model = self.data;
    self.titleLab.text = model.Name;
    self.leftCircleLab.text= model.CreateName;
    self.subTitle.text = model.SupplierName;
    
    self.descriptionLab.text = model.PlaceReceipt;
    self.moneyLab.text = [NSString numberMoneyFormattor:model.AgreementPrice];
    
}

// 处理点击时控件颜色变化
-(void)setSelected:(BOOL)highlighted animated:(BOOL)animated{
    [super setSelected:highlighted animated:animated];//加上这句哦
     _leftCircleLab.backgroundColor =   Color_NavigationLightBlue;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];//加上这句哦
     _leftCircleLab.backgroundColor =   Color_NavigationLightBlue;
}

@end
