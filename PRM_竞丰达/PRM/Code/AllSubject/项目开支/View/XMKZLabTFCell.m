//
//  XMKZLabTFCell.m
//  PRM
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMKZLabTFCell.h"
@interface XMKZLabTFCell ()
 @end
@implementation XMKZLabTFCell


- (void)didInitializeWithStyle:(UITableViewCellStyle)style {
    [super didInitializeWithStyle:style];

    self.textField = [[QMUITextField alloc]init];
    self.textField.maximumTextLength = 16;
//    self.textField.placeholder = @"请输入";
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.textLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.textLabel.mas_right);
    }];
    self.textLabel.font = Font_ListTitle;
    self.textLabel.textColor = Color_TEXT_HIGH;
    self.textField.font = Font_ListTitle;
    self.textField.textColor = Color_TEXT_NOMARL;
    self.textField.placeholderColor = Color_TEXT_WEAK;

}

- (void)updateCellAppearanceWithIndexPath:(NSIndexPath *)indexPath {
    [super updateCellAppearanceWithIndexPath:indexPath];
    self.detailTextLabel.text = nil;
}

 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 }

@end
