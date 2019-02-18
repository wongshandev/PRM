//
//  FileCell.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "FileCell.h"
#import "FileModel.h"
@interface FileCell ()

@property (nonatomic, strong) UIImageView *leftImgeView;
@property (nonatomic, strong) QMUILabel *titleLab;



@end
@implementation FileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupCell{
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    self.leftImgeView = imgView;

    QMUILabel * titlab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    titlab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titlab];
    self.titleLab = titlab;
}
-(void)buildSubview{
    [self.leftImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imageView.mas_centerY);
        make.left.mas_equalTo(self.imageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
     }];
}

-(void)loadContent{
    FileModel *model = self.data;
    self.titleLab.text = model.fileName;
    self.leftImgeView.image = SJYCommonImage([NSString matchType:model.fileName]);
}


@end
