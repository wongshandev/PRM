//
//  BJQDListFrame.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BJQDListFrame.h"
@implementation BJQDListModel
+(NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"NOStr":@"NO",
//             @"sex":@"sexDic.sex" // 声明sex字段在sexDic下的sex
             };
}

@end


#pragma mark   ============    BJQDListFrame


@interface BJQDListFrame()
@property(nonatomic,strong)QMUIFloatLayoutView *tagView;
@end

@implementation BJQDListFrame
-(QMUIFloatLayoutView *)tagView{
    if (!_tagView) {
        _tagView = [[QMUIFloatLayoutView alloc] init];
        _tagView.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        _tagView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _tagView.minimumItemSize =  CGSizeMake(50, 25);
    }
    return _tagView;
}

-(void)setModel:(BJQDListModel *)model{
    _model = model;
    
    CGFloat padding = 10;

    CGFloat moneyY = padding;
    CGFloat moneyW = 80;
    CGFloat moneyX = SCREEN_W- padding - 80;
    CGFloat mH = [QMUILabel getLabelHeightByWidth:80 Title:model.QuotedPriceStr font:Font_ListOtherTxt];
    CGFloat moneyH = mH<20?20:mH;
    self.moneyF = CGRectMake(moneyX,moneyY, moneyW, moneyH);

    CGFloat mcX =  padding;
    CGFloat mcY = padding;
    CGFloat mcW = SCREEN_W- padding *2- moneyW;
    CGFloat titH = [QMUILabel getLabelHeightByWidth:mcW Title:model.Name font:Font_ListTitle];
    CGFloat mcH = titH<20?20:titH;
    self.mcF = CGRectMake(mcX, mcY, mcW, mcH);

    CGFloat tagViewX =mcX;
    CGFloat tagViewY = MAX(CGRectGetMaxY(self.mcF) , CGRectGetMaxY(self.moneyF));
    CGFloat tagViewW= SCREEN_W - padding *2;
    self.tagView.width = tagViewW;
    CGFloat tagViewH = [self setTagViewSubviewsWithModel:model];
    self.tagViewF  = CGRectMake(tagViewX, tagViewY , tagViewW, tagViewH);
    self.cellHeight  =  padding + (CGRectGetMaxY(self.tagViewF));
}


- (CGFloat)setTagViewSubviewsWithModel:(BJQDListModel *)model {
    [self.tagView removeAllSubviews];
    if (model._parentId.integerValue == 0  || model.IsSubTotal.boolValue ) {
        return 0;
    }
    NSDictionary *dic = [self properties_aps:model];
    [model setValuesForKeysWithDictionary:dic];

    NSMutableArray<NSString *> *suggestions = [@[model.StockTypeName,model.Model , model.BrandName, model.QuantityStr , model.UnitQuotedPriceStr ] mutableCopy];
    if([suggestions containsObject:@""]){
        [suggestions removeObject:@""];
    }
    for (NSInteger i = 0; i < suggestions.count; i++) {
        QMUILabel *label = [[QMUILabel alloc] init];
        [label rounded:3];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = Color_NavigationLightBlue;
        label.textColor = Color_White;
        label.font = Font_System(14);
        label.text = suggestions[i];
        label.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        [self.tagView addSubview:label];
    }
    CGFloat contentWith =  self.tagView.width;
    CGSize tagViewSize = [self.tagView sizeThatFits:CGSizeMake(contentWith, CGFLOAT_MAX)];
    if (self.tagView.subviews.count!= 0) {
        return tagViewSize.height;
    }else{
        return  0;
    }
}
 

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    BJQDListFrame *model = [[BJQDListFrame allocWithZone:zone] init];
    model.mcF = self.mcF;
    model.tagViewF = self.tagViewF;
    model.moneyF = self.moneyF;
    model.model = self.model;
    model.cellHeight = self.cellHeight;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    BJQDListFrame *model = [[BJQDListFrame allocWithZone:zone] init];
    model.mcF = self.mcF;
    model.tagViewF = self.tagViewF;
    model.moneyF = self.moneyF;
    model.model = self.model;
    model.cellHeight = self.cellHeight;
    return model;
}
 
-(NSDictionary *)properties_aps:(BJQDListModel *)model{
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

@end
