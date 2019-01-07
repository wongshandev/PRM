//
//  ReceiveGoodsViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/20.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ReceiveGoodsViewController.h"

#import "ReceiveGoodsHeaderView.h"
#import "ReceiveGoodsCell.h"
#import "ReceiveGoodsModel.h"
#import "ReceiveGoodsDetialController.h"


@interface ReceiveGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *dataArray;
@end

@implementation ReceiveGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self setNavigationItems];
    [self registerCellAndHeaderView];
    
    [self requestReceiveGoodsEveryCellData];
    
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
}
-(void)registerCellAndHeaderView{
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveGoodsCell" bundle:nil] forCellReuseIdentifier:@"ReceiveGoodsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveGoodsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ReceiveGoodsHeaderView"];
    
}
-(void)requestReceiveGoodsEveryCellData{
    [self.dataArray removeAllObjects];
    [self showProgressHUD];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"ProcurementSendList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"ProjectBranchID":self.projectBranchID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            ReceiveGoodsModel *model = [[ReceiveGoodsModel alloc] init];
            [model setValuesForKeysWithDictionary: [self changeNullWithDic:[dic mutableCopy]]];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self hideProgressHUD];
        [self showInfoMentation:@"无可加载数据..." ];
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
    ReceiveGoodsHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReceiveGoodsHeaderView"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiveGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveGoodsCell" forIndexPath:indexPath];
    ReceiveGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell showCellDataWithModel:model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiveGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ReceiveGoodsDetialController *receiveDetialVC = [[ReceiveGoodsDetialController alloc]initWithNibName:@"ReceiveGoodsDetialController" bundle:nil];
    receiveDetialVC.realID =[NSString stringWithFormat:@"%@",model.RealID ];
    receiveDetialVC.siteState = [NSString stringWithFormat:@"%@",model.SiteState];
    receiveDetialVC.title = @"收货详情信息";
    
    NSInteger modelState =  model.State.integerValue;
    NSString *message;
    if (model.SiteState.integerValue==1) {
        if (modelState==5) {
            receiveDetialVC.showSubmitItem = YES;
            [self.navigationController pushViewController:receiveDetialVC animated:YES];
        }else{
            if (modelState ==6) {
                message =@"该发货已接收完成,是否查看详情?";
                [self alertViewMentationUsersWithMessage:message VC:receiveDetialVC];
            }else{
                message = @"该发货还未付款,是否查看详情?";
                [self alertViewMentationUsersWithMessage:message VC:receiveDetialVC];
            }
        }        
    }else{
        if (modelState == 3 || modelState == 4) {
            receiveDetialVC.showSubmitItem = YES;
            [self.navigationController pushViewController:receiveDetialVC animated:YES];
        } else {
            if (modelState < 3) {
                message = @"未发货记录不能接收,是否查看详情?";
                [self alertViewMentationUsersWithMessage:message VC:receiveDetialVC];
            } else {
                message =@"该发货已接收完成,是否查看详情?";
                [self alertViewMentationUsersWithMessage:message VC:receiveDetialVC];
            }
        }
    }
}

-(void)alertViewMentationUsersWithMessage:(NSString *)message VC:(ReceiveGoodsDetialController *)receiveDetialVC {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认"message:message preferredStyle:UIAlertControllerStyleAlert];
    //确定按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        receiveDetialVC.showSubmitItem = NO;
        [self.navigationController pushViewController:receiveDetialVC animated:YES];
    }]];
    //取消按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
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
