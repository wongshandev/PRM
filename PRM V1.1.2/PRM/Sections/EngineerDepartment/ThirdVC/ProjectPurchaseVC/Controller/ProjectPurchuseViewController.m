//
//  ProjectPurchuseViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/20.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ProjectPurchuseViewController.h"

#import "PurchaseDetialCell.h"
#import "PurchaseDetialHeaderView.h"
#import "PurchaseDetialModel.h"

@interface ProjectPurchuseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ProjectPurchuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self setNavigationItems];
    
    [self registerCellsAndHeaderView];
    
    [self requestCuurrentViewData];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    UIBarButtonItem *queding_Item = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction:)];
     UIBarButtonItem *bohui_Item = [[UIBarButtonItem alloc] initWithTitle:@"驳回" style:UIBarButtonItemStylePlain target:self action:@selector(rejectAction:)];
    [self.navigationItem setRightBarButtonItems:@[bohui_Item,queding_Item]];
}

-(void)confirmAction:(UIBarButtonItem *)item{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认审核通过吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self request_QueRenButtonItemData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)rejectAction:(UIBarButtonItem *)item{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入驳回原因" message:@"确认审核通过吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.font = [UIFont systemFontOfSize:15];
        textField.textAlignment= NSTextAlignmentCenter;
    }];
    
    [alert.textFields.firstObject makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alert.textFields.firstObject.text.length==0) {
            [self showMessageLabel:@"驳回原因不能为空" withBackColor:kGeneralColor_lightCyanColor];
        }else{
            
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)request_QueRenButtonItemData{
    [self showProgressHUD];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppApprovalMO"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"EmployeeID":kEmployeeID,@"State":@"4",@"MarketOrderID":self.marketOrderID} finish:^(id responder) {
        [self hideProgressHUD];
        kMyLog(@"%@",responder);
        [self showMessageLabel:[responder valueForKey:@"msg"]withBackColor:kGeneralColor_lightCyanColor];
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [self performSelectorOnMainThread:@selector(requestCuurrentViewData) withObject:nil waitUntilDone:YES];
        }
    } conError:^(NSError *error) {
        kMyLog(@"error   %@",error);
        [self hideProgressHUD];
    }];

}



-(void)registerCellsAndHeaderView{
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseDetialHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PurchaseDetialHeaderView"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseDetialCell" bundle:nil] forCellReuseIdentifier:@"PurchaseDetialCell"];
}

-(void)requestCuurrentViewData{
    [self showProgressHUD];
    [self.dataArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppMarketOrderInfo"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"MarketOrderID":self.marketOrderID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            PurchaseDetialModel *model = [[PurchaseDetialModel alloc] init];
            [model setValuesForKeysWithDictionary: [self changeNullWithDic:[dic mutableCopy]]];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self hideProgressHUD];
        [self showInfoMentation:@"无可加载数据..."];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self hideProgressHUD];
        [self showMessageLabel:@"数据请求出错..." withBackColor:kGeneralColor_lightCyanColor];
    }];
    
}
-(void)showInfoMentation:(NSString *)str{
    if (self.dataArray.count ==0 ) {
        [self showMessageLabel:str  withBackColor:kGeneralColor_lightCyanColor];
    }
}

#pragma mark ------------------------UITableViewDelegate,UITableViewDataSource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PurchaseDetialHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PurchaseDetialHeaderView"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseDetialCell"];
    PurchaseDetialModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell showCellDataWithModel:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
