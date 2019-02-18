//
//  BGSHListCell.m
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BGSHListCell.h"
 #import "BGSHListModel.h"

@interface BGSHListCell()
@property (nonatomic, strong) QMUILabel *leftCircleLab;

@property (nonatomic, strong) UIImageView *rightImgeView;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *subTitle;
@property (nonatomic, strong) QMUILabel *descriptionLab;

 @end

@implementation BGSHListCell

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_ListLeftCircle numberOfLines:0];
    leftCircle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:leftCircle];
    self.leftCircleLab = leftCircle;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *subTitle = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:subTitle];
    self.subTitle = subTitle;

    QMUILabel *descriptionLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:descriptionLab];
    self.descriptionLab = descriptionLab;

    UIImageView *imgView  = [[UIImageView alloc]init];
    [self addSubview:imgView];
    self.rightImgeView = imgView;

    QMUIButton *fjbtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:fjbtn];
    self.fujianBtn = fjbtn;

}
-(void)buildSubview{
    [self.leftCircleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [self.leftCircleLab rounded:25];

    [self.rightImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftCircleLab.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    [self.fujianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.rightImgeView);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftCircleLab.mas_top);
        make.left.mas_equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.mas_equalTo(self.rightImgeView.mas_left).offset(-10);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitle.mas_bottom).offset(5);
        make.left.mas_equalTo(self.leftCircleLab.mas_centerX).offset(-5);
        make.right.mas_equalTo(self.rightImgeView.mas_centerX).offset(-5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];


}

-(void)loadContent{
    BGSHListModel *model = self.data;
    self.leftCircleLab.text= model.stateStr;
    self.leftCircleLab.backgroundColor =  model.ApprovalID.integerValue > 0 ?  Color_NavigationLightBlue:Color_Red;

    self.descriptionLab.text = model.Remark;
    self.titleLab.text = model.titleStr;
    self.subTitle.text = model.subtitleStr;
//    self.rightImgeView.image = SJYCommonImage([NSString matchType:model.Url.lastPathComponent]);
    self.fujianBtn.hidden =   !(model.Url.lastPathComponent.length && [model.Url.lastPathComponent containsString:@"."]);
    [self.fujianBtn setImage: SJYCommonImage([NSString matchType:model.Url.lastPathComponent]) forState:UIControlStateNormal];

}
 
// 处理点击时控件颜色变化
-(void)setSelected:(BOOL)highlighted animated:(BOOL)animated{
    [super setSelected:highlighted animated:animated];//加上这句哦
    BGSHListModel *model = self.data;
    _leftCircleLab.backgroundColor = model.ApprovalID.integerValue > 0 ?  Color_NavigationLightBlue:Color_Red;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];//加上这句哦
    BGSHListModel *model = self.data;
    _leftCircleLab.backgroundColor = model.ApprovalID.integerValue > 0 ?  Color_NavigationLightBlue:Color_Red;
}

@end
