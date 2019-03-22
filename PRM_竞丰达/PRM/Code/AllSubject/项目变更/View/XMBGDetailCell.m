//
//  XMBGDetailCell.m
//  PRM
//
//  Created by apple on 2019/1/19.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMBGDetailCell.h"

@interface XMBGDetailCell ()

@property (nonatomic, strong) UIImageView *leftImgeView;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *subTitle;
@property(nonatomic,strong) QMUILabel *fujianLab;

@end
@implementation XMBGDetailCell

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
     UIImageView *leftImgeView = [[UIImageView alloc] init];;
     [self addSubview:leftImgeView];
    self.leftImgeView = leftImgeView;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *subTitle = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:subTitle];
    self.subTitle = subTitle;

    QMUILabel *fujianLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    fujianLab.text= @"附件:";
    [self addSubview:fujianLab];
    self.fujianLab = fujianLab;

    QMUIButton *fujianBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [fujianBtn setTitleColor:Color_NavigationLightBlue forState:UIControlStateNormal];
    fujianBtn.titleLabel.font = Font_ListOtherTxt;
    [self addSubview:fujianBtn];
    fujianBtn.hidden = YES;
    self.fujianBtn = fujianBtn;
}
-(void)buildSubview{
    [self.leftImgeView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(10);
        make.height.equalTo(50);
        make.width.equalTo(50);
    }];

    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.leftImgeView.mas_right).offset(10);
        make.height.mas_greaterThanOrEqualTo(20);
        make.right.equalTo(self).offset(-10);
    }];
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.leftImgeView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
     }];
 
    [self.fujianLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitle.mas_bottom).offset(5);
        make.left.equalTo(self.leftImgeView.mas_right).offset(10);
        make.height.lessThanOrEqualTo(35);
         make.bottom.equalTo(self).offset(-5);
    }];
    [self.fujianBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fujianLab.mas_centerY);
        make.left.equalTo(self.fujianLab.mas_right).offset(10);
         make.height.mas_equalTo(self.fujianLab.mas_height);
     }];
}
-(void)loadContent{
    XMBGDetailModel *model = self.data;
    if (self.cellType == CellType_XMBGDetial) {
        self.subTitle.text = model.Remark;
        self.titleLab.text = model.titleStr;
        self.fujianBtn.hidden =  !(model.Url.lastPathComponent.length && [model.Url.lastPathComponent containsString:@"."]);
        [self.fujianBtn setTitle:model.Url.lastPathComponent forState:UIControlStateNormal];

//        self.leftImgeView.image = SJYCommonImage([NSString matchType:model.Url.lastPathComponent]);

        [self.leftImgeView sd_setImageWithURL:[NSURL URLWithString:model.Url] placeholderImage:PYPlaceholderImage options:SDWebImageRefreshCached |SDWebImageRetryFailed ];


    }
    if (self.cellType == CellType_WJQDList) {
         self.titleLab.text = model.Name;
        self.fujianBtn.hidden =  !(model.Url.lastPathComponent.length && [model.Url.lastPathComponent containsString:@"."]);
        [self.fujianBtn setTitle:model.Url.lastPathComponent forState:UIControlStateNormal];
        self.leftImgeView.image = SJYCommonImage([NSString matchType:model.Url.lastPathComponent]);
    }
}
 

@end
