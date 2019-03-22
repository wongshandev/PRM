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

#pragma mark ------------------------------------LoginModel---------------------

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


#pragma mark ------------------------------------SJYLoginInfo---------------------
- (SJYLoginInfo *)sjyloginUC{
    if(_sjyloginUC == nil) {
        YYCache *cache = [SJYUserManager sharedYYCache];
        _sjyloginUC = (SJYLoginInfo *)[cache objectForKey:LOGINUCMODELKEY];
    }
    return _sjyloginUC;
}
-(void)updateLoginUC{
    YYCache *cache = [SJYUserManager sharedYYCache];
    [cache setObject:[SJYUserManager sharedInstance].sjyloginUC forKey:LOGINUCMODELKEY];
}
- (void)clearLoginUC{
    YYCache *cache = [SJYUserManager sharedYYCache];
    if ([cache containsObjectForKey:LOGINUCMODELKEY]) {
        [cache removeObjectForKey:LOGINUCMODELKEY];
    }
    [SJYUserManager sharedInstance].sjyloginUC = nil;
    //清除 本地存储
 }

#pragma mark ------------------------------------ucAemp---------------------
-(NSDictionary *)ucAemp{
    if (!_ucAemp) {
        YYCache *cache = [SJYUserManager sharedYYCache];
        _ucAemp = (NSDictionary *)[cache objectForKey:LOGINUCKEY];
    }
    return _ucAemp;
}
-(void)updateUcAemp{
    YYCache *cache = [SJYUserManager sharedYYCache];
    [cache setObject:[SJYUserManager sharedInstance].ucAemp forKey:LOGINUCKEY];
}
-(void)clearUcAemp{
    YYCache *cache = [SJYUserManager sharedYYCache];
    if ([cache containsObjectForKey:LOGINUCKEY]) {
        [cache removeObjectForKey:LOGINUCKEY];
    }
    [SJYUserManager sharedInstance].ucAemp = nil;
    //清除 本地存储
}
 
//userInfo
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
//    [aCoder encodeObject:self.loginModel forKey:@"loginModel"];
//    [aCoder encodeObject:self.sjyloginUC forKey:@"sjyloginUC"];
//    [aCoder encodeObject:self.ucAemp forKey:@"ucAemp"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self.loginModel = [aDecoder decodeObjectForKey:@"loginModel"];
//    self.sjyloginUC = [aDecoder decodeObjectForKey:@"sjyloginUC"];
//    self.ucAemp = [aDecoder decodeObjectForKey:@"ucAemp"];
//    return self;
    self = [super init];
    return  [self modelInitWithCoder:aDecoder];
}
@end
