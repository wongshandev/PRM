//
//  SearchSelectView.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/28.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSelectView : UIView
@property (weak, nonatomic) IBOutlet UIButton *teamLeaderButton;
@property (weak, nonatomic) IBOutlet UIButton *ProjectManagerButton;
@property (weak, nonatomic) IBOutlet UIButton *mainDesignButton;
@property (weak, nonatomic) IBOutlet UIButton *assistDesignButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
