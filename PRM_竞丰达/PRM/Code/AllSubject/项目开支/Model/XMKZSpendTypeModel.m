//
//  XMKZSpendTypeModel.m
//  PRM
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "XMKZSpendTypeModel.h"

@implementation XMKZSpendTypeModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"name":@"Name"
             };
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return  [self modelInitWithCoder:aDecoder];
//    if (self = [super init]) {
//        self.Id = [aDecoder decodeObjectForKey:@"Id"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//     } 
//    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.Id forKey:@"Id"];
 }
@end
