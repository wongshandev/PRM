//
//  GanttStageClickedView.m
//  MicroOAForCompany
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 JoinupMac01. All rights reserved.
//

#import "GanttStageClickedView.h"


#define RECT_Width    rect.size.width
#define RECT_Hight    rect.size.height

#define Hight_TopBlue    45.0
#define Hight_GuiHua    60.0

#define Height_World     20

#define LeftPadding       20.0
#define WordPadding     10.0

@interface GanttStageClickedView ()<QMUITextViewDelegate>


@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UILabel *topTitleLab;
@property(nonatomic,strong)UILabel *guiHuaLeftLab;
@property(nonatomic,strong)UILabel *guiHuaLab;
@property(nonatomic,strong)UILabel *guiHuaTimeLab;

@property(nonatomic,strong)UILabel *sepLab;


@property(nonatomic,strong)UILabel *shiJiLeftLab;
@property(nonatomic,strong)UILabel *shiJiLab;
@property(nonatomic,strong)UILabel *shiJiTimeLab;

@property(nonatomic,strong)UILabel *progressLab;

@property(nonatomic,strong)QMUITextView *bzTV;


@property(nonatomic,strong)UILabel *sepLab2;


@end
@implementation GanttStageClickedView

-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
        [self layoutIfNeeded];
    }
    return self;
}

-(void) initUI {
    self.backgroundColor = Color_White;
    [self addSubview:self.topView];
    [self.topView addSubview:self.topTitleLab];
    
    self.guiHuaLeftLab  = [self createLabel];
    self.guiHuaLeftLab.backgroundColor = Color_Orange ;
    [self addSubview:self.guiHuaLeftLab];
    
    self.guiHuaLab = [self createLabel];
    self.guiHuaLab.text = @"计划";
    [self addSubview:self.guiHuaLab];
    
    self.guiHuaTimeLab = [self createLabel];
    [self addSubview:self.guiHuaTimeLab];
    
    self.sepLab = [self createLabel];
    self.sepLab.backgroundColor = Color_SrprateLine;
    [self addSubview:self.sepLab];
    
    self.shiJiLeftLab = [self createLabel];
    self.shiJiLeftLab.backgroundColor = Color_NavigationLightBlue;
    [self addSubview:self.shiJiLeftLab];
    
    self.shiJiLab = [self createLabel];
    self. shiJiLab.text = @"实际";
    [self addSubview:self.shiJiLab];
    
    self.shiJiTimeLab = [self createLabel];
    [self addSubview:self.shiJiTimeLab];
    
    self.progressLab = [self createLabel];
    self.progressLab.textColor = Color_NavigationLightBlue;
    [self addSubview:self.progressLab];
    
    self.bzTV = [[QMUITextView alloc] init];
    self.bzTV.font = [UIFont systemFontOfSize:15];
    self.bzTV.textColor = Color_TEXT_NOMARL;
    self.bzTV.maximumHeight = 300;
    self.bzTV.editable = NO;
    self.bzTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.bzTV];
    
    self.sepLab2 = [self createLabel];
    self.sepLab2.backgroundColor = Color_SrprateLine;
    [self addSubview:self.sepLab2];
    
}

