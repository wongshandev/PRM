//
//  FileSelectView.h
//  PRM
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "DXSuperTabViewController.h"
#import "FileModel.h"

@interface FileSelectView : DXSuperTabViewController
@property(nonatomic,strong)NSMutableArray<FileModel *> *dataArray;
@property(copy,nonatomic) void(^selectFileCellBlock)(NSString * fileNameString,NSString *filePath);

@end


