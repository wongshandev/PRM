//
//  UserDefaultManager.h
//  WeiLv
//
//  Created by lanouhn on 16/7/12.
//  Copyright © 2016年 Sonjery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultManager : NSObject

+(UserDefaultManager *)shareUserDefaultManager;

#pragma mark -----------是否第一次启动
-(BOOL)getFirstRun;

#pragma mark -----------存取用户名密码
-(void)saveUserName:(NSString *)userName password:(NSString *)password;
-(NSString *)getUserName;
-(NSString *)getPassword;

-(void)saveRemberPassword:(BOOL)isRember;
-(BOOL)isRemberPassword;

#pragma mark -----------存取 ip
-(void)saveIPAddress:(NSString *)ipAddress IPPort:(NSString *)ipPort;
-(NSString *)getIPAddress;
-(NSString *)getIPPort;

#pragma mark -----------存取网络最新版本及信息
-(void)saveNewVersion:(NSString *)newVersion newVersionMessage:(NSString *)message downLoadUrl:(NSString *)trackViewUrl;
-(NSString *)getNewVersion;
-(NSString *)getDownLoadUrl;
-(NSString *)getNewVersionMessage;


#pragma mark -----------存取用户登录获取的信息
-(void)saveEmployeeName:(NSString *)employeeName Dt_Info:(NSString *)dt EmployeeID:(NSString *)employeeID DepartmentID:(NSString *)departmentID PositionID:(NSString *)positionID;
-(NSString *)getEmployeeName;
-(NSString *)getDt_Info;
-(NSString *)getEmployeeID;
-(NSString *)getDepartmentID;
-(NSString *)getPositionID;

 


@end
