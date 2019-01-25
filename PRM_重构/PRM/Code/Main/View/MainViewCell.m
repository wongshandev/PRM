//
//  MainViewCell.m
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "MainViewCell.h"
#define  TopImgHigh       60
#define   TopImgWidth    60

@interface MainViewCell ( )
@property (strong, nonatomic)   UIImageView *mainImageView;
@property (strong, nonatomic)   QMUILabel *mainTitleLabe;

@end
@implementation MainViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)index{
    static NSString * identifier = @"MainViewCell";
    MainViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:identifier  forIndexPath:index];
    if (cell == nil) {
        [collectionView  registerClass:NSClassFromString(identifier) forCellWithReuseIdentifier: identifier];

        //        cell = [[DXGameVideoItemCell alloc] init];
        cell =  [collectionView  dequeueReusableCellWithReuseIdentifier:identifier  forIndexPath:index];
    }
    return  cell;
}

-(instancetype)init{
    if (self = [super init]) {
        [self buildSubViews];
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildSubViews];
        [self layoutSubviews];
    }
    return self;
}

-(void)buildSubViews{
    self.mainImageView = [[UIImageView alloc] init];
     self.mainImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.mainImageView];

    self.mainTitleLabe = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
     self.mainTitleLabe.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.mainTitleLabe];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.mainImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SJYNUM(5));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(TopImgWidth);
        make.height.mas_equalTo(TopImgHigh);
    }];

    [ self.mainTitleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainImageView.mas_bottom).offset(SJYNUM(5));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SJYNUM(20));
    }];
    [self.contentView rounded:3];
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
-(void)showMainCellDataWithModel:(MainModel *)model{
    NSString *imageStr = [model.iconURL stringByReplacingOccurrencesOfString:@"../.." withString:API_ImageUrl];
    NSURL *icomUrl = [NSURL URLWithString:imageStr];
    [self.mainImageView sd_setImageWithURL:icomUrl placeholderImage:[UIImage imageNamed:@"faliureImg"] options:SDWebImageRefreshCached];
    self.mainTitleLabe.text = [NSString stringWithFormat:@"%@",model.text];
}

-(QMUILabel*)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}

@end
