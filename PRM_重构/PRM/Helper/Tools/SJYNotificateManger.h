//
//  SJYNotificateManger.h
//  PRM
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SJYNotificateManger : NSObject

+(instancetype)shareManager;
- (void)addLocalNotice;
- (void)removeAllNotification;
- (void)removeOneNotificationWithID:(NSString *)noticeId;
@end


