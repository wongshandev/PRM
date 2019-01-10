//
//  SJYRequestTool.h
//  PRM
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SJYRequestTool : NSObject

+(void)loginInfoWithUserName:(NSString *)username passworld:(NSString *)password  complete:(void(^) ( id responder))complete;



@end


