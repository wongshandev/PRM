//
//  StasticGanttView.h
//  MicroOAForCompany
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import "StasticGanttModel.h"
 
#define   Bounce_Left        30.0
#define   Bounce_Right      30.0
#define   Bounce_Top         40.0
#define   Bounce_Bottom   60.0

#define   PaddingY   5

#define GanttRectHeight  15.0

#define StageRowHeight  (GanttRectHeight * 4 + PaddingY /2 * 5 )

#define SeparateHeight 1.0

#define   ChartW   self.frame.size.width      // view 宽度

#define   ChartH    self.frame.size.height    // View 高度

#define   X_Num    2  // X 轴间隔两个 (三个X label)

#define W_Chart  (ChartW - Bounce_Left -  Bounce_Right)     //绘图区宽度

#define   W_EveryDay  W_Chart / (self.totalDays)                   // 每天的宽度

#define DefaultWidth   1.5

#define XAlex_MaxY  Bounce_Top +self.ganttArray.count *StageRowHeight

typedef NS_ENUM(NSUInteger, StageGanttType) {
    StageGanttTypePlane = 0,
    StageGanttTypeActrul
};

typedef NS_OPTIONS(NSUInteger, GanttScrollDirection) {
    GanttScrollDirectionNone = 0,
    GanttScrollDirectionHorizon = 1 << 0,
    GanttScrollDirectionVertical = 1 << 1
};

@interface StasticGanttView : UIView

@property(nonatomic,strong)NSMutableArray *ganttArray;
 
//-(instancetype)initWithFrame:(CGRect)frame prmInfomodel:(PRMInfoModel *)infoModel yAlexArray:(NSArray *)yalexArray;
-(instancetype)initWithFrame:(CGRect)frame yAlexArray:(NSArray *)yalexArray  withXminDateStr:(NSString *)xminStr withXmaxDateStr:(NSString *)xmaxStr;
 
@end
