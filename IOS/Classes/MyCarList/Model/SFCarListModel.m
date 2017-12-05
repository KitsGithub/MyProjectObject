//
//  SFCarListModel.m
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarListModel.h"

@implementation SFCarListModel

- (NSString *)car_no {
    if (_car_no.length) {
//        NSString *str1 = [_car_no substringToIndex:2];
//        NSString *str2 = [_car_no substringWithRange:NSMakeRange(2, _car_no.length - 2)];
//
//        return [NSString stringWithFormat:@"%@%@",str1,str2];
        return _car_no;
    }
    return @"";
}

- (NSString *)dead_weight {
    if (_dead_weight.length) {
        return [NSString stringWithFormat:@" %@吨",_dead_weight];
    }
    return @" 0吨";
}

- (NSString *)car_size {
    if (_car_size.length) {
        return [NSString stringWithFormat:@" %@方",_car_size];
    }
    return @" 0方";
}

- (NSString *)price {
    if (_price.length) {
        return _price;
    }
    return @"";
}

/**
 车牌号码
 */
- (NSString *)carNum {
    return _car_no;
}

- (NSString *)car_id {
    return _car_id;
}

- (void)setCarNum:(NSString *)carNum {
    _car_no = carNum;
}

- (NSArray <NSString *>*)driverNameArray {
    return @[];
}


@end
