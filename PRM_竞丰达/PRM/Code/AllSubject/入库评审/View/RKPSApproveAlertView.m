//
//  RKPSApproveAlertView.m
//  PRM
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "RKPSApproveAlertView.h"
#define TopPadding 10
#define LeftPading 15

#define LabHigh 20
#define BtnHigh 40
#define BtnWidth 70

@interface RKPSApproveAlertView ()
@property(nonatomic,strong)NSArray *buttonsArray;
@property(nonatomic,strong)  QMUILabel *stateLab;
@property(nonatomic,strong)  QMUILabel *bzMenLab;

@end
@implementation RKPSApproveAlertView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         [self buildSubView];
    }
    return self;
}


-(void)buildSubView{
    self.stateLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    self.stateLab.text = @"状态 :";
    [self addSubview:self.stateLab];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TopPadding);
        make.left.equalTo(self).offset(LeftPading);
        make.right.equalTo(self).offset(-LeftPading);
        make.height.equalTo(LabHigh);
    }];

    [self buttonArray];

    self.bzMenLab = [self createLabelWithTextColor:Color_TEXT_HIGH Font:Font_ListTitle numberOfLines:1];
    self.bzMenLab.text = @"审核意见 :";
    [self addSubview:self.bzMenLab];

     [self.bzMenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LabHigh +BtnHigh +TopPadding*3);
        make.left.equalTo(self.stateLab.mas_left);
        make.right.equalTo(self.stateLab.mas_right);
        make.height.equalTo(LabHigh);
    }];
    [self.bzTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bzMenLab.mas_bottom).offset(TopPadding);
        make.left.equalTo(self.stateLab.mas_left);
        make.right.equalTo(self.stateLab.mas_right);
        make.bottom.equalTo(self).offset(-TopPadding);
    }];
}

-(QMUITextView *)bzTV{
    if (!_bzTV) {
        _bzTV = [[QMUITextView alloc] init];
        _bzTV.shouldResponseToProgrammaticallyTextChanges = YES;
        _bzTV.shouldCountingNonASCIICharacterAsTwo = YES;
        _bzTV.font = Font_ListTitle;
        _bzTV.placeholder = @"请输入(限128字)";
        _bzTV.maximumTextLength = 256;
        _bzTV.maximumHeight = 90;
        [_bzTV rounded:5 width:2 color:Color_LINE_NOMARL];
        [self addSubview:_bzTV];
    }
    return _bzTV;
}

-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number {
    QMUILabel *label = [[QMUILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = number;
    return label;
}


-(NSMutableArray *)buttonArray{
    NSMutableArray* buttons = [NSMutableArray new];
//    NSArray *array =@[@"同意",@"反对",@"弃权"]; // 324   012
    NSArray *array =@[@"同意",@"弃权",@"反对"]; // 342   012
    CGRect btnRect = CGRectMake(LeftPading, TopPadding*2 + LabHigh, BtnWidth, BtnHigh);

    for (NSInteger i =0; i <array.count; i++) {
        NSString *optionTitle = array[i];
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"deselect_1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self addSubview:btn];
        [buttons addObject:btn];
        btnRect.origin.x += BtnWidth+TopPadding;
    }
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    [buttons[0] setSelected:YES]; // Making the first button initially selected
    self.bzMenLab.text = @"审核意见 :";
    self.state = RKPSApproveState_TY; //同意
    return buttons;
}

-(void)onRadioButtonValueChanged:(RadioButton*)sender {
     if(sender.selected) {
         switch (sender.tag -1000) {
             case 0:{
                 self.state = RKPSApproveState_TY;
                 self.bzMenLab.text = @"审核意见 :";
             }
                 break;
             case 1:{
                 self.state = RKPSApproveState_QQ;
                 self.bzMenLab.text = @"审核意见 :";
             }
                 break;
             case 2: {
                 self.state = RKPSApproveState_FD;
                 self.bzMenLab.text = @"反对理由 :";
             }
                 break;
             default:
                 break;
         }
     }
}
@end
