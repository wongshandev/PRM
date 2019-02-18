//
//  DXNavBarView.h
//  DaXueZhang
//
//  Created by qiaoxuekui on 2018/7/13.
//  Copyright © 2018年 qiaoxuekui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXNavBarView : UIView
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * seperateLine;
@property (nonatomic, strong) UIImageView * shadowView;
@end
