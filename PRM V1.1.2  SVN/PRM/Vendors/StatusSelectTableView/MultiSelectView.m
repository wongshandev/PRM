//
//  MultiSelectView.m
//  PRM
//
//  Created by JoinupMac01 on 17/3/2.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "MultiSelectView.h"
#import "MultiSelectCell.h"
@interface MultiSelectView ()
@end

@implementation MultiSelectView
-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        self.selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    if (self.selectedNameString.length!= 0) {
        NSArray *selectArr = [self.selectedNameString componentsSeparatedByString:@","];
        if (selectArr.count!= 0) {
            [self.selectedArray addObjectsFromArray:selectArr];
        }
    }

    self.tableView.editing = YES;
    [self.tableView registerClass:[MultiSelectCell class] forCellReuseIdentifier:@"reuseIdentifierCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationItems];
}
-(void)setNavigationItems{
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    self.navigationController.navigationBar.barTintColor = RGBColor(96, 140, 215, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frontPage"] style:UIBarButtonItemStylePlain target:self action:@selector(frontPageAction:)] ;
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction:)] ;
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)confirmAction:(UIBarButtonItem *)sender {
    NSMutableString *titleStr = [NSMutableString stringWithFormat:@"%@", [self.selectedArray componentsJoinedByString:@","]];
    self.mulitSelectBlock( titleStr);
    //    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)frontPageAction:(UIBarButtonItem *)sender {
    //    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *obj = self.dataArray[indexPath.row];
    if ([self.selectedArray containsObject:obj] ) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifierCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
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



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }



 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedArray containsObject:[self.dataArray objectAtIndex:indexPath.row]]) {
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        return;
    }
    NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    for (id subCell in subviews) {
        if ([subCell isKindOfClass:[UIControl class]]) {
            for (UIImageView *circleImage in [subCell subviews]) {
                circleImage.image = [UIImage imageNamed:@"CellButtonSelected"];
            }
        }
    }
    [self.selectedArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    for (id subCell in subviews) {
        if ([subCell isKindOfClass:[UIControl class]]) {
            for (UIImageView *circleImage in [subCell subviews]) {
                circleImage.image = [UIImage imageNamed:@"CellButton"];
            }
        }
    }
    [self.selectedArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
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
