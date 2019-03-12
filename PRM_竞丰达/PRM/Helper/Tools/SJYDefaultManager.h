//
//  SJYUserManager.h
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJYDefaultManager : NSObject

+(instancetype)shareManager;



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

#pragma mark -----------存取项目开支状态信息
-(void)saveXMKZSpendTypeArray:(NSArray *)array;
-(NSArray *)getXMKZSpendTypeArray;
 

@end

NS_ASSUME_NONNULL_END
