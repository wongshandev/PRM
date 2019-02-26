//
//  SJYJJQRListCell.m
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYJJQRListCell.h"

@interface SJYJJQRListCell ()
@property (nonatomic, strong) QMUILabel *leftCircleLab;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *mainFZRLab;
@property (nonatomic, strong) QMUILabel *mainSJRLab;
@property (nonatomic, strong) UIImageView *fzrImgView;
@property (nonatomic, strong) UIImageView *sjrImgView;


@end
@implementation SJYJJQRListCell 


-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:0];
    leftCircle.textAlignment = NSTextAlignmentCenter;
    leftCircle.backgroundColor = Color_NavigationBlue;
    [self addSubview:leftCircle];
    
    self.leftCircleLab = leftCircle;
    
    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;
    
    
    UIImageView *mainfzrImg = [[UIImageView alloc] initWithImage:SJYCommonImage(@"scfzr.png")];
    [self addSubview:mainfzrImg];
    self.fzrImgView = mainfzrImg;
    
    QMUILabel *mainfzrLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:mainfzrLab];
    self.mainFZRLab = mainfzrLab;
    
    UIImageView *mainsjrImg = [[UIImageView alloc] initWithImage:SJYCommonImage(@"scfzr1.png")];
    [self addSubview:mainsjrImg];
    self.sjrImgView = mainsjrImg;
    
    QMUILabel *mainsjrLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:mainsjrLab];
    self.mainSJRLab = mainsjrLab;
}
-(void)buildSubview{
    [self.leftCircleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(10);
        make.height.equalTo(50);
        make.width.equalTo(50);
    }];
    [self.leftCircleLab rounded:25];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    [self.fzrImgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.height.equalTo(25);
        make.width.equalTo(25);
        make.bottom.equalTo(self).offset(-10);
    }];
    [self.mainFZRLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fzrImgView.mas_centerY);
        make.left.equalTo(self.fzrImgView.mas_right).offset(10);
        make.height.equalTo(self.fzrImgView);
        
    }];
    [self.sjrImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fzrImgView.mas_centerY);
        make.left.equalTo(self.mainFZRLab.mas_right);
        make.height.equalTo(self.fzrImgView);
        make.width.equalTo(self.fzrImgView);
    }];
    [self.mainSJRLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sjrImgView.mas_centerY);
        make.left.equalTo(self.sjrImgView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(self.sjrImgView);
        make.width.equalTo(self.mainFZRLab.mas_width);
    }];
    
}
-(void)loadContent{
    if (self.cellType == CellType_JJQRList) {
        SJYJJQRListModel *model = self.data;
        self.leftCircleLab.text = model.Code;
        self.mainFZRLab.text = model.DesignName;
        self.titleLab.text = model.titleStr;
        self.mainSJRLab.text = model.InquiryName;
    }
    
    if (self.cellType == CellType_SJSHList) {
        SJSHListModel *model = self.data;
        self.leftCircleLab.backgroundColor = model.StateColor;
        self.leftCircleLab.text = model.stateString;
        self.mainSJRLab.text = model.DesignName;
        self.mainFZRLab.text = model.InquiryName;
        self.titleLab.text = model.titleStr;
    }
    
}

// 处理点击时控件颜色变化
-(void)setSelected:(BOOL)highlighted animated:(BOOL)animated{
    [super setSelected:highlighted animated:animated];//加上这句哦
    if (self.cellType == CellType_SJSHList) {
        SJSHListModel *model = self.data;
        _leftCircleLab.backgroundColor = model.StateColor;
    }
    if (self.cellType == CellType_JJQRList) {
        _leftCircleLab.backgroundColor =   Color_NavigationLightBlue;
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];//加上这句哦
    if (self.cellType == CellType_SJSHList) {
        SJSHListModel *model = self.data;
        _leftCircleLab.backgroundColor = model.StateColor;
    } 
    if (self.cellType == CellType_JJQRList) {
        _leftCircleLab.backgroundColor =   Color_NavigationLightBlue;
    }
}


@end
