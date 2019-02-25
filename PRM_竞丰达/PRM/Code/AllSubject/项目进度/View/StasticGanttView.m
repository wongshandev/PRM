//
//  StasticGanttView.m
//  MicroOAForCompany
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import "StasticGanttView.h"
#import "GanttStageClickedView.h"

@interface StasticGanttView ()

@property(strong,nonatomic) NSString * miniDateStr;
@property(strong,nonatomic) NSString * maxDateStr;
@property(strong,nonatomic) NSString * newsMaxDateStr;
@property(assign,nonatomic) NSInteger  totalDays;

@property(strong,nonatomic) NSString * miniXStr;
@property(strong,nonatomic) NSString * maxXStr;
@property(strong,nonatomic) NSString * title;
@end

@implementation StasticGanttView


-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        //        [self setUI];

    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame yAlexArray:(NSArray *)yalexArray  withXminDateStr:(NSString *)xminStr withXmaxDateStr:(NSString *)xmaxStr titleStr:(NSString *)title{

if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.infoModel  = infoModel;
        self.ganttArray = [yalexArray  mutableCopy];
    self.miniXStr = xminStr;
    self.maxXStr = xmaxStr;
    self.title = title;
    }
    return self;
}



-(void)drawRect:(CGRect)rect{
//    if (self.ganttArray.count == 0) {
//        return;
//    }
    /*******画出表头******************/
        [self drawTopTitleView];

    /*******画出坐标轴******************/
    [self drawTheXYAlex];

    /*******绘制分割线******************/
    [self drawTheSeperateLine];

    /*******绘制提示 颜色与文字*********/
//    [self drawTheMentionWordAndColor];

    /*******绘制进度数据***************/
    [self setUIProgressData];

}
- (void)drawTopTitleView {
    NSMutableParagraphStyle *paraStyTitle = [[NSMutableParagraphStyle alloc] init];
    paraStyTitle.alignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *paraSty = [[NSMutableParagraphStyle alloc] init];
    paraSty.alignment = NSTextAlignmentLeft;
    CGFloat mentionH =(Bounce_Top-Bounce_Title_Top - PaddingY *3)/2;
    CGFloat mentionTop = PaddingY*2 + Bounce_Title_Top + mentionH;
    CGFloat mentionW = 40 ;
    [ self.title  drawInRect: CGRectMake(
                                         Bounce_Left ,
                                         PaddingY + Bounce_Title_Top,
                                         ChartW - Bounce_Left - Bounce_Right,
                                        mentionH )
              withAttributes:@{
                               NSFontAttributeName:SJYBoldFont(15),
                               NSForegroundColorAttributeName:Color_DarkGray,
                               NSParagraphStyleAttributeName:paraStyTitle
                               }];
//计划
    [@"       " drawInRect:CGRectMake( ChartW/2 - mentionW*2, mentionTop, mentionW, mentionH) withAttributes:@{ NSFontAttributeName:SJYBoldFont(12),  NSForegroundColorAttributeName:Color_White, NSBackgroundColorAttributeName:Color_Orange,  NSParagraphStyleAttributeName:paraSty }];
    [@"计划" drawInRect:CGRectMake( ChartW/2 -  mentionW, mentionTop, mentionW, mentionH) withAttributes:@{ NSFontAttributeName:SJYBoldFont(12),  NSForegroundColorAttributeName:Color_Black,  NSParagraphStyleAttributeName:paraSty }];//NSBackgroundColorAttributeName:Color_NavigationLightBlue,
//实际
    [@"       " drawInRect:CGRectMake( ChartW/2 +5,mentionTop, mentionW, mentionH) withAttributes:@{ NSFontAttributeName:SJYBoldFont(12), NSForegroundColorAttributeName:Color_White, NSBackgroundColorAttributeName:Color_NavigationLightBlue, NSParagraphStyleAttributeName:paraSty }];
    [@"实际" drawInRect:CGRectMake( ChartW/2 + mentionW ,mentionTop , mentionW, mentionH) withAttributes:@{ NSFontAttributeName:SJYBoldFont(12), NSForegroundColorAttributeName:Color_Black, NSParagraphStyleAttributeName:paraSty }];//NSBackgroundColorAttributeName:Color_Orange,
}
#pragma mark *****************************绘制坐标轴
- (void)drawTheXYAlex {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); // 坐标轴颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor); // 填充背景色

    CGPoint aPoints[3];
    aPoints[0] =CGPointMake(Bounce_Left, Bounce_Top);
    //    aPoints[1] =CGPointMake(Bounce_Left, ChartH - Bounce_Top);
    aPoints[1] =CGPointMake(Bounce_Left, Bounce_Top +self.ganttArray.count *StageRowHeight);

    //    aPoints[2] =CGPointMake(ChartW - Bounce_Left, ChartH - Bounce_Top);
    aPoints[2] =CGPointMake(ChartW - Bounce_Left, Bounce_Top +self.ganttArray.count *StageRowHeight);
    CGContextAddLines(context, aPoints, 3);
    CGContextStrokePath(context);

