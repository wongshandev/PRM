//
//  GCJDListCell.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "GCJDListCell.h"


@interface GCJDListCell()

@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *jhkssjMenLab;
@property (nonatomic, strong) QMUILabel *jhkssjLab;
 @property (nonatomic, strong) QMUILabel *jhsgtsMenLab;
@property (nonatomic, strong) QMUILabel *jhsgtsLab;


@end

@implementation GCJDListCell

-(void)setupCell{
    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *jhkssjMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListTitle numberOfLines:1];
    jhkssjMenLab.text = @"计划开始日期:";
    [self addSubview:jhkssjMenLab];
    self.jhkssjMenLab = jhkssjMenLab;

    QMUILabel *jhkssjLab = [self createLabelWithTextColor:Color_White Font:Font_ListOtherTxt numberOfLines:0];
    jhkssjLab.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    jhkssjLab.backgroundColor = Color_Red;
    jhkssjLab.textAlignment =NSTextAlignmentCenter;

    [self addSubview:jhkssjLab];
    self.jhkssjLab = jhkssjLab;



    QMUILabel *jhsgtsMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListTitle numberOfLines:1];
    jhsgtsMenLab.text = @"计划施工天数:";
    [self addSubview:jhsgtsMenLab];
    self.jhsgtsMenLab = jhsgtsMenLab;

    QMUILabel *jhsgtsLab = [self createLabelWithTextColor:Color_White Font:Font_ListOtherTxt numberOfLines:0];
    jhsgtsLab.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    jhsgtsLab.backgroundColor = Color_NavigationLightBlue;
    jhsgtsLab.textAlignment =NSTextAlignmentCenter;
    [self addSubview:jhsgtsLab];
    self.jhsgtsLab = jhsgtsLab;
}

-(void)buildSubview{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-10);

    }];
    [self.jhkssjMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.height.mas_greaterThanOrEqualTo(20);
     }];
    [self.jhsgtsMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhkssjMenLab.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.jhkssjMenLab.mas_left);
        make.width.mas_equalTo(self.jhkssjMenLab.mas_width);
        make.height.mas_equalTo(self.jhkssjMenLab.mas_height);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    [self.jhkssjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.jhkssjMenLab.mas_centerY);
        make.left.mas_equalTo(self.jhkssjMenLab.mas_right).mas_offset(5);
        make.height.mas_equalTo(self.jhkssjMenLab.mas_height);

     }];

    [self.jhsgtsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.jhsgtsMenLab.mas_centerY);
        make.left.mas_equalTo(self.jhsgtsMenLab.mas_right).mas_offset(5);
        make.width.mas_equalTo(self.jhkssjLab.mas_width);
        make.height.mas_equalTo(self.jhsgtsMenLab.mas_height);
     }];
    [self.jhkssjLab rounded:3];
    [self.jhsgtsLab rounded:3];
}

-(void)loadContent{
    GCJDListModel *model = self.data;
    self.titleLab.text = model.Name;
    self.jhkssjLab.text = model.BeginDate;
    self.jhsgtsLab.text = model.DesignDay;
}
@end
