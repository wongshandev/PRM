//
//  DXSuperViewController.m
//  DaXueZhang
//
//  Created by qiaoxuekui on 2018/7/11.
//  Copyright © 2018年 qiaoxuekui. All rights reserved.
//

#import "DXSuperViewController.h"

@interface DXSuperViewController ()

@end

@implementation DXSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White;
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    
    if (self.navigationController.childViewControllers.count != 1) {
        self.navBar.backButton.hidden=NO;
    }
    else{
        self.navBar.backButton.hidden=YES;
    }
    __weak typeof (self) weakSelf = self;
    [self.navBar.backButton clickWithBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self setUpNavigationBar];
    [self buildSubviews];
    [self bindViewModel];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(statusFrameChanged:)
//                                                 name:UIApplicationWillChangeStatusBarFrameNotification
//                                               object:nil]; 

}
//-(void)statusFrameChanged:(NSNotification*) note {
//    CGRect statusBarFrame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
//    CGFloat statusHeight = statusBarFrame.size.height;
//    UIScreen *screen = [UIScreen mainScreen];
//    CGRect viewRect = screen.bounds;
//    viewRect.size.height -= statusHeight;
//    viewRect.origin.y = statusHeight;
//    self.view.frame = viewRect;
//    [self.view setNeedsLayout];
//
//    self.navBar.frame = CGRectMake(0, 0, SCREEN_W, kTopStatusAndNavBarHeight);
//    [self.navBar layoutIfNeeded];
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navBar];
}

- (void)buildSubviews {
    
}

- (void)setUpNavigationBar {

}

- (void)bindViewModel {
    
}


- (void)goToLoginViewController {
    SJYLoginViewController *loginVC = [[SJYLoginViewController alloc] init];
    UINavigationController *navigVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //    loginVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:navigVC animated:YES completion:^{
        
    }];
}


-(DXNavBarView *)navBar{
    if (_navBar==nil) {
        _navBar=[[DXNavBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, NAVNOMARLHEIGHT)];
    }
    return _navBar;
}

#pragma mark - table.set 可修改

-(void)viewDidLayoutSubviews {
    //    __block UITableView* table;
    //    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        if ([obj isKindOfClass:[UITableView class]]) {
    //            table=obj;
    //        }
    //    }];
    //    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
    //        [table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    //    }
    //
    //    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
    //        [table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    //    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    //    {
    //        [cell setSeparatorInset:UIEdgeInsetsZero];
    //    }
    //
    //    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    //    {
    //        [cell setLayoutMargins:UIEdgeInsetsZero];
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消正在下载的操作
    [mgr cancelAll];
    // 2.清除内存缓存
    [mgr.imageCache clearMemory];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//-(void)setNeedsStatusBarAppearanceUpdate{
//    self.navBar.frame = CGRectMake(0, 0, SCREEN_W, kTopStatusAndNavBarHeight);
//}
@end
