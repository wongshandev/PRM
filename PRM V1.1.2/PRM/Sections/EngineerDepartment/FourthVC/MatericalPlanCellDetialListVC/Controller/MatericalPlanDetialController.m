//
//  MatericalPlanDetialController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/16.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MatericalPlanDetialController.h"
#import "MatericalPlanDetialCell.h"
#import "MaterialPlanDetialModel.h"
#import "MatericalPlanDetialHeaderView.h"
@interface MatericalPlanDetialController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *sectionArray;
@property(nonatomic,strong)NSMutableArray *dataArray;



@property(nonatomic,strong)NSMutableArray<NSDictionary *> *insertArray;
@property(nonatomic,strong)NSMutableArray<NSDictionary *> *savedArray;


@end

@implementation MatericalPlanDetialController
-(NSMutableArray *)savedArray{
    if (!_savedArray) {
        self.savedArray = [NSMutableArray new];
    }
    return _savedArray;
}
-(NSMutableArray *)insertArray{
    if (!_insertArray) {
        self.insertArray = [NSMutableArray new];
    }
    return _insertArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray= [NSMutableArray new];
    self.sectionArray= [NSMutableArray new];
    [self setNavigationItems];
    if (self.marketOrderID.integerValue != 0 ) {
        self.createDateLabel.text = [NSString stringWithFormat:@"%@",self.deliveryDate];
        if (self.isSaveItem) {//是查看详情
            self.dateSelectButton.userInteractionEnabled = NO;
        }
    }
    [self registerCurrentViewCells];
    [self requestMatericalPlanCellListData];
    
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    if (!self.isSaveItem) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction:)];
        [self.navigationItem setRightBarButtonItem:saveItem];
    }
}

-(void)frontPageAction:(UIBarButtonItem *)sender{
    self.JumpBlock(isMatericalPlanDetialVCToEngineerInfoVC);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)registerCurrentViewCells{
    [self.tableView registerNib:[UINib nibWithNibName:@"MatericalPlanDetialCell" bundle:nil] forCellReuseIdentifier:@"MatericalPlanDetialCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MatericalPlanDetialHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MatericalPlanDetialHeaderView"];
}


-(void)requestMatericalPlanCellListData{
    [self showProgressHUD];
    NSString *urlStr=[NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppMODList"];
    
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic:@{@"ProjectBranchID":self.projectBranchID ,@"MarketOrderID":self.marketOrderID} finish:^(id responder) {
        [self hideProgressHUD];
        kMyLog(@"%@",responder);
        NSArray *rowsArr = [responder valueForKey:@"rows"];
        [self FengZhuangWithDic:[rowsArr firstObject]];
        
        NSMutableArray *cellsArr = [NSMutableArray new];
        for (NSDictionary *dic in rowsArr) {
            MaterialPlanDetialModel *model = [[MaterialPlanDetialModel alloc]init];
            [model setValuesForKeysWithDictionary:[ self changeNullWithDic:[dic mutableCopy]]];
            if ([[dic valueForKey:@"_parentId"]integerValue] == 0) {
                [self.sectionArray addObject:model];
            }else{
                [cellsArr addObject:model];
            }
        }
        
        for (NSInteger i = 0; i < self.sectionArray.count; i ++ ) {
            MaterialPlanDetialModel *sectionModel = self.sectionArray[i];
            NSMutableArray *sectionArr = [NSMutableArray new];
            for (NSInteger j = 0; j < cellsArr.count; j++) {
                MaterialPlanDetialModel *cellModel = cellsArr[j];
                if (sectionModel.Id == cellModel._parentId) {
                    [sectionArr addObject:cellModel];
                }
            }
            [self.dataArray addObject:sectionArr];
        }
        
        [self.tableView reloadData];
    } conError:^(NSError *error) {
        [self hideProgressHUD];
    }];
}

