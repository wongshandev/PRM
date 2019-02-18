//
//  RWFPListCell.m
//  PRM
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RWFPListCell.h"

@interface RWFPListCell()

@property (nonatomic, strong) QMUILabel *leftCircleLab;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *planMentLab;

@end
@implementation RWFPListCell



-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_ListLeftCircle numberOfLines:0];
    leftCircle.textAlignment = NSTextAlignmentCenter;
    leftCircle.backgroundColor = Color_NavigationBlue;
    [self addSubview:leftCircle];
    self.leftCircleLab = leftCircle;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *planMentLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
     [self addSubview:planMentLab];
    self.planMentLab = planMentLab;



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
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.greaterThanOrEqualTo(20);
    }];

    [self.planMentLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
         make.height.equalTo(20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];

}
-(void)loadContent{
    RWFPListModel *model = self.data;
    self.leftCircleLab.text = model.ProjectTypeName;
    self.titleLab.text = model.titleStr;
    self.planMentLab.text =  model.City;

}


@end
