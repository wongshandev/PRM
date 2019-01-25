//
//  XMJDGanttController.m
//  PRM
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMJDGanttController.h"
#import "StasticGanttModel.h"
#import "ScrollGanttView.h"

@interface XMJDGanttController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(strong,nonatomic)ScrollGanttView *scrollGanntView;
@property(strong,nonatomic) NSString * miniXStr;
@property(strong,nonatomic) NSString * maxXStr;
@end

@implementation XMJDGanttController

-(void)setUpNavigationBar{
    self.navBar.hidden = NO;
    self.navBar.titleLabel.text = self.title;
    self.dataArray = [NSMutableArray new];
}

-(void)bindViewModel{
    [SJYRequestTool requestXMJDGanttDataWithProjectBranchID:self.listModel.Id success:^(id responder) {
        
        NSArray *firstCategoriesArr = [responder objectForKey:@"firstCategories"];
        NSArray *secondCategoriesArr = [responder objectForKey:@"secondCategories"];
        
        
        NSString *kssj =     [firstCategoriesArr.firstObject objectForKey:@"BeginDate"];
        NSString *jjsj =     [secondCategoriesArr.lastObject objectForKey:@"EndDate"];
        
        self.miniXStr = [self dateStringFormJSDateString:kssj];
        self.maxXStr = [self dateStringFormJSDateString:jjsj];
        
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self.dataArray removeAllObjects];
        
        for (NSDictionary *dic in rowsArr) {
            
            StageModel *model = [StageModel  modelWithDictionary:dic];
            StasticGanttModel *ganntModel = [[StasticGanttModel alloc] init];
            ganntModel.JD_Id = model.Id;
            ganntModel.JDName = model.Name;
            ganntModel.JDNum = model.CompletionRate;
            
            //实际
            ganntModel.sjKSRQ =[self dateStringFormJSDateString:model.ActualBeginDate];
            ganntModel.sjJSRQ =[self dateStringFormJSDateString: model.LastModifyDate];
            //规划
            ganntModel.jhJSRQ = [self dateStringFormJSDateString: model.BeginDate];
            ganntModel.jhKSRQ = [self dateStringFormJSDateString: model.EndDate];
            
            [self.dataArray addObject:ganntModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.maxXStr.length==0 || self.miniXStr.length == 0) {
                [QMUITips showError:@"数据出错,统计图初始化失败" inView:self.view hideAfterDelay:1.2];
                return ;
            }
            [self initScrollGanntView];
        });
    } failure:^(int status, NSString *info) {
        [QMUITips showError:@"数据出错,统计图初始化失败" inView:self.view hideAfterDelay:1.2];
    }];
}


- (void)initScrollGanntView{
    if (self.dataArray.count!= 0) {
        self.scrollGanntView = [[ScrollGanttView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_W, SCREEN_H - NAVHEIGHT )  yAlexArray:self.dataArray withXminDateStr:self.miniXStr withXmaxDateStr:self.maxXStr];
        if (@available(iOS 11.0, *)) {
            self.scrollGanntView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.scrollGanntView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:self.scrollGanntView];
        [self.scrollGanntView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navBar.mas_bottom);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }
}

-(NSString *)dateStringFormJSDateString:(NSString *)jsDateStr{
    jsDateStr  = [[jsDateStr  stringByReplacingOccurrencesOfString:@"/Date(" withString:@""]   stringByReplacingOccurrencesOfString:@")/" withString:@""];
    
    double time = [jsDateStr doubleValue] /1000;
    if (time<0) {
        return @"";
    }
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //将时间转换为字符串
    NSString *timeS = [formatter stringFromDate:myDate];
    return timeS;
}


@end
