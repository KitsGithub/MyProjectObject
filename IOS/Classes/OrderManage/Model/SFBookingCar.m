//
//  SFBookingCar.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/7.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingCar.h"

@implementation SFBookingCar

- (NSString *)from
{
    return [self toAddr:self.from_province city:self.from_city dis:self.from_district addr:self.from_address];
    
}

- (NSString *)to
{
    return [self toAddr:self.to_province city:self.to_city dis:self.to_district addr:self.to_address];
}


- (NSString *)toAddr:(NSString *)pro city:(NSString *)city dis:(NSString *)dis addr:(NSString *)addr{
    if (pro && city) {
        return [NSString stringWithFormat:@"%@-%@-%@",pro,city,dis];
    }else{
        return addr;
    }
}

- (NSString *)cost
{
    return self.price;
}

- (NSString *)carownnerName
{
    return self.name;
}

- (NSString *)licensePlateNumber
{
    return nil;
}

- (NSString *)stateStr
{
    NSInteger index = [self takingStatus];
    if (index < 0 || index > [self statusDescArr].count) {
        return @"未知状态";
    }
    return [self statusDescArr][index];
}

- (NSString *)goodsNameOrType
{
    return nil;
}
- (NSString *)goodownnerName {
    return nil;
}

- (NSString *)goodsWeight
{
    return nil;
}

- (NSString *)carType
{
    return _car_type;
}

- (NSString *)carLone
{
    return _car_long;
}

- (SFOrderType)orderType
{
    return  orderType_initWithStr(self.order_status);
}

- (SFTakingStatus)takingStatus { 
    NSArray *arr = [self statusCodeArr];
    for (int i = 0;i < arr.count ;i++) {
        NSString *code = arr[i];
        if ([code isEqualToString:self.taking_status ? self.taking_status : self.order_status]) {
            return i;
        }
    }
    return 0;
}

- (NSString *)goods_order {
    return _guid;
}


- (NSString *)guid {
    return _guid;
}


- (NSArray *)statusCodeArr
{
    return @[@"B",@"A",@"D",@"T"];
}

- (NSArray *)statusDescArr
{
    return @[@"待确认",@"已受理",@"已回绝",@"已撤回"];
}



@end
