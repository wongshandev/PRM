//
//  AppDelegate+NotificationService.m
//  PRM
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "AppDelegate+NotificationService.h"
#import <UserNotifications/UserNotifications.h>
@implementation AppDelegate (NotificationService)
//创建本地通知
- (void)requestNotificationAuthor { 
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {

        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }  
}

@end
