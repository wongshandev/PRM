//
//  XMQGDetialModel.m
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMQGDetialFrame.h"

@implementation XMQGDetialModel

@end



@interface XMQGDetialFrame()
@property(nonatomic,strong)QMUIFloatLayoutView *tagView;
@end

@implementation XMQGDetialFrame
-(QMUIFloatLayoutView *)tagView{
    if (!_tagView) {
        _tagView = [[QMUIFloatLayoutView alloc] init];
        _tagView.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        _tagView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _tagView.minimumItemSize =  CGSizeMake(20, 25);
    }
    return _tagView;
}

-(void)setModel:(XMQGDetialModel *)model{
    _model = model;

    CGFloat padding = 10;
 
    CGFloat mcX =  padding;
    CGFloat mcY = padding;
    CGFloat mcW = SCREEN_W- padding *2;
    CGFloat titH = [QMUILabel getLabelHeightByWidth:mcW Title:model.Name font:Font_ListTitle];
    CGFloat mcH = titH<20?20:titH;
    self.mcF = CGRectMake(mcX, mcY, mcW, mcH);

    CGFloat tagViewX = mcX;
    CGFloat tagViewY =  CGRectGetMaxY(self.mcF);
    CGFloat tagViewW= SCREEN_W - padding *2;
    self.tagView.width = tagViewW;
    CGFloat tagViewH = [self setTagViewSubviewsWithModel:model];
    self.tagViewF  = CGRectMake(tagViewX, tagViewY , tagViewW, tagViewH);
    self.cellHeight  =  self.tagView.subviews.count==0? padding  + (CGRectGetMaxY(self.tagViewF)): padding*2 + (CGRectGetMaxY(self.tagViewF));
}


- (CGFloat)setTagViewSubviewsWithModel:(XMQGDetialModel *)model {
    [self.tagView removeAllSubviews];
    if (model._parentId.integerValue == 0) {
        return 0;
    }
    NSDictionary *dic = [self properties_aps:model];
    [model setValuesForKeysWithDictionary:dic];

    NSMutableArray<NSString *> *suggestions = [@[model.BrandName,model.Model , model.QuantityDesignStr , model.QuantityPurchasedStr ,model.QuantityStr ] mutableCopy];
    if([suggestions containsObject:@""]){
        [suggestions removeObject:@""];
    }
    for (NSInteger i = 0; i < suggestions.count; i++) {
        QMUILabel *label = [[QMUILabel alloc] init];
        label.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        [label rounded:3];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = Color_NavigationLightBlue;
        label.textColor = Color_White;
        label.font = Font_System(14);
        label.text = suggestions[i];
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
    XMQGDetialFrame *model = [[XMQGDetialFrame allocWithZone:zone] init];
    model.mcF = self.mcF;
    model.tagViewF = self.tagViewF;
     model.model = self.model;
    model.cellHeight = self.cellHeight;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    XMQGDetialFrame *model = [[XMQGDetialFrame allocWithZone:zone] init];
    model.mcF = self.mcF;
    model.tagViewF = self.tagViewF;
     model.model = self.model;
    model.cellHeight = self.cellHeight;
    return model;
}
 
-(NSDictionary *)properties_aps:(XMQGDetialModel *)model{
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
