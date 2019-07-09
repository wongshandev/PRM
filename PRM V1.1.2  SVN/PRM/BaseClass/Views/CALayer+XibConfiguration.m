//
//  CALayer+XibConfiguration.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/13.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
-(void)setBorderUIColor:(UIColor *)color{
    self.borderColor = color.CGColor;
}

-( UIColor *)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];    
}


@end