#pragma mark **************************UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MaterialPlanDetialModel *model = [self.sectionArray objectAtIndex:section];
    MatericalPlanDetialHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MatericalPlanDetialHeaderView"];
    view.nameLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MaterialPlanDetialModel *model = [self.dataArray objectAtIndex:indexPath.section] [indexPath.row];
    
    MatericalPlanDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatericalPlanDetialCell" forIndexPath:indexPath];
    [cell showCellDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MaterialPlanDetialModel *model = [self.dataArray objectAtIndex:indexPath.section] [indexPath.row];
    MatericalPlanDetialCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *maxNum = [NSString stringWithFormat:@"%ld",(model.Quantity.integerValue - model.QuantityPurchased.integerValue)];
    NSString *messageStr = [NSString stringWithFormat:@" 本次输入的范围:0 ~ %@",maxNum];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"输入本次申请数量:" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font= [UIFont systemFontOfSize:15];
        
    }];
    [alertVC.textFields[0] makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(35);
    }];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC.textFields[0] endEditing:YES];
        if ([alertVC.textFields[0].text integerValue] > maxNum.integerValue ) {
            cell.thisApplyLabel.text = maxNum;
            [self showMessageLabel:@"超出范围上限"  withBackColor:kGeneralColor_lightCyanColor];
        }else if([alertVC.textFields[0].text integerValue] < 0){
            cell.thisApplyLabel.text = @"0";
            [self showMessageLabel:@"超出范围下限" withBackColor:kGeneralColor_lightCyanColor];
        }else{
            cell.thisApplyLabel.text = [NSString stringWithFormat:@"%@",alertVC.textFields.firstObject.text];
        }
        //数据处理 添加进入数组
        NSDictionary *currentDic= @{@"QuantityThis":cell.thisApplyLabel.text,@"BOMID":model.BOMID,@"ModId":model.ModId,@"Id":model.Id};
//        if (model.ModId.integerValue != 0) {
            if (self.savedArray.count== 0) {
                [self.savedArray addObject:currentDic];
            }else{
                kMyLog(@"%@", self.savedArray);
                for (int i = 0;  i < self.savedArray.count; i++) {
                    NSDictionary *dic = self.savedArray[i];
                    if ([[dic valueForKey:@"Id"] isEqual:[currentDic valueForKey:@"Id"]]) {
                        [self.savedArray removeObject:dic];
                        [self.savedArray addObject:currentDic];
                    }else{
                        [self.savedArray addObject:currentDic];
                    }
                }
            }
//        }
//            else{
//            for (int i = 0;  i < self.savedArray.count; i++) {
//                NSDictionary *dic = self.savedArray[i];
//                if ([[dic valueForKey:@"Id"] isEqual:[currentDic valueForKey:@"Id"]]) {
//                    [self.savedArray removeObject:dic];
//                    [self.savedArray addObject:currentDic];
//                }else{
//                    [self.savedArray addObject:currentDic];
//                }
//            }
//        }
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (IBAction)datePickAction:(UIButton *)sender {
   [BRDatePickerView showDatePickerWithTitle:@"到货日期" dateType:BRDatePickerModeYMD defaultSelValue:self.createDateLabel.text minDate:nil maxDate:nil isAutoSelect:NO themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
        self.createDateLabel.text = selectValue;
    } cancelBlock:^{
        
    }];
    
}

- (void)saveButtonAction:(UIBarButtonItem *)sender {
    kMyLog(@"%@",self.savedArray);
    if (self.savedArray.count==0 ){
        [self showMessageLabel:@"无数据需要保存" withBackColor:kWarningColor_lightRedColor];
        return;
    }
    NSError *jsonError;
    NSData *otherData = [NSJSONSerialization dataWithJSONObject:@[] options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *otherString = [[[NSString alloc] initWithData:otherData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.savedArray options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *jsonString = [[[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSDictionary *paraDic;
    if (self.marketOrderID.integerValue > 0) {
        //修改
        paraDic = @{
                    @"EmployeeID":kEmployeeID,
                    @"ProjectBranchID":self.projectBranchID,
                    @"OrderDate":self.createDateLabel.text,
                    @"MarketOrderID":self.marketOrderID,
                    @"inserted":otherString,
                    @"updated":jsonString
                    };
    }else{
        paraDic = @{
                    @"EmployeeID":kEmployeeID,
                    @"ProjectBranchID":self.projectBranchID,
                    @"OrderDate":self.createDateLabel.text,
                    @"MarketOrderID":self.marketOrderID,
                    @"inserted":jsonString,
                    @"updated":otherString
                    };
    }
    
    if ((![self.createDateLabel.text isEqualToString: self.deliveryDate])  || self.savedArray.count != 0 ) {
        [self saveRequestWithParaDic:paraDic];
    }else{
        [self showMessageLabel:@"无数据需要保存" withBackColor:kWarningColor_lightRedColor];
    }
    
}

-(void)saveRequestWithParaDic:(NSDictionary *)dic{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kBaseUrl,@"AppSaveMO"];
    [NewNetWorkManager requestPOSTWithURLStr:urlStr parDic: dic finish:^(id responder) {
        [self hideProgressHUD];
        kMyLog(@"%@",responder);
         if ([[responder valueForKey:@"success"] boolValue]== YES) {
            [self.savedArray removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showMessageLabel:[responder valueForKey:@"msg"]withBackColor:kWarningColor_lightRedColor];

        }
    } conError:^(NSError *error) {
        kMyLog(@"error   %@",error);
        [self showMessageLabel:@"数据上传保存出错" withBackColor:kWarningColor_lightRedColor];
        [self hideProgressHUD];
    }];
    
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
