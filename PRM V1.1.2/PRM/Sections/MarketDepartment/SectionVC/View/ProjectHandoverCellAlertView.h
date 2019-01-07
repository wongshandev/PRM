//
//  ProjectHandoverCellAlertView.h
//  PRM
//
//  Created by JoinupMac01 on 17/3/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectHandoverCellAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *projectContractButton;
@property (weak, nonatomic) IBOutlet UIButton *deviceListButton;
@property (weak, nonatomic) IBOutlet UIButton *ProjectDrawingButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;


@property(copy,nonatomic)void(^stateBlock)(BOOL isProjectContract,BOOL isDeviceList,BOOL isProjectDrawing);
@end
