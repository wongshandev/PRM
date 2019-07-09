//
//  FileSelectView.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/24.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "FileSelectView.h"

@interface FileSelectView ()

@end

@implementation FileSelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }

    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    self.navigationController.navigationBar.barTintColor = RGBColor(96, 140, 215, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];

//    self.navigationController.navigationItem.titleView.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//    self.navigationController.navigationBar.barTintColor =RGBColor(96, 140, 215, 1);
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)];
//    [self.navigationItem setLeftBarButtonItem:buttonItem];
//
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.title = @"文件选择列表";

}
-(void)frontPageAction:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    // 从缓存队列中取出复用的cell
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果队列中cell为空，即无复用的cell，则对其进行初始化
    if (cell==nil) {
        // 初始化
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        // 定义其辅助样式
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    FileModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.fileName;
//    cell.imageView.image = [UIImage imageWithContentsOfFile:model.filePath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FileModel *model = self.dataArray[indexPath.row];
    self.selectFileCellBlock(model.fileName,model.filePath);
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
