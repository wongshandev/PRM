//
//  CGFKDetialCell.m
//  PRM
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "CGFKDetialCell.h"
@interface CGFKDetialCell()

@property (nonatomic, strong) QMUILabel *titleLab;

@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView; 

@end
@implementation CGFKDetialCell


-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;



    self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
    self.floatLayoutView.padding = UIEdgeInsetsMake(5, 0, 5, 5);
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
    self.floatLayoutView.minimumItemSize = CGSizeMake(50, 25);// 以2个字的按钮作为最小宽度
    [self addSubview:self.floatLayoutView];


}
-(void)buildSubview{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];

    [self.floatLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];

}

-(void)loadContent{

    CGFKDetialFrame *frame = self.data;
    [self setSubViewDataWithModel:frame];
    self.titleLab.text = frame.model.Name;
    [self setSubViewFrameWithFrame:frame];
}
 

-(void)setSubViewDataWithModel:(CGFKDetialFrame *)model {
    [self.floatLayoutView removeAllSubviews];
    [self setTagViewSubviewsModel:model];
}

-(void)setSubViewFrameWithFrame:(CGFKDetialFrame *)frame{
     self.titleLab.frame = frame.mcF;
    self.floatLayoutView.frame = frame.tagViewF;
 }


- (void)setTagViewSubviewsModel:(CGFKDetialFrame *)frame {
    [self.floatLayoutView removeAllSubviews];
    NSMutableArray<NSString *> *suggestions = [@[frame.model.Model , frame.model.BrandName, frame.model.QuantityStr , frame.model.PriceStr ] mutableCopy];
//    NSMutableArray<NSString *> *suggestions = [@[frame.model.Model , frame.model.BrandName, frame.model.QuantityStr] mutableCopy];
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
        [self.floatLayoutView addSubview:label];
    }
}


@end

#pragma mark ===================== CGFKDetialFootCell

@interface CGFKDetialFootCell()

@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *moneyLab;


@end
@implementation CGFKDetialFootCell

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *moneyLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:0];
    moneyLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLab];
    self.moneyLab = moneyLab;

}
-(void)buildSubview{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
     }];

    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];

}

-(void)loadContent{
    CGFKDetialModel *model = self.data;
    self.titleLab.text = model.Name;
     self.moneyLab.text = [NSString numberMoneyFormattor:model.Price];

}




 @end


