//
//  MultiSelectView.h
//  PRM
//
//  Created by JoinupMac01 on 17/3/2.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiSelectView : UITableViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,copy)NSString *selectedNameString;

@property(nonatomic,copy)void(^mulitSelectBlock)(NSString*);


@end
