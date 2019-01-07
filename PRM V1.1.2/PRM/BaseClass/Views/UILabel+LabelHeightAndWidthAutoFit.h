//
//  UILabel+LabelHeightAndWidthAutoFit.h
//  WeiLv
//
//  Created by lanouhn on 16/7/2.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeightAndWidthAutoFit)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
@end