//    [@"项目统计图" drawInRect:CGRectMake(Bounce_Left ,  (Bounce_Top - 16)/2 ,ChartW - 2*Bounce_Left, Bounce_Top) withAttributes:@{ NSFontAttributeName:SJYBoldFont(16),  NSForegroundColorAttributeName:Color_RGB_HEX(0x333333, 1) }];//NSBackgroundColorAttributeName:Color_RGB_HEX(0xFFC000, 1)
}
#pragma mark *****************************绘制分割线

- (void)drawTheSeperateLine {
    for (int i = 0; i<self.ganttArray.count; i++) {
        /*******分割线********/
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor); //颜色
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor); // 填充背景色

        CGPoint aPoints[2];
        aPoints[0] =CGPointMake(Bounce_Left + 1, Bounce_Top+ i*StageRowHeight);
        aPoints[1] =CGPointMake(ChartW - Bounce_Left, Bounce_Top+ i*StageRowHeight);
        CGContextAddLines(context, aPoints, 2);
        CGContextStrokePath(context);

    }
}
#pragma mark *****************************绘制提示文字

//- (void)drawTheMentionWordAndColor {
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//
//
//    [@" 实际 " drawInRect:CGRectMake( ChartW - Bounce_Left - 65,  XAlex_MaxY + 40, 50, 30) withAttributes:@{ NSFontAttributeName:SJYBoldFont(12),  NSForegroundColorAttributeName:Color_White, NSBackgroundColorAttributeName:Color_NavigationLightBlue,  NSParagraphStyleAttributeName:paragraphStyle }];
//
//    [@"       " drawInRect:CGRectMake( ChartW - Bounce_Left - 120, XAlex_MaxY +40, 50, 30) withAttributes:@{ NSFontAttributeName:SJYBoldFont(12), NSForegroundColorAttributeName:Color_White, NSBackgroundColorAttributeName:Color_Orange, NSParagraphStyleAttributeName:paragraphStyle }];
//}

#pragma mark *****************************绘制甘特进度

