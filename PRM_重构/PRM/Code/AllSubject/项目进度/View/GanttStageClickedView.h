//
//  GanttStageClickedView.h
//  MicroOAForCompany
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StasticGanttModel.h"

@interface GanttStageClickedView : UIView

- (instancetype)init;
@property(nonatomic,assign)StasticGanttModel *ganttModel;
@property(nonatomic,assign)CGFloat viewHeight;

@end
