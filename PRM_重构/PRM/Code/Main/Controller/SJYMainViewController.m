//
//  SJYMainViewController.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYMainViewController.h"

 @implementation SJYMainViewController

- (void)setUpNavigationBar{
     self.navBar.backButton.hidden = YES;
    self.navBar.leftButton.hidden = NO;
    self.navBar.titleLabel.text = DisplayName;

    [self.navBar.leftButton setImage:SJYCommonImage(@"caidan") forState:UIControlStateNormal];
    [self.navBar.leftButton clickWithBlock:^{
        if (![[SJYDefaultManager shareManager] isRemberPassword]) {
            [[SJYDefaultManager shareManager]saveUserName:@"" password:@""];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(void)buildSubviews{

}


@end
