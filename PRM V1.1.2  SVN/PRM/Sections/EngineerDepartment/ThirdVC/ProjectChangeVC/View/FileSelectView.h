//
//  FileSelectView.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/24.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
@interface FileSelectView : UITableViewController
@property(nonatomic,strong)NSMutableArray<FileModel *> *dataArray;
@property(copy,nonatomic) void(^selectFileCellBlock)(NSString * fileNameString,NSString *filePath);


@end
