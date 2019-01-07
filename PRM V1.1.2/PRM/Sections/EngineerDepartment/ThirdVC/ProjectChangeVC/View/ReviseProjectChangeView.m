//
//  ReviseProjectChangeView.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/22.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ReviseProjectChangeView.h"

@implementation ReviseProjectChangeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.changeDescriptionTV.textContainerInset = UIEdgeInsetsMake(5,0, 5, 5);    
}


@end
