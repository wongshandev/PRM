//
// KZSHApprovelAlertView.h
// PRM
//
// Created by apple on 2019/3/12.
// Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSInteger {
    KZSHApproveState_ZF = -1, //作废
    KZSHApproveState_TY = 7, //同意
    KZSHApproveState_BH = 3, //驳回
} KZSHApproveState;

@interface KZSHApprovelAlertView : UIView
@property(nonatomic,assign) KZSHApproveState state;
@property(nonatomic,strong) QMUILabel *bzMenLab;
@property(nonatomic,strong) QMUITextView *bzTV;
@end

NS_ASSUME_NONNULL_END
