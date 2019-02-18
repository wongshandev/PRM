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

@end
@implementation JDHBListCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static   NSString *identifier = @"JDHBListCell";
    JDHBListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JDHBListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZZCircleProgress *circleProgress = [[ZZCircleProgress alloc]initWithFrame:CGRectMake(10, 10, 50, 50) pathBackColor:RGBColor(209,209,209) pathFillColor:Color_NavigationLightBlue startAngle:0 strokeWidth:4];
    circleProgress.progressLabel.font = Font_ListLeftCircle;
    circleProgress.progressLabel.textColor = Color_TEXT_HIGH;
    circleProgress.showPoint = NO;
    circleProgress.startAngle= -90;

    [self addSubview: circleProgress];
    self.circleProgress = circleProgress;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *ksjsDateLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:ksjsDateLab];
    self.ksjsDateLab = ksjsDateLab;

    QMUILabel *lastDateLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:lastDateLab];
    self.lastDateLab = lastDateLab;
}
-(void)buildSubview{
    [self.circleProgress makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(10);
        make.width.equalTo(50);
        make.height.equalTo(50);
    }];

    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.circleProgress.mas_right).offset(10);
     }];

    [self.ksjsDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
         make.left.equalTo(self.titleLab.mas_left);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(self.titleLab.mas_height);
        make.bottom.mas_equalTo(self).offset(-10);
    }];

    [self.lastDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(self.titleLab);
        make.width.equalTo(self.titleLab.mas_width);
    }];
}
-(void)loadContent{
    JDHBListModel *model = self.data;
    self.circleProgress.progress = model.canChangeRate.integerValue/100.0;
    self.titleLab.text = model.Name;
    self.ksjsDateLab.text = [@[model.BeginDate, model.EndDate] componentsJoinedByString:@"--"];
    self.lastDateLab.text = model.LastModifyDate;
}


@end