-(void)setUIProgressData{
    NSMutableSet *tempDateSet = [NSMutableSet new];
    //纵坐标 文字添加
    for (int i = 0; i<self.ganttArray.count; i++) {
        StasticGanttModel * model = [self.ganttArray objectAtIndex:i];
        NSMutableParagraphStyle *paraSty = [[NSMutableParagraphStyle alloc] init];
        paraSty.alignment = NSTextAlignmentRight;

        [@( i+1).stringValue drawInRect:CGRectMake(
                                                   0,
                                                   Bounce_Top+ i*StageRowHeight + PaddingY,
                                                   Bounce_Left- 5,
                                                   StageRowHeight)
                         withAttributes:@{
                                          NSFontAttributeName:SJYBoldFont(12),
                                          NSForegroundColorAttributeName:Color_Gray,
                                          NSParagraphStyleAttributeName: paraSty
                                          }];

//        //数据处理
//        if ( model.sjKSRQ.length!= 0) {
//            [tempDateSet addObject: model.sjKSRQ];
//        }
//        if ( model.sjJSRQ.length!= 0) {
//            [tempDateSet addObject: model.sjJSRQ];
//        }
//        if ( model.jhJSRQ.length!= 0) {
//            [tempDateSet addObject: model.jhJSRQ];
//        }
//        if ( model.jhKSRQ.length!= 0) {
//            [tempDateSet addObject: model.jhKSRQ];
//        }
    }
//    if ( self.miniXStr.length!= 0) {
//         [tempDateSet addObject:self.miniXStr];
//    }
//    if ( self.maxXStr.length!= 0) {
//        [tempDateSet addObject:self.maxXStr];
//    }
//
//    NSMutableArray *tempArray = [NSMutableArray new];
//    for (NSString *dateStr in tempDateSet) {
//        [tempArray addObject:dateStr];
//    }
//    [tempArray sortUsingSelector:@selector(compare:)];

//    self.miniDateStr =  tempArray.firstObject;
//    self.maxDateStr = tempArray.lastObject;

    self.miniDateStr =  self.miniXStr;
    self.maxDateStr = self.maxXStr;

    NSInteger totalDays =[self.miniDateStr isEqualToString:self.maxDateStr]? 1:[self numberOfDaysWithFromDate:self.miniDateStr toDate:self.maxDateStr];
    self.totalDays = totalDays;
    NSInteger sepDays = totalDays/X_Num; // totalDays%X_Num == 0 ? totalDays/X_Num : totalDays/X_Num+1;

    NSMutableArray *xTitleArray = [NSMutableArray new];
    for (NSInteger i = 0 ; i<= X_Num ;  i++) {
        if (i< X_Num) {
            NSDate *date  =  [NSDate date:self.miniDateStr WithFormat:@"yyyy-MM-dd"];
            NSDate *titleDate = [NSDate dateWithTimeInterval:sepDays *i*60*60*24 sinceDate:date];
            NSString *dateStr = [NSDate br_getDateString:titleDate format:@"yyyy-MM-dd"];
            [xTitleArray addObject:dateStr];
        }else{
            [xTitleArray addObject:self.maxDateStr];
        }
    }
//    self.newsMaxDateStr = xTitleArray.lastObject;
//    self.totalDays = [self numberOfDaysWithFromDate:self.miniDateStr toDate:self.newsMaxDateStr];
//
    //横坐标

    for (NSInteger i = 0; i<=xTitleArray.count-1; i++) {
        NSInteger count = xTitleArray.count-1;

        NSMutableParagraphStyle *paraSty = [[NSMutableParagraphStyle alloc] init];
        paraSty.alignment = NSTextAlignmentCenter;
        CGRect rect = CGRectZero;
        if (i== 0) {
            paraSty.alignment = NSTextAlignmentLeft;

            rect = CGRectMake(Bounce_Left,   XAlex_MaxY + 5,(ChartW -Bounce_Left - Bounce_Right) /(count+1) , 30);
        }else if (i == count){
            paraSty.alignment = NSTextAlignmentRight;
            rect = CGRectMake(ChartW - Bounce_Right - (ChartW -Bounce_Left - Bounce_Right) /(count+1) ,   XAlex_MaxY + 5,(ChartW -Bounce_Left - Bounce_Right) /(count+1) , 30);

        }else{
            paraSty.alignment = NSTextAlignmentCenter;
            rect =  CGRectMake(
                       Bounce_Left +  i*(ChartW -Bounce_Left - Bounce_Right)/count - (ChartW -Bounce_Left - Bounce_Right) /(count+1)/2,
                       XAlex_MaxY + 5,
                       (ChartW -Bounce_Left - Bounce_Right) /(count+1),
                           30);
        }
        [xTitleArray[i] drawInRect: rect
                    withAttributes:@{
                                     NSFontAttributeName:SJYBoldFont(12),
                                     NSForegroundColorAttributeName:Color_Gray,
                                     NSParagraphStyleAttributeName: paraSty
                                     }];

    }

    for (NSInteger i = 0; i<self.ganttArray.count; i++) {
        StasticGanttModel * model = [self.ganttArray objectAtIndex:i];
        // 绘制 实际线条
        [self drawTheRectForStageGanttType:StageGanttTypeActrul withStartDate:model.sjKSRQ withEndDate:model.sjJSRQ atIndex:i ];

        // 绘制 规划线条
        if (model.jhKSRQ.length != 0 && model.jhJSRQ.length!= 0 ) {
            [self drawTheRectForStageGanttType:StageGanttTypePlane withStartDate:model.jhKSRQ withEndDate:model.jhJSRQ atIndex:i];
        }
        // 绘制交互背景按钮
        [self drawUserInterfaceBackgroundButton:i model:model];

    }
}