-(void)layoutSubviews{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(Hight_TopBlue);
    }];
    [self.topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.top.mas_equalTo(self.topView.mas_top).mas_offset(5);
        make.left.mas_equalTo(self.topView.mas_left).mas_offset(LeftPadding);
        make.right.mas_equalTo(self.topView.mas_right).mas_offset(-LeftPadding);
    }];
    [self.guiHuaLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(WordPadding);
        make.left.mas_equalTo(self.mas_left).mas_offset(LeftPadding);
        make.width.height.mas_equalTo(Height_World);
    }];
    [self.guiHuaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.guiHuaLeftLab.mas_top);
        make.left.mas_equalTo(self.guiHuaLeftLab.mas_right).mas_offset(WordPadding);
        make.right. mas_equalTo(self.mas_right).mas_offset(-LeftPadding);
        make.bottom. mas_equalTo(self.guiHuaLeftLab.mas_bottom);
    }];
    [self.guiHuaTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.guiHuaLeftLab.mas_bottom).mas_offset(WordPadding);
        make.left.mas_equalTo(self.guiHuaLeftLab.mas_left);
        make.right.mas_equalTo(self.mas_right).mas_offset(-LeftPadding);
        make.height.mas_equalTo(Height_World);
    }];
    [self.sepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.guiHuaTimeLab.mas_bottom);
        make.left.mas_equalTo(self.guiHuaTimeLab.mas_left);
        make.right.mas_equalTo(self.guiHuaTimeLab.mas_right);
        make.height.mas_equalTo(1);
    }];
    [self.shiJiLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sepLab.mas_bottom).mas_offset(WordPadding);
        make.left.mas_equalTo(self.mas_left).mas_offset(LeftPadding);
        make.width.height.mas_equalTo(Height_World);
    }];
    [self.shiJiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shiJiLeftLab.mas_top);
        make.left.mas_equalTo(self.shiJiLeftLab.mas_right).mas_offset(WordPadding);
        make.right. mas_equalTo(self.mas_right).mas_offset(-LeftPadding);
        make.bottom. mas_equalTo(self.shiJiLeftLab.mas_bottom);
    }];
    [self.shiJiTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shiJiLeftLab.mas_bottom).mas_offset(WordPadding);
        make.left.mas_equalTo(self.shiJiLeftLab.mas_left);
        make.right.mas_equalTo(self.mas_right).mas_offset(-LeftPadding);
        make.height.mas_equalTo(Height_World);
    }];
    [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shiJiTimeLab.mas_bottom).mas_offset(WordPadding);
        make.left.mas_equalTo(self.shiJiTimeLab.mas_left);
        make.right.mas_equalTo(self.mas_right).mas_offset(-LeftPadding);
        make.height.mas_equalTo(Height_World);
    }];
 
    [self.bzTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressLab.mas_bottom).mas_offset(WordPadding);
        make.left.mas_equalTo(self.progressLab.mas_left);
        make.right.mas_equalTo(self.mas_right).mas_offset(-LeftPadding);
        make.height.mas_greaterThanOrEqualTo(1);
    }];

    [self.sepLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bzTV.mas_bottom);
        make.left.mas_equalTo(self.bzTV.mas_left);
        make.right.mas_equalTo(self.bzTV.mas_right);
        //        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        make.height.mas_equalTo(1);
    }];
}

-(void)setGanttModel:(StasticGanttModel *)ganttModel{
    _ganttModel = ganttModel;
    self.topTitleLab.text = ganttModel.JDName;

    if  (ganttModel.jhKSRQ.length!= 0 && ganttModel.jhJSRQ.length!= 0){
        NSString * shijiStr =[@[ ganttModel.jhKSRQ, ganttModel.jhJSRQ] componentsJoinedByString:@"~"];
        self.guiHuaTimeLab.text = shijiStr;
    }else{
        self.guiHuaTimeLab.text = @"";
    }
    if ( ganttModel.sjKSRQ.length!= 0 &&  ganttModel.sjJSRQ.length!= 0){
        NSString * guihuaStr =[@[ ganttModel.sjKSRQ, ganttModel.sjJSRQ] componentsJoinedByString:@"~"];
        self.shiJiTimeLab.text = guihuaStr;
    }else{
        self.shiJiTimeLab.text = @"";
    }
    NSString * shijiNumStr =[@[ @"当前进度:  ",ganttModel.JDNum,@"%"] componentsJoinedByString:@""];
    self.progressLab.text =ganttModel.JDNum.length == 0? @"": shijiNumStr;
     
    
    self.bzTV.text = ganttModel.JZNR.length == 0 ?@"": ganttModel.JZNR;
    [self.bzTV  sizeToFit];
    CGFloat tempHeight = self.bzTV.contentSize.height; // + UIEdgeInsetsGetVerticalValue(self.bzTV.contentInset);
    self.bzTV.scrollEnabled  =YES;
    self.bzTV.showsVerticalScrollIndicator =  self.bzTV.scrollEnabled;
    [self.bzTV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tempHeight  > self.bzTV.maximumHeight?self.bzTV.maximumHeight:tempHeight);
    }];
     [self layoutIfNeeded];
    
    self.viewHeight = CGRectGetMaxY(self.sepLab2.frame) + 5 > SCREEN_H ? SCREEN_H - 20 *2 :  CGRectGetMaxY(self.sepLab2.frame) + 5;
