//
//  UIButton+CrazyClick.h
//  YYD
//
//  Created by Sonjery on 2017/8/2.
//  Copyright © 2017年 Sonjery. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 1  //默认时间间隔

@interface UIButton (CrazyClick)
    /**设置点击时间间隔*/
    @property (nonatomic, assign) NSTimeInterval timeInterval;
    /**
     *  用于设置单个按钮不需要被hook
     */
    @property (nonatomic, assign) BOOL isIgnore;
    @end
