//
//  MainModel.m
//  PRM
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"Id":@"id",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"children" : [MainModel class]};
}


@end
