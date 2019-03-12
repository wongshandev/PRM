//
//  FileSelectView.m
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "FileSelectView.h"
#import "FileCell.h"
@interface FileSelectView ()

@end

@implementation FileSelectView

-(void)setUpNavigationBar{
    self.navBar.titleLabel.text = @"文件选择列表";
     //    self.navBar.backButton.hidden = NO;

}
-(void)setupTableView{
    [super setupTableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileCell *cell = [FileCell cellWithTableView:self.tableView];
    FileModel *model = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.data = model;
    [cell loadContent];
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FileModel *model = self.dataArray[indexPath.row];
    self.selectFileCellBlock(model.fileName,model.filePath);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
