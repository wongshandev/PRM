//
//  TableViewController.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/23.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSelectTypeTableView : UITableViewController
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(copy,nonatomic) void(^selectAloneCellBlock)(NSString *stateTypeString);

@end
