//
//  EngineerInfoViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/13.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "EngineerInfoViewController.h"

#import "ProgressReportHeaderView.h"
#import "ProgressReportCell.h"
#import "ProgressReportModel.h"

#import "MaterialPalnHeaderView.h"
#import "MaterialPalnCell.h"
#import "MaterialPalnModel.h"

#import "MatericalPlanDetialController.h"

@interface EngineerInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *progressReportButton;
@property (weak, nonatomic) IBOutlet UIButton *materialPlanButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *progressReportTableView;
@property(strong,nonatomic)NSMutableArray *progressReportArray;

@property (weak, nonatomic) IBOutlet UITableView *materialPlanTableView;
@property(strong,nonatomic)NSMutableArray *materialPlanArray;


@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSMutableArray<NSDictionary *> *updateArray;


@property(copy,nonatomic)NSString *dState;

@end

@implementation EngineerInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItems];
    self.progressReportButton.selected = YES;
    self.progressReportButton.tintColor = [UIColor orangeColor];
    self.progressReportArray = [NSMutableArray new];
    self.materialPlanArray = [NSMutableArray new];
    self.updateArray = [NSMutableArray new];
    
    [self registCurrentViewCells];
    
    self.progressReportTableView.estimatedRowHeight = 90;
    self.progressReportTableView.rowHeight = UITableViewAutomaticDimension;
    self.materialPlanTableView.estimatedRowHeight = 90;
    self.materialPlanTableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.jumpDeriction == isMatericalPlanDetialVCToEngineerInfoVC) {
        [self requestData_WLJH];
    }
}
#pragma mark ------------------------配置NavigationItems
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
}
-(void)registCurrentViewCells{
    [self.progressReportTableView registerNib:[UINib nibWithNibName:@"ProgressReportHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ProgressReportHeaderView"];
    [self.progressReportTableView registerNib:[UINib nibWithNibName:@"ProgressReportCell" bundle:nil] forCellReuseIdentifier:@"ProgressReportCell"];
    [self requestData_JDHB];
    
    [self.materialPlanTableView registerNib:[UINib nibWithNibName:@"MaterialPalnHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MaterialPalnHeaderView"];
    [self.materialPlanTableView registerNib:[UINib nibWithNibName:@"MaterialPalnCell" bundle:nil] forCellReuseIdentifier:@"MaterialPalnCell"];
}

-(void)requestData_JDHB{
    [self showProgressHUD];
    [self.progressReportArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"ProjectProcessList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"ProjectBranchID":self.projectBranchID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            ProgressReportModel *model = [[ProgressReportModel alloc] init];
            [model setValuesForKeysWithDictionary: [self changeNullWithDic:[dic mutableCopy]]];
            [self.progressReportArray addObject:model];
        }
        self.dataArray =  self.progressReportArray;
        [self.progressReportTableView reloadData];
        [self hideProgressHUD];
        [self showInfoMentation:@"进度汇报无可加载数据..."];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self hideProgressHUD];
        [self showMessageLabel:@"进度汇报数据出错..." withBackColor:kGeneralColor_lightCyanColor];
    }];
}

-(void)requestData_WLJH{
    [self.materialPlanArray removeAllObjects];
    [self showProgressHUD];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppMarketOrderList"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"ProjectBranchID":self.projectBranchID} finish:^(id responder) {
        kMyLog(@"%@",responder);
        self.dState = [responder objectForKey:@"dState"] ;
        NSArray *rowsArr = [responder objectForKey:@"rows"];
        [self FengZhuangWithDic:rowsArr.firstObject];
        for (NSDictionary *dic in rowsArr) {
            MaterialPalnModel *model = [[MaterialPalnModel alloc] init];
            [model setValuesForKeysWithDictionary: [self changeNullWithDic:[dic mutableCopy]]];
            [self.materialPlanArray addObject:model];
        }
        self.dataArray =  self.materialPlanArray;
        [self.materialPlanTableView reloadData];
        [self hideProgressHUD];
        [self showInfoMentation:@"物料计划无可加载数据..." ];
    } conError:^(NSError *error) {
        kMyLog(@"%@",error);
        [self hideProgressHUD];
        [self showMessageLabel:@"物料计划数据请求出错..." withBackColor:kGeneralColor_lightCyanColor];
    }];
    
}

