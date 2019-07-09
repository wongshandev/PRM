//
//  ReviseProjectChangeView.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/22.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviseProjectChangeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *changeTypeButton;
@property (weak, nonatomic) IBOutlet UITextView *changeDescriptionTV;
@property (weak, nonatomic) IBOutlet UILabel *filePathLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectFileButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
