//
//  SFOrder.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrder.h"

@implementation SFOrder

- (NSString *)from {
    return [self toAddr:self.from_province city:self.from_city dis:self.from_district addr:self.from_address];
   
}

- (NSString *)to {
    return [self toAddr:self.to_province city:self.to_city dis:self.to_district addr:self.to_address];
}


- (NSString *)toAddr:(NSString *)pro city:(NSString *)city dis:(NSString *)dis addr:(NSString *)addr{
    if (pro && city) {
        return [NSString stringWithFormat:@"%@-%@-%@",pro,city,dis];
    }else{
        return addr;
    }
}

- (NSString *)cost {
    if (_order_fee.length) {
        return [NSString stringWithFormat:@"%@",_order_fee];
    }
    return @"0";
}

- (NSString *)carownnerName {
    return _cars_owner;
}

- (NSString *)goodownnerName {
    return _goods_owner;
}

- (NSString *)order_no {
    return _order_no;
}

- (NSString *)order_date {
    return _order_date;
}

- (SFOrderType)orderType {
    return orderType_initWithStr(_order_status);
}

- (NSString *)licensePlateNumber {
    return nil;
}


- (NSString *)stateStr {
    SFOrderType status = orderType_initWithStr(self.order_status);
    switch (status) {
        case SFOrderTypeWaiteForSent:
            return @"待发货";
            break;
        case SFOrderTypeWaiteForDelivery:
            return @"待收货";
//        case SFOrderTypeWaiteForPay:
//            return @"待支付";
        case SFOrderTypeWaiteForEvaluate:
            return @"待评价";
        case SFOrderTypeFinish:
            return @"已完成";
        case SFOrderTypeWaiteToSelecterCar:
            return @"待派车";
        default:
            return @"";
            break;
    }
//    return [self statusDescArr][self.takingStatus];
}

- (NSString *)goodsNameOrType {
    return self.goods_name;
}

- (NSString *)goodsWeight {
    return [NSString stringWithFormat:@"%@%@",self.goods_weight,self.weight_unit];
}

- (NSString *)carType {
    return self.car_type;
}

- (NSString *)carLone {
    return _car_long;
}

- (NSString *)guid {
    return _guid;
}

- (NSString *)goods_order {
    return _goods_order;
}


- (SFTakingStatus)takingStatus { 
    return [self orderType];
}

//- (SFOrderType)orderType {
//    NSArray *arr = [self statusCodeArr];
//    for (int i = 0;i < arr.count ;i++) {
//        NSString *code = arr[i];
//        if ([code isEqualToString:self.order_status]) {
//            return i;
//        }
//    }
//    return 0;
//}

- (NSString *)order_id {
    return _guid;
}



- (NSArray *)statusCodeArr {
    return @[@"",@"G",@"A",@"B",@"D",@"F"];
}

- (NSArray *)statusDescArr {
    return @[@"待派车",@"待发货",@"待收货",@"待评价",@"已完成",];
}



@end
