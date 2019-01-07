//
//  UIButton+CrazyClickBlock.h
//  PRM
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#define defaultInterval 1  //默认时间间隔

typedef void (^ActionBlock)(void);

@interface UIButton (CrazyClickBlock)
    @property (nonatomic, assign) NSTimeInterval timeInterval;     //设置点击时间间隔
    @property (nonatomic, assign) BOOL isIgnore; //   用于设置单个按钮不需要被hook
    @property (readonly) NSMutableDictionary *event;
- (void)clickWithBlock:(ActionBlock)block;
    @end


