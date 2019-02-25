//
//  ScrollGanttView.h
//  MicroOAForCompany
//
//  Created by apple on 2018/6/5.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StasticGanttModel.h"
 @interface ScrollGanttView : UIScrollView

 @property(nonatomic,strong)NSMutableArray *ganttArray;

-(instancetype)initWithFrame:(CGRect)frame  yAlexArray:(NSArray *)yalexArray withXminDateStr:(NSString *)xminStr withXmaxDateStr:(NSString *)xmaxStr titleStr:(NSString *)title;

@end
