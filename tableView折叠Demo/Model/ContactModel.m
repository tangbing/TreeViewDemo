
//
//  ContactModel.m
//  Epipe
//
//  Created by Tb on 2018/6/21.
//  Copyright © 2018年 Epipe-iOS. All rights reserved.
//

#import "ContactModel.h"
#import "NSObject+YYModel.h"

@implementation ContactModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID": @[@"id"]};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"offices":@"Offices"};
}

@end

@implementation Offices
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"departID": @[@"id"]};
}
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"staff":@"Staffs"};
}
@end


@implementation Staffs

@end

