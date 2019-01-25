//
//  SJYMenuViewController.m
//  PRM
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYMenuViewController.h"
@interface SJYMenuViewController ()<QMUITableViewDelegate,QMUITableViewDataSource>

@property (nonatomic, strong) QMUITableView *tableView;

@end
@implementation SJYMenuViewController

- (void)setUpNavigationBar{
    self.navBar.hidden = YES;
}


-(void)buildSubviews{
    self.tableView = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 90, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;

    [self.view addSubview:self.tableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 90, 250)];
    headerView.backgroundColor = Color_NavigationLightBlue;
    self.tableView.tableHeaderView = headerView;
 }

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSString *identifier = @"cellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;

     cell.imageView.backgroundColor = Color_Red;
    NSString *rowStr = nil;

    switch (indexPath.row) {
        case 0:
            rowStr = [NSString stringWithFormat:@"当前用户 : %@",[SJYDefaultManager shareManager].getEmployeeName];
            cell.imageView.image = nil;
            break;
        case 1:
             // 当前应用名称
             rowStr = [NSString stringWithFormat:@"当前版本 : %@",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
            cell.imageView.image = nil;
            break;
        case 2:
            rowStr = @"注销";
            cell.imageView.image = SJYCommonImage(@"zx");

            break;
        case 3:
            rowStr = @"退出";
            cell.imageView.image = SJYCommonImage(@"tc");
            break;
        default:
            break;
    }
    cell.textLabel.text = rowStr;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 2:
            [self loginOut];
            break;
        case 3:
            [self quitCurrentApp];
            break;
        default:
            break;
    }

//     [[EBBannerView  bannerWithBlock:^(EBBannerViewMaker *make) {
//        make.style = 10;
//        make.content = @"iOS 10 style";
//        make.content = @"MINE eye hath played the painter and hath stelled Thy beauty's form in table of my heart;My body is the frame wherein 'tis held,And perspective it is best painter's art.For through the painter must you see his skillTo fine where your true image pictured lies,Which in my bosom's shop is hanging still,That hath his windows glazèd with thine eyes.";
//    }]show];
    
  }

-(void)quitCurrentApp{
    if (![[SJYDefaultManager shareManager] isRemberPassword]) {
        [[SJYDefaultManager shareManager]saveUserName:@"" password:@""];
        [[SJYDefaultManager shareManager] saveEmployeeName:@"" Dt_Info:@"" EmployeeID:@"" DepartmentID:@"" PositionID:@""];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.4f animations:^{
        CGAffineTransform curent =  window.transform;
        CGAffineTransform scale = CGAffineTransformScale(curent, 0.1,0.1);
        [window setTransform:scale];
    } completion:^(BOOL finished) {
        exit(0);//
    }];
}
-(void)loginOut{
    if (![[SJYDefaultManager shareManager] isRemberPassword]) {
        [[SJYDefaultManager shareManager]saveUserName:@"" password:@""];
        [[SJYDefaultManager shareManager] saveEmployeeName:@"" Dt_Info:@"" EmployeeID:@"" DepartmentID:@"" PositionID:@""];
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate setRootViewController];
}
@end