#pragma mark *****************************绘制 甘特 条形 图

-(void)drawTheRectForStageGanttType:(StageGanttType) type  withStartDate:(NSString *)startDate  withEndDate:(NSString *)endDate  atIndex:(NSInteger ) i  {
    StasticGanttModel * model = [self.ganttArray objectAtIndex:i];
    // 规划
    NSInteger startDays = [self numberOfDaysWithFromDate:self.miniDateStr toDate:startDate];
    NSInteger endDays = [self numberOfDaysWithFromDate:self.miniDateStr toDate:endDate];

    CGFloat start_X =  endDays == startDays? (startDays -1) * W_EveryDay : startDays * W_EveryDay;
    CGFloat end_X =  endDays * W_EveryDay;

    if (startDays == 0  && startDays == endDays ) {
        start_X = 0;
        end_X = start_X + W_EveryDay/2;
    }

    if (startDays == self.totalDays && startDays == endDays ) {
       start_X = end_X - W_EveryDay/2;
    }

    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.lineWidth = GanttRectHeight;
    backLayer.strokeColor = type == StageGanttTypePlane? Color_Orange.CGColor:Color_NavigationLightBlue.CGColor  ;
    backLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:backLayer];


    UIBezierPath *backPath =[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, 0)];
    NSMutableParagraphStyle *paraSty = [[NSMutableParagraphStyle alloc] init];
    paraSty.alignment = NSTextAlignmentCenter;
    type == StageGanttTypePlane?({
//        [model.JDName drawAtPoint:CGPointMake(Bounce_Left + start_X, Bounce_Top + i*StageRowHeight + PaddingY/2 )
//                   withAttributes:@{
//                                    NSFontAttributeName:SJYBoldFont(12),
//                                    NSForegroundColorAttributeName:Color_Gray,
//                                    NSParagraphStyleAttributeName: paraSty
//                                    }];
//        [backPath moveToPoint:CGPointMake(Bounce_Left + start_X, Bounce_Top + i *StageRowHeight + (PaddingY  + GanttRectHeight) +PaddingY)];
//        [backPath addLineToPoint:CGPointMake(Bounce_Left + end_X, Bounce_Top + i*StageRowHeight + (PaddingY  + GanttRectHeight) +PaddingY) ];

//        NSString * guihuaStr =[@[ model.jhKSRQ, model.jhJSRQ] componentsJoinedByString:@"~"];
//        NSString *jhMentionStr = [model.JDName stringByAppendingFormat:@"(%@)",guihuaStr];
        [model.JDName drawAtPoint:CGPointMake(Bounce_Left + start_X, Bounce_Top + i*StageRowHeight + PaddingY/2 )
                   withAttributes:@{
                                    NSFontAttributeName:SJYBoldFont(12),
                                    NSForegroundColorAttributeName:Color_Gray,
                                    NSParagraphStyleAttributeName: paraSty
                                    }];

        [backPath moveToPoint:CGPointMake(Bounce_Left + start_X, Bounce_Top + i *StageRowHeight + (PaddingY  + GanttRectHeight) +PaddingY)];
        [backPath addLineToPoint:CGPointMake(Bounce_Left + end_X, Bounce_Top + i*StageRowHeight + (PaddingY  + GanttRectHeight) +PaddingY) ];
    }):({
        [backPath moveToPoint:CGPointMake(Bounce_Left + start_X, Bounce_Top + i*StageRowHeight + 3*PaddingY + GanttRectHeight*2)];
        [backPath addLineToPoint:CGPointMake(Bounce_Left + end_X, Bounce_Top + i*StageRowHeight + (PaddingY + GanttRectHeight )*2 + PaddingY ) ];
        if (model.JDNum.length !=0 && ![model.JDNum isEqualToString:@"0"]) {
//            NSString * shijiStr =[@[ model.sjKSRQ, model.sjJSRQ] componentsJoinedByString:@"~"];
//            NSString *sjMentionStr = [[model.JDNum stringByAppendingString:@"%"] stringByAppendingFormat:@"(%@)",shijiStr];
            [[model.JDNum stringByAppendingString:@"%"] drawAtPoint:CGPointMake(Bounce_Left + start_X, Bounce_Top + i*StageRowHeight + (PaddingY/2 + GanttRectHeight )*3 )
                                                     withAttributes:@{
                                                                      NSFontAttributeName:SJYBoldFont(12),
                                                                      NSForegroundColorAttributeName:Color_Gray,
                                                                      NSParagraphStyleAttributeName: paraSty
                                                                      }];
        }
    });

    backLayer.path = backPath.CGPath;
    CABasicAnimation*backAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    backAnimation.duration=1.5;
    backAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    backAnimation.fromValue=[NSNumber numberWithFloat:0];
    backAnimation.toValue=[NSNumber numberWithFloat:1.0];
    [backLayer addAnimation:backAnimation forKey:@"strokeEndAnimation"];

}




