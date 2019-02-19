//
//  SJYUserManager.m
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYUserManager.h"

static SJYUserManager *shareduser;
static YYCache *cache;

@implementation SJYUserManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareduser = [[self alloc]init];
    });
    return shareduser;
}
+ (YYCache *)sharedYYCache{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cache = [[YYCache alloc] initWithName:SJYCACHEKEY];
    });
    return cache;
}


-(LoginModel *)loginModel{
    if (_loginModel == nil) {
        YYCache *cache = [SJYUserManager sharedYYCache];
        _loginModel = (LoginModel *)[cache objectForKey:LOGINMODELKEY];
    }
    return _loginModel;
}
-(void)updateLoginModel{
    YYCache *cache = [SJYUserManager sharedYYCache];
    [cache setObject:[SJYUserManager sharedInstance].loginModel forKey:LOGINMODELKEY];
}

- (SJYLoginInfo *)sjyloginData{
    if(_sjyloginData == nil) {
        YYCache *cache = [SJYUserManager sharedYYCache];
        _sjyloginData = (SJYLoginInfo *)[cache objectForKey:LOGINDATAKEY];
    }
    return _sjyloginData;
}


-(void)updateLoginData{
    YYCache *cache = [SJYUserManager sharedYYCache];
    [cache setObject:[SJYUserManager sharedInstance].sjyloginData forKey:LOGINDATAKEY];
}

- (void)clearLoginData{
    YYCache *cache = [SJYUserManager sharedYYCache];
    if ([cache containsObjectForKey:LOGINDATAKEY]) {
        [cache removeObjectForKey:LOGINDATAKEY];
    }
    [SJYUserManager sharedInstance].sjyloginData = nil;
    //清除 本地存储
 }

//userInfo
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.loginModel forKey:@"loginModel"];
    [aCoder encodeObject:self.sjyloginData forKey:@"sjyloginData"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.loginModel = [aDecoder decodeObjectForKey:@"loginModel"];
    self.sjyloginData = [aDecoder decodeObjectForKey:@"sjyloginData"];
    return self;
}
@end
