//
//  CarsSupply.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "CarsSupply.h"

@implementation CarsSupply


- (NSString *)weight_unit
{
    return @"吨";
}



- (NSString *)name
{
    return self.nick_name;
}

- (NSString *)issueCount
{
    return [NSString stringWithFormat:@"%@",self.ordercount];
}


@end


