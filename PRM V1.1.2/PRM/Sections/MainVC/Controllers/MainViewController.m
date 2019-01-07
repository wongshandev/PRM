//
//  MainViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/7.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MainViewController.h"
#import "LeftMenuView.h"
#import "MainViewCell.h"
#import "MainSectionHeadView.h"
#import "MainModel.h"

#import "MarketViewController.h"
#import "TechnicalViewController.h"
#import "EngineerViewController.h"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)LeftMenuView *leftMenuView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.title = infoDictionary[@"CFBundleDisplayName"];
    self.dataArray = [NSMutableArray new];
    [self setLeftMenuView];
    //加载目录树菜单
    [self requestLoadMenuTreeData];
}
-(void)setLeftMenuView{
    self.leftMenuView   = [LeftMenuView shareLeftMenuView];
    [ self.leftMenuView bindWithViewController:self];
    [self.leftMenuView.quitAppButton addTarget:self action:@selector(quitCurrentApp) forControlEvents:UIControlEventTouchUpInside];
    [self.leftMenuView.logoutButton addTarget:self action:@selector(logouOutCurrentUserAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.leftMenuView];
}

-(void)requestLoadMenuTreeData{
    NSString *urlStr = kRequestUrl(@"FunctionListShow");
    kMyLog(@"%@",urlStr);
#pragma 判断工程部项目经理、施工人员
    [self showProgressHUD];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"EmployeeID":kEmployeeID} finish:^(id responder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            kMyLog(@"%@",responder);
            if ([[responder objectForKey:@"success"]boolValue]== YES) {
                NSArray *menuArr = [responder objectForKey:@"menu"];
                for (NSDictionary *dic in menuArr) {
                    MainModel *sectionModel = [[MainModel alloc] init];
                    [sectionModel setValuesForKeysWithDictionary:dic];
                    sectionModel.Id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
#warning fen qu nei de CellModel
                    NSMutableArray *sectionArr = [NSMutableArray new];
                    NSArray *childrenArr = [dic objectForKey:@"children"];
                    if (childrenArr.count !=0) {
                        for (NSDictionary *cellDic in [dic objectForKey:@"children"]) {
                            MainModel *cellModel = [[MainModel alloc]init];
                            [cellModel setValuesForKeysWithDictionary:cellDic];
                            cellModel.Id = [NSString stringWithFormat:@"%@",[cellDic objectForKey:@"id"]];
                            [sectionArr addObject:cellModel];
                        }
                        sectionModel.children = sectionArr;
                        [self.dataArray addObject:sectionModel];
                    }
                }
            }else{
                [self showMessageLabel:[responder objectForKey:@"msg"] withBackColor:kWarningColor_lightRedColor];
            }
            [self.collectionView reloadData];
            [self hideProgressHUD];
        });
    } conError:^(NSError *error) {
        [self hideProgressHUD];
        kMyLog(@"%@",error);
    }];
}




#pragma mark ---------------------------右滑菜单
- (IBAction)showLeftMenuAction:(UIBarButtonItem *)sender {
    [self.leftMenuView inputOfSightMenuView];
}
-(void)quitCurrentApp{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.4f animations:^{
        CGAffineTransform curent =  window.transform;
        CGAffineTransform scale = CGAffineTransformScale(curent, 0.1,0.1);
        [window setTransform:scale];
    } completion:^(BOOL finished) {
         exit(0);//
    }];
 }
-(void)logouOutCurrentUserAccount{
    [self.leftMenuView outOfSightMenuView];
    //发送退出登录请求  //并 标记登录状态
    if (![[UserDefaultManager shareUserDefaultManager]isRemberPassword]) {
        [[UserDefaultManager shareUserDefaultManager] saveUserName:@"" password:@""];
        [[UserDefaultManager shareUserDefaultManager] saveEmployeeName:@"" Dt_Info:@"" EmployeeID:@"" DepartmentID:@"" PositionID:@""];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------------UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 90);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kDeviceWidth, 40);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, (kDeviceWidth - 4*80)/4, 5, (kDeviceWidth - 4*80)/4);
}
#pragma mark ------------------UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MainSectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MainSectionHeadView" forIndexPath:indexPath];
    MainModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
   headerView.headTitleLabel.text = [NSString stringWithFormat:@"%@",sectionModel.text];
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MainModel *model = [self.dataArray  objectAtIndex:section];
    return model.children.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainViewCell" forIndexPath:indexPath]; 
    MainModel *sectionModel = [self.dataArray  objectAtIndex:indexPath.section];
    MainModel *cellModel = [sectionModel.children objectAtIndex:indexPath.row];
    [cell showMainCellDataWithModel:cellModel];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *sectionModel = [self.dataArray  objectAtIndex:indexPath.section];
    MainModel *cellModel = [sectionModel.children objectAtIndex:indexPath.row];
    
    NSString *departMentID = [[UserDefaultManager shareUserDefaultManager]getDepartmentID];
    
    if ([departMentID integerValue] == 1) {
        MarketViewController *engineerVC = [[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil];
        engineerVC.title = [NSString stringWithFormat:@"%@",cellModel.text];
        engineerVC.mainModel = cellModel;
        [self.navigationController pushViewController:engineerVC animated:YES];
    }
    if ([departMentID integerValue] == 2){
        TechnicalViewController *engineerVC = [[TechnicalViewController alloc] initWithNibName:@"TechnicalViewController" bundle:nil];
        engineerVC.title = [NSString stringWithFormat:@"%@",cellModel.text];
        engineerVC.mainModel = cellModel;
        [self.navigationController pushViewController:engineerVC animated:YES];
    }
    if ([departMentID integerValue] == 3){
        EngineerViewController *engineerVC = [[EngineerViewController alloc] initWithNibName:@"EngineerViewController" bundle:nil];
        engineerVC.title = [NSString stringWithFormat:@"%@",cellModel.text];
        engineerVC.mainModel = cellModel;
        [self.navigationController pushViewController:engineerVC animated:YES];
    } 
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
