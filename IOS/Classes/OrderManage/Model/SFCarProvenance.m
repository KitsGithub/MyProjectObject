//
//  SFProvenance.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/31.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarProvenance.h"

@implementation SFCarProvenance

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
- (NSString *)goodownnerName {
    return self.name;
}

- (NSString *)licensePlateNumber
{
    return nil;
}

- (NSString *)stateStr
{
    return [self statusDescArr][self.takingStatus];
}


- (NSString *)goodsNameOrType
{
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
    return @[@"B",@"A",@"C"];
}

- (NSArray *)statusDescArr
{
    return @[@"待发布",@"已发布",@"已接单"];
}



@end
