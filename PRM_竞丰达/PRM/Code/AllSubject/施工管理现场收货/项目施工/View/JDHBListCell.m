//
//  JDHBListCell.m
//  PRM
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "JDHBListCell.h"
#import "JDHBListModel.h"
#import "ZZCircleProgress.h"

@interface JDHBListCell ( )
@property (nonatomic, strong) ZZCircleProgress *circleProgress;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *ksjsDateLab;
@property (nonatomic, strong) QMUILabel *lastDateLab;
@property (nonatomic, strong) QMUILabel *bzLab;

@end
@implementation JDHBListCell
-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    ZZCircleProgress *circleProgress = [[ZZCircleProgress alloc]initWithFrame:CGRectMake(10, 10, 50, 50) pathBackColor:RGBColor(209,209,209) pathFillColor:Color_NavigationLightBlue startAngle:0 strokeWidth:4];
    circleProgress.progressLabel.font = Font_ListLeftCircle;
    circleProgress.progressLabel.textColor = Color_TEXT_HIGH;
    circleProgress.showPoint = NO;
    circleProgress.startAngle= -90;

    [self addSubview: circleProgress];
    self.circleProgress = circleProgress;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *ksjsDateLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:ksjsDateLab];
    self.ksjsDateLab = ksjsDateLab;

    QMUILabel *bzLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:bzLab];
    self.bzLab = bzLab;

    QMUILabel *lastDateLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:lastDateLab];
    self.lastDateLab = lastDateLab;
}
-(void)buildSubview{
    [self.lastDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(0);
    }];
    [self.circleProgress makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(10);
        make.width.equalTo(50);
        make.height.equalTo(50);
    }];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.circleProgress.mas_right).offset(10);
        make.right.equalTo(self.lastDateLab.mas_left);
        make.height.greaterThanOrEqualTo(25);
    }];
    [self.ksjsDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.titleLab.mas_left);
        make.right.equalTo(self).offset(-10);
        make.height.greaterThanOrEqualTo(20);
    }];
    [self.bzLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ksjsDateLab.mas_bottom).offset(5);
        make.left.equalTo(self.circleProgress.mas_left);
        make.right.equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self).offset(-5);
    }];
}
-(void)loadContent{
    JDHBListModel *model = self.data;
    self.cellDic = [NSMutableDictionary dictionaryWithDictionary:[model modelToJSONObject]];
    CGRect titleRect = [model.LastModifyDate boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lastDateLab.font} context:nil];
    CGFloat titleWidth = ceilf(titleRect.size.width);
    [self.lastDateLab updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(titleWidth);
    }];
    self.circleProgress.progress = model.CompletionRate.integerValue/100.0;
    self.titleLab.text = model.titleStr;
    self.ksjsDateLab.text = [@[model.BeginDate, model.EndDate] componentsJoinedByString:@"~"];
    self.lastDateLab.text = model.LastModifyDate;
    self.bzLab.text = model.Remark;
}
-(void)setCellDic:(NSMutableDictionary *)cellDic{
    _cellDic = cellDic;
    CGRect titleRect = [cellDic[@"LastModifyDate"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lastDateLab.font} context:nil];
    CGFloat titleWidth = ceilf(titleRect.size.width);
    [self.lastDateLab updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(titleWidth);
    }];
    self.circleProgress.progress = [cellDic[@"CompletionRate"] integerValue]/100.0;
    self.titleLab.text = cellDic[@"titleStr"];
    self.ksjsDateLab.text = [@[cellDic[@"BeginDate"], cellDic[@"EndDate"]] componentsJoinedByString:@"~"];
    self.lastDateLab.text = cellDic[@"LastModifyDate"];
    self.bzLab.text = cellDic[@"Remark"];
}

@end
