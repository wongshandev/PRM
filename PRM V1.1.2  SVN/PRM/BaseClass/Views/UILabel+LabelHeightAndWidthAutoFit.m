//
//  UILabel+LabelHeightAndWidthAutoFit.m
//  WeiLv
//
//  Created by lanouhn on 16/7/2.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import "UILabel+LabelHeightAndWidthAutoFit.h"

@implementation UILabel (LabelHeightAndWidthAutoFit)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
@end
