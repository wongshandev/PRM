//
//  SJYSGGLDetailController.m
//  PRM
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYSGGLDetailController.h"
#import "EngineeringModel.h"
#import "JDHBListController.h"
#import "WLJHListController.h"

@interface SJYSGGLDetailController ()<ZJScrollPageViewDelegate>
@property(nonatomic,strong)ZJScrollPageView *pageScrollView;
@property(nonatomic,strong)NSArray *titles;

@end

@implementation SJYSGGLDetailController

-(void)setUpNavigationBar{
     //    self.navBar.backButton.hidden = NO;
    self.navBar.titleLabel.text = self.engineerModel.Name;
    Weak_Self;
    [self.navBar.backButton clickWithBlock:^{
        __block BOOL isNeedSave = NO;
        __block JDHBListController *jdhbVC = nil;
        [weakSelf.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[JDHBListController class]]) {
                 jdhbVC = (JDHBListController *)obj;
                if (jdhbVC.updateArray.count !=0) {
                    isNeedSave = YES;
                }
                *stop = YES;
            }
        }];
        if (isNeedSave) {
            [jdhbVC alertWithSaveMention:@"您修改了进度 , 需要保存吗?" withAction:@selector(update_JDHBDataForParentVC)];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
 }

-(void)buildSubviews{
     ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.titleFont= Font_ListTitle;
    style.showLine = YES;
    style.scrollTitle= NO;
    style.autoAdjustTitlesWidth= YES;
    style.adjustCoverOrLineWidth= YES;
    //style.adjustCoverOrLineWidth= YES;
    style.segmentHeight=SJYNUM(44);
    style.scrollLineHeight=SJYNUM(3);
    style.scrollLineColor=Color_NavigationLightBlue;
    style.normalTitleColor=Color_TEXT_HIGH;
    style.selectedTitleColor=Color_NavigationLightBlue;
    style.contentViewBounces = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;

      // 初始化
    self.pageScrollView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.navBar.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navBar.height) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:self.pageScrollView];
}

#pragma mark ======================= 数据绑定

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (index == 0) {
        JDHBListController *jdhbVC = [[JDHBListController alloc] init];
        jdhbVC.engineerModel = self.engineerModel;
        childVc = jdhbVC;
    }else{
        WLJHListController *wljhVC = [[WLJHListController alloc] init];
        wljhVC.engineerModel = self.engineerModel; 
        childVc = wljhVC;
    }
     return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{

}
-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"进度汇报",@"物料计划"];
    }
    return _titles;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
#ifdef DEBUG
    printf("[⚠️] 已经释放 %s.\n", NSStringFromClass(self.class).UTF8String);
#endif
}

@end
