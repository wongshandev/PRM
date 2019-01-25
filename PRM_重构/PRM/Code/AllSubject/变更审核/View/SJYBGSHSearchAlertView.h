//
//  SJYBGSHSearchAlertView.h
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJYBGSHSearchAlertView : UIView
@property (nonatomic, strong) QMUILabel *stateLab;
@property (nonatomic, strong) QMUIButton *stateBtn;
@property (nonatomic, strong) QMUILabel *codeLab;
@property(nonatomic,strong)  QMUITextField *codeTF;
 @property(nonatomic,strong) QMUILabel *sepLine;
@property(nonatomic,strong) UIImageView *rightdownImgView;


-(QMUILabel *)createLabelWithTextColor:(UIColor *)textColor Font:(UIFont *)font numberOfLines:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END
