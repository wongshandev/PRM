//
//  XCSHRecordDetialCell.m
//  PRM
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XCSHRecordDetialCell.h"
#import "XCSHRecordDetialModel.h"
#import "ZZCircleProgress.h"
#define TopMargin  5
@interface XCSHRecordDetialCell ()

@property (nonatomic, strong) ZZCircleProgress *circleProgress;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *mentionTotalLab;
@property (nonatomic, strong) QMUILabel *mentionReceiveLab;
@property (nonatomic, strong) QMUILabel *mentionThisLab;
@property (nonatomic, strong) QMUILabel *totalLab;
@property (nonatomic, strong) QMUILabel *receiveLab;
@property (nonatomic, strong) QMUILabel *thisLab;
@property (nonatomic, strong) QMUILabel *bzLab;

@end
@implementation XCSHRecordDetialCell

//+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static   NSString *identifier = @"WLJHDetialCell";
//    XCSHRecordDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[WLJHDetialCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//    }
//    return cell;
//}

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    ZZCircleProgress *circleProgress = [[ZZCircleProgress alloc]initWithFrame:CGRectMake(10, 10, 50, 50) pathBackColor:RGBColor(209,209,209) pathFillColor:Color_NavigationLightBlue startAngle:0 strokeWidth:4];
    circleProgress.progressLabel.font = Font_ListLeftCircle;
    circleProgress.progressLabel.textColor = Color_TEXT_HIGH;
    circleProgress.showPoint = NO;
    circleProgress.startAngle= -90;
    [self addSubview: circleProgress];
    self.circleProgress = circleProgress;

    // 总数
    QMUILabel *menTotalLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:menTotalLab];
    menTotalLab.text = @"总数:";
    self.mentionTotalLab = menTotalLab;

    QMUILabel *totalLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    totalLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    totalLab.backgroundColor = Color_NavigationLightBlue;
    [self addSubview:totalLab];

    self.totalLab = totalLab;

    //计划
    QMUILabel *menPlanLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:menPlanLab];
    menPlanLab.text = @"已接收:";
    self.mentionReceiveLab = menPlanLab;

    QMUILabel *receiveLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    receiveLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    receiveLab.backgroundColor = Color_Red;
    [self addSubview:receiveLab];

    self.receiveLab = receiveLab;

    // 本次
    QMUILabel * menThisLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:menThisLab];
    menThisLab.text = @"本次:";
    self.mentionThisLab = menThisLab;

    QMUILabel *thisLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    thisLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    thisLab.backgroundColor = Color_Cyan ;
    [self addSubview:thisLab];
    self.thisLab = thisLab;

    //备注
    QMUILabel *bzLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:bzLab];
     self.bzLab = bzLab;

}
-(void)buildSubview{
    //标题
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(TopMargin);
        make.top.equalTo(self).offset(TopMargin*2);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.greaterThanOrEqualTo(20);
    }];
    [self.circleProgress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.titleLab.mas_left);
        make.width.equalTo(50);
        make.height.equalTo(50);
        //        make.bottom.equalTo(self).offset(-TopMargin);
    }];
    //备注
    [self.bzLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleProgress.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.circleProgress.mas_left);
        make.right.equalTo(self.titleLab.mas_right);
        make.bottom.equalTo(self).offset(-TopMargin);
    }];
    //总数提示
    [self.mentionTotalLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleProgress.mas_top);
        make.left.equalTo(self.circleProgress.mas_right).offset(10);
        make.width.equalTo(40);
    }];
    // 本次提示
    [self.mentionThisLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mentionTotalLab.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.circleProgress.mas_right).offset(10);
        make.width.equalTo(self.mentionTotalLab.mas_width);
        make.height.equalTo(self.mentionTotalLab.mas_height);
        make.bottom.equalTo(self.circleProgress.mas_bottom);
    }];
    //总数
    [self.totalLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionTotalLab.mas_centerY);
        make.left.equalTo(self.mentionTotalLab.mas_right);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
    //接收提示
    [self.mentionReceiveLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionTotalLab.mas_centerY);
        make.left.equalTo(self.totalLab.mas_right).offset(30);
        make.width.equalTo(50);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
    //接收
    [self.receiveLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionReceiveLab.mas_centerY);
        make.left.equalTo(self.mentionReceiveLab.mas_right);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.mas_equalTo(self.totalLab.mas_width);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
    //本次
    [self.thisLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionThisLab.mas_centerY);
        make.left.equalTo(self.mentionThisLab.mas_right);
        make.height.equalTo(self.mentionThisLab.mas_height);
        make.width.mas_equalTo(self.totalLab.mas_width);

    }];
    [self.totalLab rounded:2];
    [self.receiveLab rounded:2];
    [self.thisLab rounded:2];
}
-(void)loadContent{
    XCSHRecordDetialModel *model = self.data;
    self.cellDic = [NSMutableDictionary dictionaryWithDictionary:[model modelToJSONObject]];
    self.circleProgress.progress = (model.QuantityReceive.floatValue + model.QuantityCheck.floatValue)  / model.Quantity.integerValue;
    self.titleLab.text = model.titleStr;
    self.totalLab.text = model.Quantity;
    self.receiveLab.text = model.QuantityReceive;
    self.thisLab.text = model.QuantityCheck;
    self.bzLab.text = model.Remark;
 }
-(void)setCellDic:(NSMutableDictionary *)cellDic{
    _cellDic = cellDic;
    self.circleProgress.progress = ([cellDic[@"QuantityReceive"] floatValue] + [cellDic[@"QuantityCheck"] floatValue] )  / [cellDic[@"Quantity"] floatValue];
    self.titleLab.text = cellDic[@"titleStr"];
    self.totalLab.text = cellDic[@"Quantity"];
    self.receiveLab.text =  cellDic[@"QuantityReceive"];
    self.thisLab.text =  cellDic[@"QuantityCheck"];
    self.bzLab.text =  cellDic[@"Remark"];
 }
@end
