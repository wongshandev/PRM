//
//  XMBGAlertContentView.h
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMBGDetailModel.h"


@interface XMBGAlertContentView : UIView
@property (nonatomic, strong) QMUILabel *xmbgTypeLab;
@property (nonatomic, strong) QMUIButton *typeBtn;
@property (nonatomic, strong) QMUILabel *xmbgDescriptLab;
@property(nonatomic,strong) QMUITextView *xmbgDescriptTV;
@property(nonatomic,strong) QMUIButton *fujianBtn;
@property(nonatomic,strong) UIImageView *fjImgView;

@property(nonatomic,strong) UIImageView *rightTypeImgView; 

@property(nonatomic,strong) XMBGDetailModel *detailModel;

@end


