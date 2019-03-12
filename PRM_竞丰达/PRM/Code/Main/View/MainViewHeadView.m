//
//  MainViewHeadView.m
//  PRM
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "MainViewHeadView.h"
@interface MainViewHeadView ( )
@property (strong, nonatomic)   QMUILabel *titleLab;

@end
@implementation MainViewHeadView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor= UIColorHex(#D8D8D8);
        [self setupSubView];

    }
    return self;

}
/**
   *   进行基本布局操作,根据需求进行.
   */
-(void)setupSubView{
    self.titleLab =   [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
   }

-(void)setModel:(MainModel *)model{
    _model = model;
    self.titleLab.text = model.text;
}

-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}
@end
