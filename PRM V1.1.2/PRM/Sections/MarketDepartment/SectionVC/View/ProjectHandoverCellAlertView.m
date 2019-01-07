//
//  ProjectHandoverCellAlertView.m
//  PRM
//
//  Created by JoinupMac01 on 17/3/8.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProjectHandoverCellAlertView.h"

@implementation ProjectHandoverCellAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    NSInteger isEnable =[[[UserDefaultManager shareUserDefaultManager]getDepartmentID]integerValue];
    if (isEnable==1) {
        self.deviceListButton.userInteractionEnabled= YES;
        self.ProjectDrawingButton.userInteractionEnabled = YES;
        self.projectContractButton.userInteractionEnabled = YES;        
    }else{
        self.deviceListButton.userInteractionEnabled= NO;
        self.projectContractButton.userInteractionEnabled = NO;
        self.ProjectDrawingButton.userInteractionEnabled = NO;
        [self.deviceListButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
        [self.projectContractButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
        [self.ProjectDrawingButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}

- (IBAction)tapGuesterAction:(id)sender {
//    [self removeFromSuperview];
}
- (IBAction)projectContractAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"deSelect"] forState:UIControlStateNormal];
    }
    self.stateBlock(sender.selected?YES:NO,self.deviceListButton.selected?YES:NO,self.ProjectDrawingButton.selected?YES:NO);
}
- (IBAction)deviceListButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"deSelect"] forState:UIControlStateNormal];
    }
    self.stateBlock(self.projectContractButton.selected?YES:NO,sender.selected?YES:NO,self.ProjectDrawingButton.selected?YES:NO);
}
- (IBAction)projectDrawingButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"deSelect"] forState:UIControlStateNormal];
    }
    self.stateBlock(self.projectContractButton.selected?YES:NO,self.deviceListButton.selected?YES:NO,sender.selected?YES:NO);
}


@end
