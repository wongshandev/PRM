//
//  UITableView+NoData.m
//  CmosLiveDemo
//
//  Created by 张海阔 on 2018/4/19.
//  Copyright © 2018年 zhanghaikuo. All rights reserved.
//

#import "UITableView+NoData.h"
#import <objc/runtime.h>
#import "DXNoDataView.h"

NSString * const cm_NoDataViewObserveKeyPath = @"frame";

@interface UITableView ()

@property (nonatomic, assign) BOOL isInitFinish;

@end

@implementation UITableView (NoData)

/**
 加载时，交换方法
 */
+ (void)load {
    Method reloadData = class_getInstanceMethod(self, @selector(reloadData));
    Method cm_reloadData = class_getInstanceMethod(self, @selector(cm_reloadData));
    method_exchangeImplementations(reloadData, cm_reloadData);
    
    Method dealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method cm_dealloc = class_getInstanceMethod(self, @selector(cm_dealloc));
    method_exchangeImplementations(dealloc, cm_dealloc);
}

- (void)cm_dealloc {
    [self removeObserverIfNeeded];
    [self cm_dealloc];
}

/**
 在 reloadData 时检查数据
 */
- (void)cm_reloadData {
    [self cm_reloadData];
    
    if (!self.showNoData) {
        return;
    }
    
    //忽略第一次加载
    if (!self.isInitFinish) {
        [self cm_showData:YES];
        self.isInitFinish = YES;
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger numberOfSections = [self numberOfSections];
        BOOL havingData = NO;
        for (NSInteger i = 0; i < numberOfSections; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                havingData = YES;
                break;
            }
        }
        
        [self cm_showData:havingData];
    });
}

/**
 根据数据情况展示视图

 @param havingData 是否有数据
 */
- (void)cm_showData:(BOOL)havingData {
    //有数据时不现实占位图
    if (havingData) {
        [self removeObserverIfNeeded];
        self.backgroundView = nil;
        return;
    }
    //避免重复创建
    if (self.backgroundView) {
        return;
    }
    //自定义了占位图
    if (self.customView) {
        self.backgroundView = self.customView;
        return;
    }
    //使用默认占位图并自定义相关属性
    UIImage  *image = self.customImg;
    NSString *msg   = @"暂无数据";
    UIColor  *textColor = Color_RGB_HEX(0xC6C6CC, 1);
    UIColor  *bgColor = [UIColor whiteColor];
    CGFloat  offsetY = self.offsetY;
    BOOL     isShowBtn = self.isShowBtn;
    // 获取文字
    if (self.customMsg) {
        msg = self.customMsg;
    }
    // 获取文字颜色
    if (self.textColor) {
        textColor = self.textColor;
    }
    // 背景颜色
    if (self.bgColor) {
        bgColor = self.bgColor;
    }
    self.backgroundView = [self cm_defaultNoDataViewWithImage:image
                                                      message:msg
                                                    textColor:textColor
                                                      bgColor:bgColor
                                                    isShowBtn:isShowBtn
                                                      offsetY:offsetY];
}

/**
 构造默认占位图

 @param image 图片
 @param message 文字
 @param textColor 文字颜色
 @param bgColor 背景颜色
 @param offsetY Y方向偏移量
 @param isShowBtn 是否显示按钮
 @return 返回默认占位图实例
 */
- (UIView *)cm_defaultNoDataViewWithImage:(UIImage *)image
                                  message:(NSString *)message
                                textColor:(UIColor *)textColor
                                  bgColor:(UIColor *)bgColor
                                isShowBtn:(BOOL)isShowBtn
                                  offsetY:(CGFloat)offsetY
{
    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.bounds.size.width;
    CGFloat cX = sW / 2;
    CGFloat cY = 103 + 100 + offsetY;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //  图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);
    imgView.image        = image;
    
    //  文字
    UILabel *label       = [[UILabel alloc] init];
    label.font           =SJYFont(14);
    label.textColor      = textColor;
    label.text           = message;
    label.textAlignment  = NSTextAlignmentCenter;
    label.frame          = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 30, sW, label.font.lineHeight);

    //  视图
    DXNoDataView *view   = [[DXNoDataView alloc] init];
    view.backgroundColor = bgColor;
    [view addSubview:imgView];
    [view addSubview:label];
    
    //  刷新按钮
    if (isShowBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(cX - 60, CGRectGetMaxY(label.frame) + 67, 120, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:@"刷新重试" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageWithSize:CGSizeMake(120, 40) color:Color_MAIN cornRadius:20] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }

    //  实现跟随 TableView 滚动
    [view addObserver:self forKeyPath:cm_NoDataViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
    return view;
}

- (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)color cornRadius:(CGFloat)cornerRadius
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    view.backgroundColor = color;
    view.layer.cornerRadius = cornerRadius;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数是屏幕密度
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)btnAction:(UIButton *)sender {
    NSLog(@"刷新重试");
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

#pragma mark -- KVO 监听

/**
 监听回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:cm_NoDataViewObserveKeyPath]) {
        //实现 backgroundView 跟随 TableView 的滚动而滚动
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        if (frame.origin.y != 0) {
            frame.origin.y  = 0;
            self.backgroundView.frame = frame;
        }
    }
}

/**
 移除 KVO 监听
 */
- (void)removeObserverIfNeeded {
    if ([self.backgroundView isKindOfClass:[DXNoDataView class]]) {
        [self.backgroundView removeObserver:self forKeyPath:cm_NoDataViewObserveKeyPath];
    }
}

#pragma mark -- 属性

- (void)setShowNoData:(BOOL)showNoData {
    objc_setAssociatedObject(self, @selector(showNoData), @(showNoData), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)showNoData {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, @selector(isInitFinish), @(finish), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isInitFinish {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCustomView:(UIView *)customView {
    objc_setAssociatedObject(self, @selector(customView), customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)customView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCustomImg:(UIImage *)customImg {
    objc_setAssociatedObject(self, @selector(customImg), customImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)customImg {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCustomMsg:(NSString *)customMsg {
    objc_setAssociatedObject(self, @selector(customMsg), customMsg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)customMsg {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTextColor:(UIColor *)textColor {
    objc_setAssociatedObject(self, @selector(textColor), textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)textColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBgColor:(UIColor *)bgColor {
    objc_setAssociatedObject(self, @selector(bgColor), bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bgColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOffsetY:(CGFloat)offsetY {
    objc_setAssociatedObject(self, @selector(offsetY), @(offsetY), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)offsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setIsShowBtn:(BOOL)isShowBtn {
    objc_setAssociatedObject(self, @selector(isShowBtn), @(isShowBtn), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isShowBtn {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setRefreshBlock:(DXTableViewRefreshBtnBlock)refreshBlock{
    objc_setAssociatedObject(self, @selector(refreshBlock), refreshBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(DXTableViewRefreshBtnBlock )refreshBlock{
    return  objc_getAssociatedObject(self, _cmd);
}
@end
