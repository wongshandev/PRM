//
//  DXNavBarView.m
//  DaXueZhang
//
//  Created by Sonjery on 2018/7/13.
//  Copyright © 2018年 Sonjery. All rights reserved.
//

#import "DXNavBarView.h"

@implementation DXNavBarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initialize];
         [self setNeedsLayout];
    }
    return self;
}

//-(void) statusFrameChanged:(NSNotification*) note {
//    CGRect statusBarFrame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
//    CGFloat statusHeight = statusBarFrame.size.height;
//    UIScreen *screen = [UIScreen mainScreen];
//    CGRect viewRect = screen.bounds;
//    viewRect.size.height -= statusHeight;
//    viewRect.origin.y = statusHeight;
//    self.frame = viewRect;
//    [self setNeedsLayout];
//}

//
//progress

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(5);
    }];

     [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NAVNOMARLHEIGHT-44);
        make.left.equalTo(self).offset(0);
        //        make.width.mas_equalTo(SCREEN_W*0.12);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(44);
    }];

     [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NAVNOMARLHEIGHT-44);
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(SJYNUM(56));
        make.height.mas_equalTo(44);
    }];

     [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NAVNOMARLHEIGHT-44);
        make.right.equalTo(self).offset(0);
        make.width.mas_equalTo(SJYNUM(56));
        make.height.mas_equalTo(44);
    }];

     [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(NAVNOMARLHEIGHT-44);
//        make.centerX.equalTo(self).offset(0);
//        make.height.mas_equalTo(44);
//         make.width.mas_equalTo(SJYNUM(180));

         make.top.equalTo(self).offset(NAVNOMARLHEIGHT-44);
         make.height.mas_equalTo(44);
         make.left.mas_equalTo(self.leftButton.mas_right);
         make.right.mas_equalTo(self.rightButton.mas_left);
    }];

     [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(NAVNOMARLHEIGHT-44);
//        make.centerX.equalTo(self).offset(0);
//        make.width.mas_equalTo(SJYNUM(180));
//        make.height.mas_equalTo(44);

         make.centerY.mas_equalTo(self.titleView.mas_centerY);
         make.left.mas_equalTo(self.titleView.mas_left);
         make.right.mas_equalTo(self.titleView.mas_right);
    }];
     [self.seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self) ;
        make.height.mas_equalTo(1);
    }];
}

- (void)initialize{
    [self addSubview:self.backView];
    
    [self addSubview:self.shadowView];

    [self addSubview:self.backButton]; 

    [self addSubview:self.leftButton];

    self.leftButton.hidden=YES;
    
    [self addSubview:self.rightButton];

    self.rightButton.hidden=YES;
    
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];

    [self addSubview:self.seperateLine];


}

-(UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.textColor= Color_White;
        _titleLabel.font= SJYBoldFont(18);//[UIFont boldSystemFontOfSize:SJYNUM(18)];
//        _titleLabel.textAlignment=NSTextAlignmentCenterr;
//         _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;    //中间的内容以…方式省略，显示头尾
    }
    return _titleLabel;
}

-(UIView *)titleView{
    if (_titleView==nil) {
        _titleView=[[UIView alloc] init];
        _titleView.backgroundColor=[UIColor clearColor];
    }
    return _titleView;
}

-(UIView *)backView{
    if (_backView==nil) {
        _backView=[[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor=Color_NavigationLightBlue;
    }
    return _backView;
}

-(UIButton *)backButton{
    if (_backButton==nil) {
        _backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:SJYCommonImage(@"frontPage") forState:UIControlStateNormal];
    }
    return _backButton;
}

-(UIButton *)leftButton{
    if (_leftButton==nil) {
        _leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitleColor:Color_White forState:UIControlStateNormal];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
     }
    return _leftButton;
}

-(UIButton *)rightButton{
    if (_rightButton==nil) {
        _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font=Font_System(16);
        [_rightButton setTitleColor:Color_White forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
 
    }
    return _rightButton;
}
-(UILabel *)seperateLine{
    if (_seperateLine == nil) {
        _seperateLine = [[UILabel alloc] init];
        _seperateLine.hidden = YES;
        _seperateLine.backgroundColor = Color_SrprateLine;
    }
    return _seperateLine;
}

-(UIView *)shadowView{
    if (_shadowView==nil) {
        _shadowView=[[UIImageView alloc] init];
        _shadowView.image = [UIImage imageNamed:@"shangfangtouying"];
    }
    return _shadowView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
