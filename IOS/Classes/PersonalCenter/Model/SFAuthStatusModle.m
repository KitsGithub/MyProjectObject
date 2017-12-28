//
//  SFAuthStatusModle.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthStatusModle.h"

@implementation SFAuthStatusModle

- (NSString *)car_weight {
    if (_car_weight.length) {
        return _car_weight;
    }
    return @"";
}

- (NSString *)car_size {
    if (_car_size.length) {
        return _car_size;
    }
    return @"";
}

- (NSString *)shopPhotoUrl
{
    NSString *url  = [self getPicUrlWithKey:@"ShopPhoto" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)lifePhotoUrl
{
    NSString *url  = [self getPicUrlWithKey:@"LifePhoto" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)idCardBackUrl
{
    NSString *url  = [self getPicUrlWithKey:@"IdCardBack" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)businessLicenseUrl
{
    NSString *url  = [self getPicUrlWithKey:@"BusinessLicense" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)idCardUrl
{
    NSString *url  = [self getPicUrlWithKey:@"IdCard" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)driverUrl {
    NSString *url  = [self getPicUrlWithKey:@"DriverCard" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)driverBUrl {
    NSString *url  = [self getPicUrlWithKey:@"DriverCardBack" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)DrivingCard {
    NSString *url  = [self getPicUrlWithKey:@"DrivingCard" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)DrivingCardBack {
    NSString *url  = [self getPicUrlWithKey:@"DrivingCardBack" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)CarAPhoto {
    NSString *url  = [self getPicUrlWithKey:@"CarAPhoto" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)CarBPhoto {
    NSString *url  = [self getPicUrlWithKey:@"CarBPhoto" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)CarCPhoto {
    NSString *url  = [self getPicUrlWithKey:@"CarCPhoto" fromArr:self.verify_pic];
    if (url) {
        return [NSString stringWithFormat:@"%@%@",Resource_URL,url];
    }
    return nil;
}

- (NSString *)getPicUrlWithKey:(NSString *)key fromArr:(NSArray *)arr
{
    for (NSDictionary *dic in  arr) {
        if ([[dic objectForKey:@"picture_type"] isEqualToString:key]) {
            return  dic[@"picture_src"];
        }
    }
    return nil;
    
}

- (SFAuthStatus)status
{
    return SFAuthStatusCreate(self.verify_status);
}

- (NSString *)statusDesc
{
    return SFAuthStatusGetDesc(self.status);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}



@end
