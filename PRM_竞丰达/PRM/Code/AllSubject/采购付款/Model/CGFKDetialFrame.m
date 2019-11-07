//
//  CGFKDetialFrame.m
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "CGFKDetialFrame.h"


@implementation CGFKDetialModel

@end


@interface CGFKDetialFrame ()
@property(nonatomic,strong)QMUIFloatLayoutView *tagView;
@end

@implementation CGFKDetialFrame 
-(QMUIFloatLayoutView *)tagView{
    if (!_tagView) {
        _tagView = [[QMUIFloatLayoutView alloc] init];
        _tagView.padding = UIEdgeInsetsMake(5, 0, 5, 0);
        _tagView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _tagView.minimumItemSize =  CGSizeMake(10, 25);
    }
    return _tagView;
}

-(void)setModel:(CGFKDetialModel *)model{
    _model = model;

    CGFloat padding = 10;

    CGFloat mcX =  padding;
    CGFloat mcY = padding;
    CGFloat mcW = SCREEN_W- padding*2;
    CGFloat mcH = [QMUILabel getLabelHeightByWidth:(SCREEN_W- padding*2) Title:model.Name font:Font_ListTitle];
    self.mcF = CGRectMake(mcX, mcY, mcW, mcH);

    CGFloat tagViewX =mcX;
    CGFloat tagViewY = CGRectGetMaxY(self.mcF)+5;
    CGFloat tagViewW= mcW;

    self.tagView.width = tagViewW;
    CGFloat tagViewH = [self setTagViewSubviewsWithModel:model];

    self.tagViewF  = CGRectMake(tagViewX, tagViewY , tagViewW, tagViewH) ;

    self.cellHeight  = self.tagView.subviews.count==0? padding/2  + (CGRectGetMaxY(self.tagViewF)):padding*2/2 + (CGRectGetMaxY(self.tagViewF));//  padding + (CGRectGetMaxY(self.tagViewF));
}

- (CGFloat)setTagViewSubviewsWithModel:(CGFKDetialModel *)model {
    [self.tagView removeAllSubviews];

    
    NSDictionary *dic = [CGFKDetialFrame properties_aps:model];
    [model  setValuesForKeysWithDictionary:dic];

    NSMutableArray<NSString *> *suggestions = [@[model.Model , model.BrandName, model.QuantityStr , model.PriceStr ] mutableCopy];
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
        return  25;
    }

}


+ (NSDictionary *)properties_aps:(CGFKDetialModel *)model{
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
    CGFKDetialFrame *model = [[CGFKDetialFrame allocWithZone:zone] init];
    model.mcF = self.mcF;
     model.tagViewF = self.tagViewF;
    model.model = self.model;
    model.cellHeight = self.cellHeight;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    CGFKDetialFrame *model = [[CGFKDetialFrame allocWithZone:zone] init];
    model.mcF = self.mcF;
     model.tagViewF = self.tagViewF;
     model.model = self.model;
    model.cellHeight = self.cellHeight;
    return model;
}

@end
