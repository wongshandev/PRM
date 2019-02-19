//
//  SJYMainViewController.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYMainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainViewCell.h"
#import "MainModel.h"

#define kMargain 5
#define kItemWdith 100
@interface SJYMainViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray  *dateSource;


@end
 @implementation SJYMainViewController

- (void)setUpNavigationBar{
    Weak_Self;
     self.navBar.backButton.hidden = YES;
    self.navBar.leftButton.hidden = NO;
    self.navBar.titleLabel.text = DisplayName;
    [self.navBar.leftButton setImage:SJYCommonImage(@"caidan") forState:UIControlStateNormal];
    [self.navBar.leftButton clickWithBlock:^{
        [weakSelf.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
}

-(void)buildSubviews{
    self.dateSource = [NSMutableArray new];
     [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).mas_offset(UIEdgeInsetsMake(NAVHEIGHT, 0, 0, 0));
    }];

}


-(void)bindViewModel{
    NSLog(@"%@",[SJYUserManager sharedInstance].sjyloginData.Id);
    [QMUITips showLoading:@"" inView:self.view];
    [ SJYRequestTool requestMainFunctionList:[SJYUserManager sharedInstance].sjyloginData.Id complete:^(id responder) {
        NSLog(@"%@",responder);
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([[responder objectForKey:@"success"]boolValue]== YES) {
                NSArray *menuArr = [responder objectForKey:@"menu"];
                for (NSDictionary *dic in menuArr) {
                    MainModel *sectionModel = [MainModel modelWithDictionary:dic];
                    if (sectionModel.children.count) {
                        [self.dateSource addObject:sectionModel];
                    }
                }
                 [self.collectionView reloadData];
                 [QMUITips hideAllTips];
            }else{
                [self.collectionView reloadData];
                [QMUITips hideAllTips];
                [QMUITips showError:[responder objectForKey:@"msg"] inView:self.view hideAfterDelay:1.5];
             }
         });
    }];
}
#pragma mark ------------------UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 90);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_W, 40);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, (SCREEN_W - 4*80)/4, 5, (SCREEN_W - 4*80)/4);
}
#pragma mark ------------------UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dateSource.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
    MainModel *sectionModel = [self.dateSource objectAtIndex:indexPath.section];
    UILabel *label = [[UILabel alloc] init];
    label.text = sectionModel.text;
    label.textColor = Color_White;
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    headerView.backgroundColor = Color_NavigationLightBlue;
     return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MainModel *model = [self.dateSource  objectAtIndex:section];
    return model.children.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainViewCell" forIndexPath:indexPath];
    MainModel *sectionModel = [self.dateSource  objectAtIndex:indexPath.section];
    MainModel *cellModel = [sectionModel.children objectAtIndex:indexPath.row];
    [cell showMainCellDataWithModel:cellModel];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *sectionModel = [self.dateSource  objectAtIndex:indexPath.section];
    MainModel *cellModel = [sectionModel.children objectAtIndex:indexPath.row];
    
    JumpURL jump = KJumpURLToEnum(cellModel.url);
    switch (jump) {
        case  FileTransferEngineering : //工程  -- 交接确认；
        case FileTransfer: //市场部 项目交接
        case FileTransferDesign://技术部 交接确认
        {
            SJYJJQRViewController *jjqrVC=  [[SJYJJQRViewController alloc] init];
            jjqrVC.mainModel = cellModel;
            jjqrVC.title = cellModel.text;
            [self.navigationController pushViewController:jjqrVC animated:YES];
        }
            break;
        case PurchaseOrderPay: //技术部 ----- 采购付款；
        {
            SJYCGFKListController *cgfkListVC = [[SJYCGFKListController alloc]init];
            cgfkListVC.mainModel = cellModel;
            cgfkListVC.title = cellModel.text;
            [self.navigationController pushViewController:cgfkListVC animated:YES];
        } 
            break;
        case Engineering: //施工管理
        case Procurement: //现场收货
        {
            SGGLXCSHListController *sgxcListVC = [[SGGLXCSHListController alloc]init];
            sgxcListVC.mainModel = cellModel;
            sgxcListVC.title = cellModel.text;
            [self.navigationController pushViewController:sgxcListVC animated:YES];
        }
            break;
        case ChangeOrders: //项目变更
        {
            SJYXMBGViewController *xmbgVC  = [[SJYXMBGViewController alloc]init];
            xmbgVC.mainModel = cellModel;
            xmbgVC.title = cellModel.text;
            [self.navigationController pushViewController:xmbgVC animated:YES];
        }
            break;
        case ProjectProcess: //项目进度
        {
            SJYXMJDViewController *xmjdVC = [[SJYXMJDViewController alloc] init];
            xmjdVC.mainModel = cellModel;
            xmjdVC.title = cellModel.text;
            [self.navigationController pushViewController:xmjdVC animated:YES];
            
        }
            break;
        case MySpending: //我的报销
            
            break;
        case MarketOrder:  // 工程部----项目请购
        {
            SJYXMQGViewController *xmqgVC = [[SJYXMQGViewController alloc] init];
            xmqgVC.mainModel = cellModel;
            xmqgVC.title = cellModel.text;
            [self.navigationController pushViewController:xmqgVC animated:YES];
        }
            break;
        case ChangeOrdersApprove: //变更审核
        {
            SJYBGSHViewController *bgshVC = [[SJYBGSHViewController alloc] init];
            bgshVC.mainModel = cellModel;
            bgshVC.title = cellModel.text;
            [self.navigationController pushViewController:bgshVC animated:YES];
        }
            break;
        case ProjectApproval:  //任务分配；
        {
            SJYRWFPListController * rwfpVC = [[SJYRWFPListController alloc]init];
            rwfpVC.mainModel = cellModel;
            rwfpVC.title = cellModel.text;
            [self.navigationController pushViewController:rwfpVC animated:YES];
        }
            break;
        case EngineeringAssign:  //工程分配；
        {
            SJYGCFPListController * rwfpVC = [[SJYGCFPListController alloc]init];
            rwfpVC.mainModel = cellModel;
            rwfpVC.title = cellModel.text;
            [self.navigationController pushViewController:rwfpVC animated:YES];
        }
            break;
        case DesignAllApprove: // 技术部--- 设计审核；
        {
            SJYSJSHViewController *sjshVC = [[SJYSJSHViewController alloc]init];
            sjshVC.mainModel = cellModel;
            sjshVC.title = cellModel.text;
            [self.navigationController pushViewController:sjshVC animated:YES];
        }
            break;
        case PurchaseApprove: // 采购审核；
        {
            SJYCGSHViewController *cgshVC = [[SJYCGSHViewController alloc] init];
            cgshVC.mainModel = cellModel;
            cgshVC.title = cellModel.text;
            [self.navigationController pushViewController:cgshVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Retain Count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(void)dealloc{
    NSLog(@"释放");
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[MainViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MainViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"]; //注册头视图
     }
    return _collectionView;
}



@end
