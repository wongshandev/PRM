//
//  RKPSDetialView.m
//  PRM
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RKPSDetialView.h"
@interface RKPSDetialView()
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUIFloatLayoutView *tagsView;

@property (nonatomic, strong) QMUILabel *bzMenLab;
@property (nonatomic, strong) QMUILabel *bzLab;
@property (nonatomic, strong) QMUILabel *sepLab1;

@property (nonatomic, strong) QMUILabel *reasonMenLab;
@property (nonatomic, strong) QMUILabel *reasonLab;
@property (nonatomic, strong) QMUILabel *sepLab2;

@end
@implementation RKPSDetialView

 
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpSubView];
      }
    return self;
}

-(void)setUpSubView{
    self.titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:self.titleLab];

    QMUIFloatLayoutView *tagsView = [[QMUIFloatLayoutView alloc]init];
     tagsView = [[QMUIFloatLayoutView alloc] init];
     tagsView.padding = UIEdgeInsetsMake(5, 0, 5, 0);
     tagsView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
     tagsView.minimumItemSize = CGSizeMake(10, 25);// 以2个字的按钮作为最小宽度
    [self addSubview:tagsView];
    self.tagsView = tagsView;

    self.sepLab1 = [[QMUILabel alloc]init];
    self.sepLab1.backgroundColor = Color_TEXT_WEAK;
    [self addSubview:self.sepLab1];

    self.bzMenLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    self.bzMenLab.text = @"备注";
    [self addSubview:self.bzMenLab];

    self.bzLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListTitle numberOfLines:0];
    [self addSubview:self.bzLab];

    self.sepLab2 = [[QMUILabel alloc]init];
    self.sepLab2.backgroundColor = Color_TEXT_WEAK;
    [self addSubview:self.sepLab2];

    self.reasonMenLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    self.reasonMenLab.text = @"添加原因";
    [self addSubview:self.reasonMenLab];

    self.reasonLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListTitle numberOfLines:0];
    [self addSubview:self.reasonLab];
}

-(void)setModelFrame:(RKPSListModelFrame *)modelFrame{
    _modelFrame = modelFrame;

    self.titleLab.text = modelFrame.model.titleNameDetial;
    [self setTagViewSubviewsModel:modelFrame.model];
    self.bzLab.text = modelFrame.model.Remark;
    self.reasonLab.text = modelFrame.model.Reason;

    self.titleLab.frame = modelFrame.mcF;
    self.tagsView.frame = modelFrame.tagViewF;
    self.sepLab1.frame = modelFrame.sep1F;
    self.sepLab2.frame = modelFrame.sep2F;
    self.bzMenLab.frame = modelFrame.bzMenF;
    self.bzLab.frame = modelFrame.bzF;
    self.reasonMenLab.frame = modelFrame.reasonMenF;
    self.reasonLab.frame = modelFrame.reasonF; 
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), modelFrame.viewHeight);
} 

- (void)setTagViewSubviewsModel:(RKPSListModel*)model {
    [self.tagsView removeAllSubviews]; 
    NSMutableArray<NSString *> *suggestions = [@[model.stockChildNameStr, model.BrandName,model.Specifications,model.Model,model.WeightStr,model.PriceStr] mutableCopy];
    if([suggestions containsObject:@""]){
        [suggestions removeObject:@""];
    }
    for (NSInteger i = 0; i < suggestions.count; i++) {
        QMUILabel *label = [[QMUILabel alloc] init];
        [label rounded:3];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.backgroundColor = Color_NavigationLightBlue;
        label.textColor = Color_White;
        label.font = Font_System(14);
        label.text = suggestions[i];
        label.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        [self.tagsView addSubview:label];
    }
}

-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}
@end
