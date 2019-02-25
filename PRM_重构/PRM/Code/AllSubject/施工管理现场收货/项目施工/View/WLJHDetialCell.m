//
//  WLJHDetialCell.m
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "WLJHDetialCell.h"
#import "WLJHDetialModel.h"
#import "ZZCircleProgress.h"
#define TopMargin  5
@interface WLJHDetialCell ()
@property (nonatomic, strong) ZZCircleProgress *circleProgress;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *mentionTotalLab;
@property (nonatomic, strong) QMUILabel *mentionPlanLab;
@property (nonatomic, strong) QMUILabel *mentionThisLab;
@property (nonatomic, strong) QMUILabel *totalLab;
@property (nonatomic, strong) QMUILabel *planLab;
@property (nonatomic, strong) QMUILabel *thisLab;

@end
@implementation WLJHDetialCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static   NSString *identifier = @"WLJHDetialCell";
    WLJHDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WLJHDetialCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

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
    menPlanLab.text = @"计划:";
    self.mentionPlanLab = menPlanLab;

    QMUILabel *planLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    planLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    planLab.backgroundColor = Color_Red;
    [self addSubview:planLab];

    self.planLab = planLab;

// 本次
    QMUILabel * menThisLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:menThisLab];
    menThisLab.text = @"本次:";
    self.mentionThisLab = menThisLab;

    QMUILabel *thisLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    thisLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    thisLab.backgroundColor = UIColorHex(#3FD0AD);
    [self addSubview:thisLab];
    self.thisLab = thisLab;


}
-(void)buildSubview{ 
    //标题
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TopMargin);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.greaterThanOrEqualTo(20);
    }];
    [self.circleProgress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.titleLab.mas_left);
        make.width.equalTo(50);
        make.height.equalTo(50);
        make.bottom.equalTo(self).offset(-TopMargin);
    }];
    //总数提示
    [self.mentionTotalLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleProgress.mas_top);
        make.left.equalTo(self.circleProgress.mas_right).offset(5);
        make.width.equalTo(40);
     }];
// 本次提示
    [self.mentionThisLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mentionTotalLab.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.circleProgress.mas_right).offset(5);
        make.width.equalTo(40);
        make.height.equalTo(self.mentionTotalLab.mas_height);
        make.bottom.equalTo(self.circleProgress.mas_bottom);
    }];
//总数
    [self.totalLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionTotalLab.mas_centerY);
        make.left.equalTo(self.mentionTotalLab.mas_right);
        make.height.equalTo(self.mentionTotalLab.mas_height);
     }];
//计划提示
    [self.mentionPlanLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionTotalLab.mas_centerY);
        make.left.equalTo(self.totalLab.mas_right).offset(10);
        make.width.equalTo(40);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
    //计划
    [self.planLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionPlanLab.mas_centerY);
        make.left.equalTo(self.mentionPlanLab.mas_right);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(self.totalLab.mas_width);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
//本次
    [self.thisLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionThisLab.mas_centerY);
        make.left.equalTo(self.mentionThisLab.mas_right);
        make.height.equalTo(self.mentionThisLab.mas_height);
    }];
    [self.totalLab rounded:2];
    [self.planLab rounded:2];
    [self.thisLab rounded:2];
}
-(void)loadContent{
    WLJHDetialModel *model = self.data;
    self.titleLab.text = model.titleStr;
    self.circleProgress.progress = model.canChangeQuantityThis.floatValue / model.Quantity.integerValue;
    self.totalLab.text = model.Quantity;
    self.planLab.text = model.QuantityPurchased;
     self.thisLab.text = model.canChangeQuantityThis;
 }

@end
