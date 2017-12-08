//
//  SFCarOrderDetailModel.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarOrderDetailModel.h"

@implementation SFCarOrderDetailModel

//+ (void)mj_setupObjectClassInArray:(MJObjectClassInArray)objectClassInArray {
//    objectClassInArray = ^NSDictionary *{
//
//    };
//}

+ (void)initialize {
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"car_info" : @"SFCarListModel"};
    }];
}

- (NSString *)from_address {
    if (_from_address.length) {
        return _from_address;
    }
    return @"未填写详细地址";
}

- (NSString *)to_address {
    if (!_to_address) {
        return _to_address;
    }
    return @"未填写详细地址";
}

- (NSString *)mobile {
    if (_mobile.length) {
        return _mobile;
    }
    return @"未填写手机号码";
}

- (NSString *)connect_mobile {
    if (_connect_mobile.length) {
        return _connect_mobile;
    }
    return @"未填写手机号码";
}

@end
