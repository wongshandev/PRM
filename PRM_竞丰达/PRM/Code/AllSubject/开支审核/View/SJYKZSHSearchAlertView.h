//
//  SJYKZSHSearchAlertView.h
//  PRM
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJYKZSHSearchAlertView : UIView
@property (nonatomic, strong) QMUILabel *stateLab;
@property (nonatomic, strong) QMUIButton *stateBtn;
@property (nonatomic, strong) QMUILabel *typeLab;
@property (nonatomic, strong) QMUIButton *typeBtn;
@property(nonatomic,strong) UIImageView *rightStateImgView;
@property(nonatomic,strong) UIImageView *rightTypeImgView;


-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
