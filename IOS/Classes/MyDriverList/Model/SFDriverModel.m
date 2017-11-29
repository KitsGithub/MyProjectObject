//
//  SFDirverModel.m
//  SFLIS
//
//  Created by kit on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDriverModel.h"

@implementation SFDriverModel

- (NSString *)driver_mobile {
    if (_driver_mobile.length) {
        NSString *str1 = [_driver_mobile substringToIndex:3];
        NSString *str2 = [_driver_mobile substringWithRange:NSMakeRange(3, 4)];
        NSString *str3 = [_driver_mobile substringFromIndex:7];
        
        return [NSString stringWithFormat:@"%@ %@ %@",str1,str2,str3];
    }
    return @"";
}

@end
