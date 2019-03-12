//
//  WLJHListCell.m
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "WLJHListCell.h"

//#define   STATESimpleArray   @[@"", @"已计划", @"已申请", @"已驳回", @"已审核", @"已下单",@"已采购" ,@"已完成"]

@interface WLJHListCell ()



@property (nonatomic, strong) UIImageView *jhDateImgView;  //计划日期
@property (nonatomic, strong) QMUILabel *jhDateLab;

@property (nonatomic, strong) UIImageView *qgDateImgView; // 请购日期
@property (nonatomic, strong) QMUILabel *qgDateLab;


@property (nonatomic, strong) UIImageView *dhDateImgView; //要求到货
@property (nonatomic, strong) QMUILabel *dhDateLab;

@end
@implementation WLJHListCell


//+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static   NSString *identifier = @"WLJHListCell";
//    WLJHListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[WLJHListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//    }
//    return cell;
//}

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

    UIImageView *jhImgView = [[UIImageView alloc] initWithImage:SJYCommonImage(@"jihua.png")];
    [self addSubview:jhImgView];
    self.jhDateImgView = jhImgView;

    QMUILabel *jhDateLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:jhDateLab];
    self.jhDateLab = jhDateLab;

    UIImageView *qgImgView = [[UIImageView alloc] initWithImage:SJYCommonImage(@"qinggou.png")];
    [self addSubview:qgImgView];
    self.qgDateImgView = qgImgView;

    QMUILabel *qgDateLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:qgDateLab];
    self.qgDateLab = qgDateLab;


    UIImageView *daoDaImgView = [[UIImageView alloc] initWithImage:SJYCommonImage(@"daoda.png")];
    [self addSubview:daoDaImgView];
    self.dhDateImgView = daoDaImgView;

    QMUILabel *dhLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:dhLab];
    self.dhDateLab = dhLab;

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
    [self.jhDateImgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.height.equalTo(25);
        make.width.equalTo(25);
    }];
    [self.jhDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jhDateImgView.mas_centerY);
        make.left.equalTo(self.jhDateImgView.mas_right).offset(10);
        make.height.equalTo(self.jhDateImgView);

    }];
    [self.qgDateImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jhDateImgView.mas_centerY);
        make.left.equalTo(self.jhDateLab.mas_right);
        make.height.equalTo(self.jhDateImgView);
        make.width.equalTo(self.jhDateImgView);
    }];
    [self.qgDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.qgDateImgView.mas_centerY);
        make.left.equalTo(self.qgDateImgView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(self.qgDateImgView);
        make.width.equalTo(self.jhDateLab.mas_width);
    }];

    [self.dhDateImgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhDateImgView.mas_bottom).offset(5);
        make.left.equalTo(self.jhDateImgView.mas_left);
        make.height.equalTo(self.jhDateImgView);
        make.width.equalTo(self.jhDateImgView);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.dhDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dhDateImgView.mas_centerY);
        make.left.equalTo(self.dhDateImgView.mas_right).offset(10);
        make.height.equalTo(self.dhDateImgView);
        make.width.equalTo(self.jhDateLab.mas_width);
    }];

}
-(void)loadContent{
    if (self.cellType == CellType_WLJH) {
        WLJHListModel *model = self.data;
        self.leftCircleLab.text = model.stateString;
        self.leftCircleLab.backgroundColor = model.stateColor;
        self.titleLab.text = model.Name;
        self.jhDateLab.text = model.CreateDate;

        NSInteger qgrq = [model.MarketDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
        NSInteger planDate = [model.CreateDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
        NSInteger dhRq = [model.OrderDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;

        self.qgDateLab.text = qgrq >= planDate?model.MarketDate:@"";
        self.dhDateLab.text = dhRq>= planDate?model.OrderDate:@"";
    }

    if (self.cellType == CellType_XMQG) {
        XMQGListModel *model = self.data;
        self.leftCircleLab.backgroundColor = model.stateColor;
        self.leftCircleLab.text = model.stateStr;
        self.titleLab.text = model.titleStr;
        self.jhDateLab.text = model.CreateDate;

        NSInteger qgrq = [model.MarketDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
        NSInteger planDate = [model.CreateDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
        NSInteger dhRq = [model.OrderDate stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;

        self.qgDateLab.text = qgrq >= planDate?model.MarketDate:@"";
        self.dhDateLab.text = dhRq>= planDate?model.OrderDate:@"";
    }

}



@end
