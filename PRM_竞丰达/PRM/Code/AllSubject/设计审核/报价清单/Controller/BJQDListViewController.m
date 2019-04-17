//
//  BJQDListViewController.m
//  PRM
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BJQDListViewController.h"
#import "BJQDListCell.h"

@implementation BJQDListViewController
-(void)setUpNavigationBar{
    self.navBar.hidden = YES;
}

-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //    [self.view bringSubviewToFront:self.updateBtn];
}


-(void)bindViewModel{
    Weak_Self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  requestData_SJSH_BJQD];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.refreshBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

#pragma mark -----------------------------进度汇报列表

-(void)requestData_SJSH_BJQD{
    [SJYRequestTool requestSJSHWithAPI:API_SJSH_BJQDList parameters:
     @{
       @"DeepenDesignID":self.sjshListModel.Id
       }   success:^(id responder) {
           [self.dataArray removeAllObjects];
//           if (self.tableView.mj_header.isRefreshing) {
//               [self.dataArray removeAllObjects];
//           }
           NSArray *rowsArr = [responder objectForKey:@"rows"];
           NSArray *footerArr = [responder objectForKey:@"footer"];

           NSMutableArray *rowSectionArr = [NSMutableArray new];
           for (NSDictionary *dic in rowsArr) {
               BJQDListModel *model = [BJQDListModel  modelWithDictionary:dic];
               model.QuotedPriceStr =  [NSString numberMoneyFormattor:model.QuotedPrice];

               model.UnitQuotedPriceStr = model.UnitQuotedPrice.length!= 0?[[NSString numberMoneyFormattor:model. UnitQuotedPrice] stringByAppendingString:@" (中标单价)"]:@"";
               model.QuantityStr = model.Quantity.length!= 0?[[NSString numberIntFormattor:model.Quantity] stringByAppendingFormat:@" (%@)",model.Unit]:@"";
               BJQDListFrame *frame = [[BJQDListFrame alloc]init];
               frame.model = model;
               [rowSectionArr addObject:frame];
           }
           [self.dataArray addObject:rowSectionArr];

           NSMutableArray *footSectionArr = [NSMutableArray new];
           for (NSDictionary *dic in footerArr) {
               BJQDListModel *model = [BJQDListModel  modelWithDictionary:dic];
               model.QuotedPriceStr = [NSString numberMoneyFormattor:model.QuotedPrice];
                 // [model.Name isEqualToString:@"甲供合计"]?@"": [NSString numberMoneyFormattor:model.QuotedPrice];
               [footSectionArr addObject:model];
           }
           [self.dataArray addObject:footSectionArr];

           dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
               [self endRefreshWithError:NO];

               BJQDListModel *model = [footSectionArr objectOrNilAtIndex:5];
               BJQDListModel *yhmodel = [footSectionArr objectOrNilAtIndex:4];
               if (self.myblock && model ) {
                   self.myblock([model.QuotedPriceStr stringByReplacingOccurrencesOfString:@"," withString:@""],[yhmodel.QuotedPriceStr stringByReplacingOccurrencesOfString:@"," withString:@""]);
               }
           });
       } failure:^(int status, NSString *info) {
           [QMUITips showWithText:info inView:self.view hideAfterDelay:1.5];
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
               [self endRefreshWithError:YES];
           });
       }];
}

-(void)endRefreshWithError:(BOOL)havError{
    [self.tableView.mj_header endRefreshing];
    if (self.dataArray.count == 0) {
        self.tableView.customImg = !havError ? [UIImage imageNamed:@"empty"]:SJYCommonImage(@"daoda");
        self.tableView.customMsg = !havError? @"没有数据了,休息下吧":@"网络错误,请检查网络后重试";
        self.tableView.showNoData = YES;
        self.tableView.isShowBtn =  havError;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = Color_Clear;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        BJQDListFrame *frame = self.dataArray[indexPath.section][indexPath.row];
        return frame.cellHeight;
    }
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BJQDListCell *cell = [BJQDListCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
            cell.data = self.dataArray[indexPath.section][indexPath.row];
        [cell loadContent];
        return cell;
    }else{
        BJQDListFootCell *cell = [BJQDListFootCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.data = self.dataArray[indexPath.section][indexPath.row];
        [cell loadContent];
        return cell;
    }
}
 
@end