-(void)showInfoMentation:(NSString *)str{
    if (self.dataArray.count ==0 ) {
        [self showMessageLabel:str  withBackColor:kGeneralColor_lightCyanColor];
    }
}


- (IBAction)progressReportAction:(UIButton *)sender {
    sender.selected = YES;
    self.materialPlanButton.selected = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    sender.tintColor =  [UIColor orangeColor];
    [self requestData_JDHB];
    
}
- (IBAction)materialPlanAction:(UIButton *)sender {
    sender.selected = YES;
    self.progressReportButton.selected = NO;
    sender.tintColor=  [UIColor orangeColor];
    [self.scrollView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:YES];
    [self requestData_WLJH];
}
#pragma mark ******************************UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger curPage = scrollView.contentOffset.x / kDeviceWidth;
        [self.scrollView setContentOffset:CGPointMake(kDeviceWidth*curPage, 0) animated:YES];
        switch (curPage) {
            case 0:
                self.progressReportButton.tintColor = [UIColor orangeColor];
                self.progressReportButton.selected = YES;
                self.materialPlanButton.selected = NO;
                
                break;
            case 1:
                self.progressReportButton.selected = NO;
                self.materialPlanButton.selected = YES;
                self.materialPlanButton.tintColor = [UIColor orangeColor];
                [self requestData_WLJH];
                break;
            default:
                break;
        }
    }
}
#pragma mark ******************************UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.progressReportTableView) {
        return  self.progressReportArray.count;
    }else{
        return  self.materialPlanArray.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.progressReportTableView) {
        ProgressReportHeaderView *view1 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ProgressReportHeaderView"];
        return view1;
    }else{
        MaterialPalnHeaderView*view1 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MaterialPalnHeaderView"];
        return view1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.progressReportTableView) {
        ProgressReportModel *model = [self.progressReportArray objectAtIndex:indexPath.row];
        ProgressReportCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressReportCell" forIndexPath:indexPath];
        [cell showCellDataWithModel:model];
        return cell;
    }else{
        MaterialPalnModel *model = [self.materialPlanArray objectAtIndex:indexPath.row];
        MaterialPalnCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MaterialPalnCell" forIndexPath:indexPath];
        [cell showCellDataWithModel:model];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==self.progressReportTableView) {
        ProgressReportModel *model = [self.progressReportArray objectAtIndex:indexPath.row];
        ProgressReportCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [self clickProgressReportCell:cell alertViewWithModel:model];
    }else{
        MaterialPalnModel *model = [self.materialPlanArray objectAtIndex:indexPath.row];
        MaterialPalnCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [self clickMatericalPlanCell:cell alertViewWithModel:model];
    }
    
}

