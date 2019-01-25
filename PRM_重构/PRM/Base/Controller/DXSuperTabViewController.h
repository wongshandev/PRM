//
//  DXSuperTabViewController.h
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperViewController.h"


@interface DXSuperTabViewController : DXSuperViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

-(void)setupTableView;



@end


