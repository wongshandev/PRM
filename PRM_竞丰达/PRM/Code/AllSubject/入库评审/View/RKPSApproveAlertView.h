//
//  RKPSApproveAlertView.h
//  PRM
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RKPSApproveState_FD = 2, //反对
    RKPSApproveState_TY,      //同意 = 3
    RKPSApproveState_QQ, //弃权 = 4
} RKPSApproveState;

@interface RKPSApproveAlertView : UIView

@property(nonatomic,assign)RKPSApproveState state;
@property(nonatomic,strong)  QMUILabel *bzMenLab;
@property(nonatomic,strong)  QMUITextView *bzTV;

@end

NS_ASSUME_NONNULL_END
