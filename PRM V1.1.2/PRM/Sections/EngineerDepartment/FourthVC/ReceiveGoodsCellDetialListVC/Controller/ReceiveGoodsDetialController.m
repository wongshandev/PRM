//
//  ReceiveGoodsDetialController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/21.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "ReceiveGoodsDetialController.h"
#import "ReceiveGoodsDetialCell.h"
#import "ReceiveGoodsDetialHeaderView.h"
#import "ReceiveGoodsDetialModel.h"
@interface ReceiveGoodsDetialController ()<UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray<NSDictionary *> *updateArray;

@end

@implementation ReceiveGoodsDetialController
-(NSMutableArray<NSDictionary *> *)updateArray{
    if (!_updateArray) {
        self.updateArray = [NSMutableArray new];
    }
    return _updateArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self setNavigationItems];
    
    [self registerCellsAndHeaderView];
    [self requestCurrentViewData];
    
    
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    if (self.showSubmitItem) {
        UIBarButtonItem *queding_Item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction:)];
        [self.navigationItem setRightBarButtonItem:queding_Item];
    }

}

-(void)registerCellsAndHeaderView{
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveGoodsDetialCell" bundle:nil] forCellReuseIdentifier:@"ReceiveGoodsDetialCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveGoodsDetialHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ReceiveGoodsDetialHeaderView"];
}

-(void)requestCurrentViewData{
    [self.dataArray removeAllObjects];
    [self showProgressHUD];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppPODList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"RealID":self.realID,@"SiteState":self.siteState} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            ReceiveGoodsDetialModel *model = [[ReceiveGoodsDetialModel alloc] init];
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
    ReceiveGoodsDetialHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReceiveGoodsDetialHeaderView"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiveGoodsDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveGoodsDetialCell" forIndexPath:indexPath];
    ReceiveGoodsDetialModel *model = self.dataArray[indexPath.row];
    [cell showCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiveGoodsDetialModel *model = self.dataArray[indexPath.row];
    ReceiveGoodsDetialCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.showSubmitItem) {
        [self clickReceiveGoodsDetialCell:cell alertViewWithModel:model];
    }
}


-(void)clickReceiveGoodsDetialCell:( ReceiveGoodsDetialCell *)cell alertViewWithModel:(ReceiveGoodsDetialModel*)model{
     NSString *maxNum = [NSString stringWithFormat:@"%ld",model.Quantity.integerValue - model.QuantityReceive.integerValue];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入本次数量"message:[NSString stringWithFormat:@"本次输入值的范围在0 ~ %@ 之间",maxNum] preferredStyle:UIAlertControllerStyleAlert];
    //进度输入框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    //备注信息输入框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        cell.markLabel.text.length == 0 ? (textField.placeholder =@"请输入备注信息" ): (textField.text = [NSString stringWithFormat:@"%@",cell.markLabel.text]);
    }];
    [alertVC.textFields[0] makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    [alertVC.textFields[1] makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    for (UITextField *textField in alertVC.textFields) {
        textField.font= [UIFont systemFontOfSize:15];
    }
    //确定按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  cell 界面 数据 的调整
        if ([alertVC.textFields[0].text integerValue] > maxNum.integerValue ) {
            cell.thisReceiveLabel.text = maxNum;
            [self showMessageLabel:@"超出范围上限"  withBackColor:kGeneralColor_lightCyanColor];
        }else if([alertVC.textFields[0].text integerValue] < 0){
            cell.thisReceiveLabel.text = @"0";
            [self showMessageLabel:@"超出范围下限" withBackColor:kGeneralColor_lightCyanColor];
        }else{
            cell.thisReceiveLabel.text = [NSString stringWithFormat:@"%@",alertVC.textFields.firstObject.text];
        }
        
        
        cell.markLabel.text = [NSString stringWithFormat:@"%@",alertVC.textFields[1].text];
        
        //数据处理 添加进入数组
        NSDictionary *currentDic= @{@"Id":model.Id,@"Remark":cell.markLabel.text,@"QuantityCheck":cell.thisReceiveLabel.text,@"ModId":model.ModId};
        if (self.updateArray.count== 0) {
            [self.updateArray addObject:currentDic];
        }else{
            kMyLog(@"%@", self.updateArray);
            for (int i = 0;  i < self.updateArray.count; i++) {
                NSDictionary *dic = self.updateArray[i];
                if ([[dic valueForKey:@"Id"] isEqual:[currentDic valueForKey:@"Id"]]) {
                    [self.updateArray removeObject:dic];
                    [self.updateArray addObject:currentDic];
                }else{
                    [self.updateArray addObject:currentDic];
                }
            }
        }
    }]];
    //取消按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}



-(void)confirmAction:(UIBarButtonItem *)sender{
    if (self.updateArray.count == 0) {
        [self showMessageLabel:@"没有数据需要提交" withBackColor:kGeneralColor_lightCyanColor];
    }else{
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.updateArray options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kBaseUrl,@"SaveReceive"];
    NSDictionary *  paraDic = @{
                                @"EmployeeID":kEmployeeID,
                                @"SiteState":self.siteState,
                                @"RealID":self.realID,
                                @"updated":jsonString
                                };
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic: paraDic finish:^(id responder) {
        [self hideProgressHUD];
        kMyLog(@"%@",responder);
        [self showMessageLabel:[responder valueForKey:@"msg"]withBackColor:kGeneralColor_lightCyanColor];
        if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [self.updateArray removeAllObjects];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } conError:^(NSError *error) {
        kMyLog(@"error   %@",error);
        [self showMessageLabel:@"数据上传保存出错" withBackColor:kGeneralColor_lightCyanColor];
        [self hideProgressHUD];
    }];
    }

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
