//
//  FileModel.h
//  PRM
//
//  Created by JoinupMac01 on 17/2/24.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "BaseModel.h"

@interface FileModel : BaseModel
@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,copy)NSString *fileName;
@end
