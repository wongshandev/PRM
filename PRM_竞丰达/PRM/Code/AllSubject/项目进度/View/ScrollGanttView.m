//
//  ScrollGanttView.m
//  MicroOAForCompany
//
//  Created by apple on 2018/6/5.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import "ScrollGanttView.h"
#import "StasticGanttView.h"


#define TopViewHeight  60

@interface ScrollGanttView ()
 @property(assign,nonatomic) NSInteger  totalDays;
@property(strong,nonatomic) StasticGanttView * contenView;
 @property (nonatomic,assign) GanttScrollDirection scrollDirection;
@property(strong,nonatomic) NSString * miniXStr;
@property(strong,nonatomic) NSString * maxXStr;

@end
@implementation ScrollGanttView



-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contenView];
      }
    return self;
}
 -(instancetype)initWithFrame:(CGRect)frame yAlexArray:(NSArray *)yalexArray  withXminDateStr:(NSString *)xminStr withXmaxDateStr:(NSString *)xmaxStr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.ganttArray = [yalexArray  mutableCopy];
        self.miniXStr = xminStr;
        self.maxXStr = xmaxStr;
         [self addSubview:self.contenView];
     
    }
    return self;
}

-(StasticGanttView *)contenView{
    if (!_contenView) {
         _contenView = [[StasticGanttView alloc] initWithFrame:CGRectMake(0,0, SCREEN_W, (self.ganttArray.count ) *StageRowHeight +Bounce_Top +Bounce_Bottom)  yAlexArray:self.ganttArray withXminDateStr:self.miniXStr withXmaxDateStr:self.maxXStr];
     }
    self.contentSize = _contenView.bounds.size;
    return _contenView;
}


@end
