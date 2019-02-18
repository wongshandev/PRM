//
//  UIButton+block.m
//  HuiBeiLife
//
//  Created by 乔学魁 on 14-5-26.
//  Copyright (c) 2014年 Zhu Lizhe. All rights reserved.
//

#import "UIButton+block.h"

@implementation UIButton (block)
    
    static char overviewKey;
    
    @dynamic event;
    
- (void)clickWithBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}
    
    
- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}
    
    @end
