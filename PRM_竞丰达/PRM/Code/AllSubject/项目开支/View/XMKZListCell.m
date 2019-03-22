//
//  XMKZListCell.m
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMKZListCell.h"
@interface XMKZListCell()

@property (nonatomic, strong) QMUILabel *leftCircleLab;
@property (nonatomic, strong) QMUILabel *titleLab;
@property (nonatomic, strong) QMUILabel *addressLab;

@property (nonatomic, strong) QMUILabel *contractMenLab;
@property (nonatomic, strong) QMUILabel *contractLab;

@property (nonatomic, strong) QMUILabel *reimburseMenLab;
@property (nonatomic, strong) QMUILabel *reimburseLab;

@end
@implementation XMKZListCell


//+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static   NSString *identifier = @"SGGLXCSHListCell";
//    XMBGListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[SGGLXCSHListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//    }
//    return cell;
//}

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    QMUILabel *leftCircle = [self createLabelWithTextColor:Color_White Font:Font_EqualWidth(13) numberOfLines:0];
//    leftCircle.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    leftCircle.textAlignment = NSTextAlignmentCenter;
    leftCircle.backgroundColor = Color_NavigationBlue;
    [self addSubview:leftCircle];

    self.leftCircleLab = leftCircle;

    QMUILabel *titleLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:0];
    [self addSubview:titleLab];
    self.titleLab = titleLab;

    QMUILabel *addressLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:0];
    [self addSubview:addressLab];
    self.addressLab = addressLab;

    QMUILabel *contractMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    contractMenLab.text = @"合同金额(万元):";
    [self addSubview:contractMenLab];
    self.contractMenLab = contractMenLab;

    QMUILabel *contractLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:contractLab];
    self.contractLab = contractLab;

    QMUILabel *reimburseMenLab = [self createLabelWithTextColor:Color_TEXT_NOMARL Font:Font_ListOtherTxt numberOfLines:1];
    reimburseMenLab.text = @"报销金额(元)    :";
    [self addSubview:reimburseMenLab];
    self.reimburseMenLab = reimburseMenLab;

    QMUILabel *reimburseLab = [self createLabelWithTextColor:Color_Red Font:Font_ListOtherTxt numberOfLines:1];
    [self addSubview:reimburseLab];
    self.reimburseLab = reimburseLab;
}
-(void)buildSubview{
    [self.leftCircleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(10);
        make.height.equalTo(50);
        make.width.equalTo(50);
    }];
    [self.leftCircleLab rounded:25];

    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
     }];
    [self.addressLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.left.equalTo(self.leftCircleLab.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
     }];

    CGRect rect = [self.contractMenLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
                                                         options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{ NSFontAttributeName:self.contractMenLab.font }
                                                         context:nil];
    CGFloat menWidth = ceilf(rect.size.width);
     [self.contractMenLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLab.mas_bottom);
        make.left.equalTo(self.titleLab.mas_left);
        make.width.equalTo(menWidth);
        make.height.equalTo(20);
     }];
    [self.contractLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contractMenLab.mas_centerY);
        make.left.equalTo(self.contractMenLab.mas_right);
        make.height.equalTo(self.contractMenLab.mas_height);
        make.right.equalTo(self).offset(-10);
     }];
    [self.reimburseMenLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contractMenLab.mas_bottom);
        make.left.equalTo(self.titleLab.mas_left);
        make.width.equalTo(menWidth);
        make.height.equalTo(20);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.reimburseLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.reimburseMenLab.mas_centerY);
        make.left.equalTo(self.reimburseMenLab.mas_right);
        make.height.equalTo(self.contractMenLab.mas_height);
        make.right.equalTo(self).offset(-10);
     }];

}
-(void)loadContent{
    XMKZListModel *model = self.data;
    self.titleLab.text = model.titleStr;
    self.leftCircleLab.text = model.Code;
    self.addressLab.text = model.Address;
    self.contractLab.text = [NSString numberMoneyFormattor:model.Budget];
    self.reimburseLab.text = [NSString numberMoneyFormattor:model.SpendingPrice];
}

 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 }
@end
