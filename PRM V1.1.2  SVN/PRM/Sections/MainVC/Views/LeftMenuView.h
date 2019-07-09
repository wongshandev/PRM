//
//  LeftMenuView.h
//  MicroOA
//
//  Created by JoinupMac01 on 16/9/27.
//  Copyright © 2016年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *quitAppButton;



@property(nonatomic,assign) BOOL isMenuViewHidden;
+(instancetype)shareLeftMenuView;
- (void)bindWithViewController:(UIViewController *)rootVc;
- (void)inputOfSightMenuView;
- (void)outOfSightMenuView;
@end
