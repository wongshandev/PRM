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

//+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static   NSString *identifier = @"WLJHDetialCell";
//    WLJHDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
//    circleProgress.increaseFromLast = YES;
    circleProgress.startAngle= -90;
    [self addSubview: circleProgress];
    self.circleProgress = circleProgress;

// 总数
    QMUILabel *menTotalLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:menTotalLab];
    menTotalLab.text = @"设计数量:";
    self.mentionTotalLab = menTotalLab;

    QMUILabel *totalLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    totalLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    totalLab.backgroundColor = Color_NavigationLightBlue;
    [self addSubview:totalLab];

    self.totalLab = totalLab;

//计划
    QMUILabel *menPlanLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    menPlanLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:menPlanLab];
    menPlanLab.text = @"已计划:";
    self.mentionPlanLab = menPlanLab;

    QMUILabel *planLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    planLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    planLab.backgroundColor = Color_Red;
    [self addSubview:planLab];

    self.planLab = planLab;

// 本次
    QMUILabel * menThisLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:menThisLab];
    menThisLab.text = @"本次计划:";
    self.mentionThisLab = menThisLab;

    QMUILabel *thisLab = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:1];
    thisLab.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    thisLab.backgroundColor = UIColorHex(#3FD0AD);
    [self addSubview:thisLab];
    self.thisLab = thisLab;


}
-(void)buildSubview{
    CGRect rect = [self.mentionTotalLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
                                                         options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{ NSFontAttributeName:self.mentionTotalLab.font }
                                                         context:nil];
    CGFloat menWidth = ceilf(rect.size.width);
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
    //设计数量提示
    [self.mentionTotalLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleProgress.mas_top);
        make.left.equalTo(self.circleProgress.mas_right).offset(5);
        make.width.equalTo(menWidth);
     }];
// 本次计划提示
    [self.mentionThisLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mentionTotalLab.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.circleProgress.mas_right).offset(5);
        make.width.equalTo(menWidth);
        make.height.equalTo(self.mentionTotalLab.mas_height);
        make.bottom.equalTo(self.circleProgress.mas_bottom);
    }];
//设计总数
    [self.totalLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionTotalLab.mas_centerY);
        make.left.equalTo(self.mentionTotalLab.mas_right);
        make.height.equalTo(self.mentionTotalLab.mas_height);
     }];
//已计划提示
    [self.mentionPlanLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionTotalLab.mas_centerY);
        make.left.equalTo(self.totalLab.mas_right).offset(10);
        make.width.equalTo(menWidth);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
    //已计划
    [self.planLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionPlanLab.mas_centerY);
        make.left.equalTo(self.mentionPlanLab.mas_right);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(self.totalLab.mas_width);
        make.height.equalTo(self.mentionTotalLab.mas_height);
    }];
//本次计划
    [self.thisLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mentionThisLab.mas_centerY);
        make.left.equalTo(self.mentionThisLab.mas_right);
        make.height.equalTo(self.mentionThisLab.mas_height);
        make.right.mas_equalTo(self.totalLab.mas_right);
    }];
    [self.totalLab rounded:2];
    [self.planLab rounded:2];
    [self.thisLab rounded:2];
}
-(void)loadContent{
    WLJHDetialModel *model = self.data;
    self.cellDic = [NSMutableDictionary dictionaryWithDictionary:[model modelToJSONObject]];

    self.titleLab.text = model.titleStr;
    CGFloat planNum =  model.QuantityPurchased.floatValue;
    self.circleProgress.progress = floor((model.QuantityThis.floatValue + planNum )  / model.Quantity.integerValue*100)/100.0;
    self.totalLab.text = model.Quantity;
    self.planLab.text = model.QuantityPurchased;
     self.thisLab.text = model.QuantityThis;
 }


-(void)setCellDic:(NSMutableDictionary *)cellDic{
    _cellDic = cellDic;
    
    self.titleLab.text =cellDic[@"titleStr"];
     CGFloat planNum =   [cellDic[@"QuantityPurchased"] floatValue];
    self.circleProgress.progress = floor(([cellDic[@"QuantityThis"] floatValue] + planNum )  / [cellDic[@"Quantity"] integerValue]*100)/100.0;
    self.totalLab.text = cellDic[@"Quantity"];
    self.planLab.text =cellDic[@"QuantityPurchased"];
    self.thisLab.text =  cellDic[@"QuantityThis"];
}


@end
