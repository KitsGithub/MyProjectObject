//
//  SFReceiveGoods.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/7.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFReceiveGoods.h"

@implementation SFReceiveGoods

- (NSString *)guid {
    return _guid;
}

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
    if (_price.length) {
        return [NSString stringWithFormat:@"%@",_price];
    }
    return @"0";
}

- (NSString *)carownnerName
{
    return _orderuser;
}
- (NSString *)goodownnerName {
    return _orderuser;
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
    return self.goods_type ? self.goods_type : self.goods_name;
}

- (NSString *)goodsWeight
{
    return [NSString stringWithFormat:@"%@%@",self.goods_weight,self.weight_unit];
}

- (NSString *)carType
{
    return self.car_type;
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


- (NSArray *)statusCodeArr
{
    return @[@"B",@"A",@"D",@"T"];
}

- (NSArray *)statusDescArr
{
    return @[@"待确认",@"已受理",@"已回绝",@"已撤回"];
}


@end
