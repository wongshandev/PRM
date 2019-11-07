//
//  XMQGDetialCell.m
//  PRM
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMQGDetialCell.h"

@interface XMQGDetialCell ()

//@property (nonatomic, strong) QMUILabel *leftCircleLab;
//@property (nonatomic, strong) QMUILabel *titleLab;
//@property (nonatomic, strong) QMUILabel *planMentLab;
//@property (nonatomic, strong) QMUILabel *planLab;

@property (nonatomic, strong) QMUILabel *titleLab;
 @property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@end
@implementation XMQGDetialCell



-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

 
    self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
    self.floatLayoutView.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
    self.floatLayoutView.minimumItemSize = CGSizeMake(20, 25);// 以2个字的按钮作为最小宽度
    [self addSubview:self.floatLayoutView];
  
}
-(void)buildSubview{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_greaterThanOrEqualTo(20); 
     }];

    [self.floatLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];

}
-(void)loadContent{
    XMQGDetialFrame *frame = self.data;
    XMQGDetialModel *model = frame.model;
     self.titleLab.text = model.Name;
    
    [self setTagViewSubviewsModel:frame];
    [self setSubViewFrameWithFrame:frame];
}

-(void)setSubViewFrameWithFrame:(XMQGDetialFrame *)frame{
    self.titleLab.frame = frame.mcF;
     self.floatLayoutView.frame = frame.tagViewF;
}

- (void)setTagViewSubviewsModel:(XMQGDetialFrame *)frame {
    [self.floatLayoutView removeAllSubviews];
    
    self.titleLab.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5 ,10);
    NSDictionary *dic = [self properties_aps:frame.model];
    [frame.model setValuesForKeysWithDictionary:dic];
    NSMutableArray<NSString *> *suggestions = [@[frame.model.BrandName,frame.model.Model ,  frame.model.QuantityDesignStr , frame.model.QuantityPurchasedStr,frame.model.QuantityStr, ] mutableCopy];
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
        [self.floatLayoutView addSubview:label];
    }
}
 

- (NSDictionary *)properties_aps:(XMQGDetialModel *)model{
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
