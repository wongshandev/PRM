//
//  NSObject+SJYKVO.h
//  KVO封装公开课
//
//  Created by 八点钟学院 on 2017/9/6.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KVOBlock)(void);
@interface NSObject (SJYKVO)

- (void)sjyObserver:(NSObject *)object keyPath:(NSString *)keyPath block:(KVOBlock)block;

@end
