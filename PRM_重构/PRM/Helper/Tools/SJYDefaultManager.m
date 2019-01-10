//
//  SJYUserManager.m
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "SJYDefaultManager.h"

static SJYDefaultManager *sharedUser;
@implementation SJYDefaultManager
 +(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[[self class] alloc ]init];
    });
     return sharedUser;
}

#pragma mark -----------存取用户名密码
//存储用户名,密码
-(void)saveUserName:(NSString *)userName password:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//取用户名,密码
-(NSString *)getUserName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}
-(NSString *)getPassword{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}
-(void)saveRemberPassword:(BOOL)isRember{
    [[NSUserDefaults standardUserDefaults] setBool:isRember forKey:@"rememberPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isRemberPassword{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"];
}

#pragma mark -----------存取 ip
//存储IP 地址及端口
-(void)saveIPAddress:(NSString *)ipAddress IPPort:(NSString *)ipPort {
    [[NSUserDefaults  standardUserDefaults] setValue:ipAddress forKey:@"IPAddress"];
    [[NSUserDefaults standardUserDefaults]setValue:ipPort forKey:@"IPPort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)getIPAddress{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"IPAddress"];
}
-(NSString *)getIPPort{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"IPPort"];
}
#pragma mark -----------存取网络最新版本及信息

-(void)saveNewVersion:(NSString *)newVersion newVersionMessage:(NSString *)message downLoadUrl:(NSString *)trackViewUrl{
    [[NSUserDefaults  standardUserDefaults] setValue:newVersion forKey:@"newVersion"];
    [[NSUserDefaults standardUserDefaults]setValue:trackViewUrl forKey:@"trackViewUrl"];
    [[NSUserDefaults standardUserDefaults]setValue:message forKey:@"newVersionMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)getNewVersion{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"newVersion"];
}
-(NSString *)getDownLoadUrl{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"trackViewUrl"];
}
-(NSString *)getNewVersionMessage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"newVersionMessage"];
}

#pragma mark -----------存取用户登录获取的信息

-(void)saveEmployeeName:(NSString *)employeeName Dt_Info:(NSString *)dt EmployeeID:(NSString *)employeeID DepartmentID:(NSString *)departmentID PositionID:(NSString *)positionID{
    [[NSUserDefaults  standardUserDefaults] setValue:employeeName forKey:@"employeeName"];
    [[NSUserDefaults standardUserDefaults]setValue:dt forKey:@"dt"];
    [[NSUserDefaults  standardUserDefaults] setValue:employeeID forKey:@"employeeID"];
    [[NSUserDefaults standardUserDefaults]setValue:departmentID forKey:@"departmentID"];
    [[NSUserDefaults  standardUserDefaults] setValue:positionID forKey:@"positionID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getEmployeeName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"employeeName"];
}
-(NSString *)getDt_Info{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"dt"];
}
-(NSString *)getEmployeeID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"employeeID"];
}
-(NSString *)getDepartmentID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"departmentID"];
}
-(NSString *)getPositionID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"positionID"];
}


//程序第一次启动
-(BOOL)getFirstRun{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];
    if (isFirst) {
        return NO;
    }else
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}







@end