-(void)clickProgressReportCell:( ProgressReportCell *)cell alertViewWithModel:(ProgressReportModel*)model{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"进度及备注信息设置" message:[NSString stringWithFormat:@"输入的进度范围在%@ ~ 100 之间",model.CompletionRate] preferredStyle:UIAlertControllerStyleAlert];
    //进度输入框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = [NSString stringWithFormat:@"%.0f", cell.completeProgress.progress*100];
    }];
    //备注信息输入框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        cell.descriptionLabel.text.length == 0 ? (textField.placeholder =@"请输入备注信息" ): (textField.text = [NSString stringWithFormat:@"%@",cell.descriptionLabel.text]);
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //  cell 界面 数据 的调整
            if ([alertVC.textFields[0].text integerValue] > 100 ) {
                cell.progressLabel.text = @"100%";
                [self showMessageLabel:@"超出默认范围上限"  withBackColor:kGeneralColor_lightCyanColor];
            }else if([alertVC.textFields[0].text integerValue] < model.CompletionRate.integerValue){
                cell.progressLabel.text = [NSString stringWithFormat:@"%@%%", model.CompletionRate];
                [self showMessageLabel:@"超出默认范围下限" withBackColor:kGeneralColor_lightCyanColor];
            }else{
                cell.progressLabel.text = [alertVC.textFields[0].text stringByAppendingString:@"%"];
            }
            NSString *rateStr = [cell.progressLabel.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSInteger rate =  [rateStr integerValue];
            cell.stateLabel.text = (rate == 0?@"未开工":rate == 100?@"已完成":@"施工中");
            cell.completeProgress.progress = rate / 100.0;
            cell.descriptionLabel.text = [NSString stringWithFormat:@"%@",alertVC.textFields[1].text];
            
            //数据处理 添加进入数组
            NSDictionary *currentDic= @{@"Id":model.Id,@"Remark":alertVC.textFields[1].text,@"CompletionRate":rateStr};
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
        }); 
    }]];
    //取消按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)clickMatericalPlanCell:(MaterialPalnCell *)cell alertViewWithModel:(MaterialPalnModel *)model{
    kMyLog(@"%@",model.MarketDate);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择相关功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
    MatericalPlanDetialController *detialVC = [[MatericalPlanDetialController alloc]initWithNibName:@"MatericalPlanDetialController" bundle:nil];
    detialVC.isSaveItem = NO;
    detialVC.marketOrderID = model.Id;
    detialVC.projectBranchID = self.projectBranchID;
    detialVC.JumpBlock = ^(JumpDirection jump){
        self.jumpDeriction = jump;
    };
    
    if (self.dState.integerValue>= 7 ) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"新增" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            detialVC.title = @"新增物料信息";
            detialVC.marketOrderID = @"0";
            [self.navigationController pushViewController:detialVC animated:YES];
        }]];
    }
    
    if (self.dState.integerValue >= 7 && (model.State.integerValue == 3 || model.State.integerValue ==1)) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            detialVC.title = @"修改物料信息";
            detialVC.deliveryDate = model.OrderDate;
            detialVC.marketOrderID = model.Id;
            [self.navigationController pushViewController:detialVC animated:YES];
        }]];
    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        detialVC.title = @"查看物料信息";
        detialVC.deliveryDate = model.OrderDate;
        detialVC.isSaveItem = YES;
        [self.navigationController pushViewController:detialVC animated:YES];
    }]];
    
    if (model.State.integerValue == 1) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestSubmitDataWithModel:model];
        }]];
    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler: nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)requestSubmitDataWithModel:(MaterialPalnModel *)model{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppApprovalMO"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"EmployeeID":kEmployeeID,@"State":@"2",@"MarketOrderID":model.Id} finish:^(id responder) {
        [self hideProgressHUD];
        kMyLog(@"%@",responder);
        [self showMessageLabel:[responder valueForKey:@"msg"]withBackColor:kGeneralColor_lightCyanColor];
        if ([[responder valueForKey:@"success"] boolValue] == YES) {
            [self.dataArray removeAllObjects];
            [self performSelectorOnMainThread:@selector(requestData_WLJH) withObject:nil waitUntilDone:YES];
        }
    } conError:^(NSError *error) {
        kMyLog(@"error   %@",error);
        [self hideProgressHUD];
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)submitProgressAction:(UIButton *)sender {
    kMyLog(@"%@",self.updateArray);
    if (self.updateArray.count != 0) {
        [self showProgressHUD];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppSaveProcessRate"];
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.updateArray options:NSJSONWritingPrettyPrinted error:&jsonError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"EmployeeID":kEmployeeID,@"updated":jsonString} finish:^(id responder) {
            [self hideProgressHUD];
            kMyLog(@"%@",responder);
            [self showMessageLabel:[responder valueForKey:@"msg"]withBackColor:kGeneralColor_lightCyanColor];
            if ([[responder valueForKey:@"success"] boolValue]== YES) {
                [self.updateArray removeAllObjects];
                [self performSelectorOnMainThread:@selector(requestData_JDHB) withObject:nil waitUntilDone:YES];
            }
        } conError:^(NSError *error) {
            kMyLog(@"error   %@",error);
            [self hideProgressHUD];
        }];
    }else{
        [self showMessageLabel:@"没有数据需要提交" withBackColor:kGeneralColor_lightCyanColor];
    }
}
- (IBAction)addNewMaterialPaln:(UIButton *)sender {
    kMyLog(@"XZ"); 
    MatericalPlanDetialController *detialVC = [[MatericalPlanDetialController alloc]initWithNibName:@"MatericalPlanDetialController" bundle:nil];
    detialVC.isSaveItem = NO;
    detialVC.title = @"新增物料信息";
    detialVC.marketOrderID = @"0";
    detialVC.projectBranchID = self.projectBranchID;
    detialVC.JumpBlock = ^(JumpDirection jump){
        self.jumpDeriction = jump;
    };
    [self.navigationController pushViewController:detialVC animated:YES];
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
