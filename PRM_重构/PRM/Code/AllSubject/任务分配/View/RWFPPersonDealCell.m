//
//  RWFPPersonDealCell.m
//  PRM
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RWFPPersonDealCell.h"
@interface RWFPPersonDealCell()
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *subTitleLab;

@end
@implementation RWFPPersonDealCell

-(void)setupCell{
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;


    QMUILabel *subTitleLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    subTitleLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:subTitleLab];
    self.subTitleLab = subTitleLab;

}

-(void)buildSubview{
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.greaterThanOrEqualTo(30);
        make.width.mas_greaterThanOrEqualTo(70);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];

    [self.subTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_top);
        make.left.equalTo(self.titleLab.mas_right);
        make.right.mas_equalTo(self.mas_right).mas_offset(-50);
         make.bottom.equalTo(self.titleLab.mas_bottom);
    }];

}

-(void)loadContent{
    RWFPDealListModel  *model = self.data;
    self.titleLab.text = model.titleStr;
     self.subTitleLab.text = model.subtitleStr;
}



@end