//    kMyLog(@"%f",CGRectGetMaxY(self.sepLab2.frame) + 5);
//    self.bzTV.scrollEnabled  = CGRectGetMaxY(self.sepLab2.frame) + 5 > kDeviceHeight;
    
}



-(UILabel *)createLabel{
    UILabel *lable = [[ UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor =Color_TEXT_HIGH;
    return lable;
}

-(UILabel *)topTitleLab{
    if (!_topTitleLab) {
        _topTitleLab = [[ UILabel alloc] init];
        _topTitleLab.font = [UIFont systemFontOfSize:15];
        _topTitleLab.textAlignment = NSTextAlignmentLeft;
        _topTitleLab.textColor = Color_White;
    }
    return _topTitleLab;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = Color_NavigationLightBlue;
    }
    return _topView;
}

- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmin(self.bzTV.maximumHeight, height);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 //- (void)drawRect:(CGRect)rect {
 //     NSMutableParagraphStyle *paraSty = [[NSMutableParagraphStyle alloc] init];
 //    paraSty.alignment = NSTextAlignmentLeft;
 //#pragma mark  *****************************************************绘制蓝色区域
 //    [self drawRectangleWithRect:CGRectMake(0, 0, RECT_Width, Hight_TopBlue) WithColor:Color_NavigationLightBlue];
 //
 //#pragma mark  *****************************************************蓝色区域绘制文字
 //    [self.ganttModel.JDName drawInRect:CGRectMake(
 //                                                  LeftPadding,
 //                                                  WordPadding ,
 //                                                  RECT_Width - LeftPadding*2,
 //                                                  Hight_TopBlue -WordPadding*2)
 //                        withAttributes: @{
 //                                          NSFontAttributeName:H15,
 //                                          NSForegroundColorAttributeName:Color_White,
 //                                          NSParagraphStyleAttributeName: paraSty}];
 //
 //
 //#pragma mark  *****************************************************绘制规划文字
 //    [self drawRectangleWithRect:CGRectMake(0, Hight_TopBlue, RECT_Width, Hight_GuiHua) WithColor:Color_White];
 //    [self drawRectangleWithRect:CGRectMake(LeftPadding, Hight_TopBlue + WordPadding, Height_World , Height_World) WithColor:RGB_HEX(0xC6D9F1, 1)];
 //
 //    paraSty.alignment = NSTextAlignmentLeft;
 //    [@"规划" drawInRect:CGRectMake(
 //                                 LeftPadding+Height_World + WordPadding ,
 //                                 Hight_TopBlue + WordPadding,
 //                                 RECT_Width - 2*LeftPadding - WordPadding,
 //                                 Height_World)
 //       withAttributes:@{
 //                        NSFontAttributeName:H15,
 //                        NSForegroundColorAttributeName:Color_DarkGray,
 //                        NSParagraphStyleAttributeName: paraSty}];
 //
 //#pragma mark  *****************************************************绘制规划开始/结束时间
 //    if  (self.ganttModel.KSRQ.length!= 0 && self.ganttModel.JSRQ.length!= 0){
 //        NSString * guihuaStr =[@[ self.ganttModel.KSRQ,self.ganttModel.JSRQ] componentsJoinedByString:@"-"];
 //        [guihuaStr  drawInRect:CGRectMake(
 //                                          LeftPadding,
 //                                          Hight_TopBlue + WordPadding *2 + Height_World,
 //                                          RECT_Width - 2*LeftPadding,
 //                                          Height_World)
 //                withAttributes:@{ NSFontAttributeName:H15,
 //                                  NSForegroundColorAttributeName:Color_DarkGray,
 //                                  NSParagraphStyleAttributeName: paraSty}];
 //
 //    }
 //
 //
 //#pragma mark  *****************************************************绘制割线
 //    [self drawSeparateLineFromPoint:CGPointMake(LeftPadding, Hight_TopBlue +Hight_GuiHua -1) ToPoint:CGPointMake(RECT_Width - LeftPadding, Hight_TopBlue +Hight_GuiHua -1)];
 //
 //
 //#pragma mark  *****************************************************绘制实际文字
 //    [self drawRectangleWithRect:CGRectMake(0, (Hight_TopBlue +Hight_GuiHua ), RECT_Width, RECT_Hight - (Hight_TopBlue +Hight_GuiHua ) ) WithColor:Color_White];
 //    [self drawRectangleWithRect:CGRectMake(LeftPadding, (Hight_TopBlue +Hight_GuiHua ) + WordPadding, Height_World, Height_World) WithColor:RGB_HEX(0xFFC000, 1)];
 //
 //    paraSty.alignment = NSTextAlignmentLeft;
 //    [@"实际" drawInRect:CGRectMake(
 //                                 LeftPadding +Height_World + WordPadding ,
 //                                 (Hight_TopBlue +Hight_GuiHua ) + WordPadding,
 //                                 RECT_Width - 2*LeftPadding - WordPadding  ,
 //                                 Height_World)
 //       withAttributes:@{
 //                        NSFontAttributeName:H15,
 //                        NSForegroundColorAttributeName:Color_DarkGray,
 //                        NSParagraphStyleAttributeName: paraSty}];
 //
 //#pragma mark  *****************************************************绘制实际开始计数时间
 //    if  (self.ganttModel.QSRQ.length!= 0 && self.ganttModel.DQRQ.length!= 0){
 //        NSString * shijiStr =[@[ self.ganttModel.QSRQ,self.ganttModel.DQRQ] componentsJoinedByString:@"~"];
 //        [shijiStr  drawInRect:CGRectMake(
 //                                          LeftPadding,
 //                                          (Hight_TopBlue +Hight_GuiHua ) + WordPadding *2 + Height_World,
 //                                          RECT_Width - 2*LeftPadding,
 //                                          Height_World)
 //                withAttributes:@{ NSFontAttributeName:H15,
 //                                  NSForegroundColorAttributeName:Color_DarkGray,
 //                                  NSParagraphStyleAttributeName: paraSty}];
 //    }
 //
 //    if  (self.ganttModel.JDNum.length != 0){
 //        NSString * shijiNumStr =[@[ @"当前进度:  ",self.ganttModel.JDNum,@"%"] componentsJoinedByString:@""];
 //        [shijiNumStr  drawInRect:CGRectMake(
 //                                            LeftPadding,
 //                                            (Hight_TopBlue +Hight_GuiHua ) + WordPadding *3 + Height_World *2 ,
 //                                            RECT_Width - 2*LeftPadding,
 //                                            Height_World)
 //                withAttributes:@{ NSFontAttributeName:H15,
 //                                  NSForegroundColorAttributeName:Color_DarkYellor,
 //                                  NSParagraphStyleAttributeName: paraSty}];
 //
 //    }
 //
 //#pragma mark  *****************************************************绘制割线
 //    [self drawSeparateLineFromPoint:CGPointMake(LeftPadding,  RECT_Hight - 5) ToPoint:CGPointMake(RECT_Width -  LeftPadding, RECT_Hight - 5)];
 //
 //
 //}
 
 #pragma mark  ***************************************************** 绘制矩形区域
 - (void)drawRectangleWithRect:(CGRect) rect WithColor:(UIColor *)color {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextAddRect(context, rect);
 [color setFill];
 [color setStroke];
 //    CGContextSetLineWidth(context, 3);
 CGContextDrawPath(context, kCGPathFillStroke);
 }
 
 #pragma mark  *****************************************************绘制分割线
 -(void)drawSeparateLineFromPoint:(CGPoint )fromPoint ToPoint:(CGPoint) toPoint {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetLineWidth(context, 1.0);
 CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor); //颜色
 CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor); // 填充背景色
 
 CGPoint aPoints[2];
 aPoints[0] = fromPoint;
 aPoints[1] = toPoint;
 CGContextAddLines(context, aPoints, 2);
 CGContextStrokePath(context);
 }
 */
@end
