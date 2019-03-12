//
//  RKPSListModelFrame.m
//  PRM
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RKPSListModelFrame.h"
#define Padding  10

@interface RKPSListModelFrame ()
@property (nonatomic, strong) QMUIFloatLayoutView *tagsView;
@end
@implementation RKPSListModelFrame

 -(QMUIFloatLayoutView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[QMUIFloatLayoutView alloc] init];
        _tagsView.padding = UIEdgeInsetsMake(5, 0, 5, 0);
        _tagsView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _tagsView.minimumItemSize =  CGSizeMake(10, 25);
    }
    return _tagsView;
}

-(void)setModel:(RKPSListModel *)model{
    _model = model;

    CGFloat mcX = Padding;
    CGFloat mcY = Padding;
    CGFloat mcW = SCREEN_W- Padding*2;
    CGFloat mcH = [QMUILabel getLabelHeightByWidth:mcW Title:model.titleNameDetial font:Font_ListTitle];
    self.mcF = CGRectMake(mcX, mcY, mcW, mcH);

    CGFloat tagViewX = mcX;
    CGFloat tagViewY = CGRectGetMaxY(self.mcF) + Padding;
    CGFloat tagViewW= mcW;
    self.tagsView.width = tagViewW;

    
    CGFloat tagViewH =  [self setTagViewSubviewsWithModel:model];
    self.tagViewF  = CGRectMake(tagViewX, tagViewY , tagViewW, tagViewH );

    self.sep1F = CGRectMake(0, CGRectGetMaxY(self.tagViewF) +Padding  , SCREEN_W, 1);

    CGFloat bzMenH = [QMUILabel getLabelHeightByWidth:mcW Title:@"备注" font:Font_ListTitle];
    self.bzMenF = CGRectMake(Padding, CGRectGetMaxY(self.sep1F) +Padding, mcW, bzMenH);

    CGFloat bzH = [QMUILabel getLabelHeightByWidth:mcW Title:model.Remark font:Font_ListTitle];
    self.bzF = CGRectMake(Padding,CGRectGetMaxY(self.bzMenF) +Padding, mcW, bzH);

    self.sep2F = CGRectMake(0, CGRectGetMaxY(self.bzF) +Padding  ,SCREEN_W, 1);

    CGFloat reasonMenH = [QMUILabel getLabelHeightByWidth:mcW Title:@"添加原因" font:Font_ListTitle];
    self.reasonMenF = CGRectMake(Padding,CGRectGetMaxY(self.sep2F) +Padding , mcW, reasonMenH);

    CGFloat reasonH = [QMUILabel getLabelHeightByWidth:mcW Title:model.Reason font:Font_ListTitle];
    self.reasonF = CGRectMake(Padding,CGRectGetMaxY(self.reasonMenF) +Padding , mcW,reasonH);

    self.viewHeight = self.tagsView.subviews.count==0? Padding  + (CGRectGetMaxY(self.reasonF)):Padding*2 + (CGRectGetMaxY(self.reasonF));

}


- (CGFloat)setTagViewSubviewsWithModel:(RKPSListModel*)model {
    [self.tagsView removeAllSubviews];
    NSMutableArray<NSString *> *suggestions = [@[model.stockChildNameStr, model.BrandName,model.Specifications,model.Model,model.WeightStr,model.PriceStr] mutableCopy];
    if([suggestions containsObject:@""]){
        [suggestions removeObject:@""];
    }
    for (NSInteger i = 0; i < suggestions.count; i++) {
        QMUILabel *label = [[QMUILabel alloc] init];
        [label rounded:3];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = Color_NavigationLightBlue;
        label.textColor = Color_White;
        label.font = Font_System(14);
        label.text = suggestions[i];
        label.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        [self.tagsView addSubview:label];
    }

    CGFloat contentWith =  self.tagsView.width;
    CGSize tagsViewSize = [self.tagsView sizeThatFits:CGSizeMake(contentWith, CGFLOAT_MAX)];

    if (self.tagsView.subviews.count != 0) {
        return tagsViewSize.height;
    }else{
        return  0;
    }

}


+ (NSDictionary *)properties_aps:( RKPSListModel*)model{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [model valueForKey:(NSString *)propertyName];
        if (propertyValue==nil) {
            propertyValue = @"";
        }
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}


 

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    RKPSListModelFrame *model = [[RKPSListModelFrame allocWithZone:zone] init];
    model.model = self.model;
    model.mcF = self.mcF;
    model.tagViewF = self.tagViewF;
    model.sep1F = self.sep1F;
    model.sep2F = self.sep2F;
    model.bzMenF = self.bzMenF;
    model.bzF = self.bzF;
    model.reasonMenF = self.reasonMenF;
    model.reasonF = self.reasonF;
    model.viewHeight = self.viewHeight;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    RKPSListModelFrame *model = [[RKPSListModelFrame allocWithZone:zone] init];
    model.model = self.model;
    model.mcF = self.mcF;
    model.tagViewF = self.tagViewF;
    model.sep1F = self.sep1F;
    model.sep2F = self.sep2F;
    model.bzMenF = self.bzMenF;
    model.bzF = self.bzF;
    model.reasonMenF = self.reasonMenF;
    model.reasonF = self.reasonF;
    model.viewHeight = self.viewHeight;
    return model;
}

@end