//- (void)drawRectangleWithColor:(UIColor *)color WithRect:(CGRect) rect {
//    /*
//     *创建一个矩形区域 -----   rect
//     */
//    /*
//     *将rect添加到图形上下文中
//     */
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddRect(context, rect);
//
//    /*
//     *设定颜色,开始绘制
//     */
//    [color setFill];
//    [color setStroke];
//    CGContextSetLineWidth(context, 3);
//    CGContextDrawPath(context, kCGPathFillStroke);
//}



- (void)drawUserInterfaceBackgroundButton:(NSInteger)tagIndex model:(StasticGanttModel *)model {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(Bounce_Left +1, Bounce_Top +1 + tagIndex * StageRowHeight , ChartW - Bounce_Left-1, StageRowHeight);
    // runtime 为 button 直接绑定参数 model
    objc_setAssociatedObject(button,@"ganttModel", model , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //    button.tag = 1000 + tagIndex; // 通过tag 去数组中获取 model

    [button addTarget:self action:@selector(showStageInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}



-(void)showStageInfo:(UIButton *)sender  {
    NSLog(@"%@",sender.currentTitle);
    // 参数传递方法1
   StasticGanttModel *model =  objc_getAssociatedObject(sender,@"ganttModel");
//    // 参数传递方法2
//    NSInteger index = sender.tag - 1000;
//    StasticGanttModel *model = [self.ganttArray objectAtIndex:index];
    [self handleShowContentViewWithModel:model];

 }

- (void)handleShowContentViewWithModel:(StasticGanttModel *)model {
 
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];

    GanttStageClickedView *contentView = [[GanttStageClickedView alloc] init];
    contentView.frame = CGRectMake(0, 0, SCREEN_W - 20 *2, 210);
     contentView.ganttModel = model;
    contentView.frame = CGRectMake(0, 0, SCREEN_W - 20 *2, contentView.viewHeight);
    
    [contentView rounded:5];
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:^(BOOL finished) {
    }];
}

 //计算天数的方法
- (NSInteger)numberOfDaysWithFromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr{

    NSDate *fromDate = [NSDate date:fromDateStr WithFormat:@"yyyy-MM-dd"];
//    NSDate *fromDayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:fromDate];

    if ([fromDateStr isEqualToString:toDateStr] == NSOrderedSame) {
        fromDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:fromDate];
    }

    NSDate *toDate = [NSDate date:toDateStr WithFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

- (NSMutableArray *)ganttArray{
    if (!_ganttArray) {
        _ganttArray = [NSMutableArray new];
    }
    return  _ganttArray;
}

@end
