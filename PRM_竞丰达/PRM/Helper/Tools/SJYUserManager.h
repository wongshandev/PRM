//
//  SJYUserManager.h
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJYUserManager : NSObject<NSCoding>
+(instancetype)sharedInstance;
+ (YYCache *)sharedYYCache;

//用户信息model（更新）
//@property (nonatomic,strong) SJYLoginInfo * userInfo;
//登录返回信息（不更新）

@property (nonatomic,strong) LoginModel *loginModel;
-(void)updateLoginModel;

@property (nonatomic,strong) SJYLoginInfo *sjyloginData;
-(void)updateLoginData;
-(void)clearLoginData;

@end

NS_ASSUME_NONNULL_END
