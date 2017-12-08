//
//  SFCarrierModel.m
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarrierModel.h"

@implementation SFCarrierModel


- (NSString *)carNum {
    if (_car_no.length) {
        return _car_no;
    }
    return @"";
}

- (NSString *)car_id {
    return @"";
}

- (NSArray<NSString *> *)driverNameArray {
    if (_driver_by.length) {
        NSArray *driverList = [_driver_by componentsSeparatedByString:@","];
        if (driverList.count) {
            return driverList;
        }
    }
    return @[];
}


@end
