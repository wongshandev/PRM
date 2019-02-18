//
//  UIButton+block.h
//  HuiBeiLife
//
//  Created by 乔学魁 on 14-5-26.
//  Copyright (c) 2014年 Zhu Lizhe. All rights reserved.
//
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);

@interface UIButton (block)
    
    @property (readonly) NSMutableDictionary *event;
    
- (void)clickWithBlock:(ActionBlock)block;
    
    
    @end
