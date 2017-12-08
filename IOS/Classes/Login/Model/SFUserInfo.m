//
//  SFUserInfo.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFUserInfo.h"

@implementation SFUserInfo

MJExtensionCodingImplementation


- (SFUserRole)role
{
    if ([self.role_type isEqualToString:@"Goods"]) {
        _role  = SFUserRoleGoodsownner;
    }
    
    if ([self.role_type isEqualToString:@"Car"]) {
        _role  = SFUserRoleCarownner;
    }
    return _role;
}

- (NSString *)sex {
    if (_sex.length) {
        return _sex;
    }
    return @"保密";
}

- (NSString *)big_head_src {
    if (_big_head_src.length) {
        return _big_head_src;
    }
    return @"";
}

- (NSString *)small_head_src {
    if (_small_head_src.length) {
        return _small_head_src;
    }
    return @"";
}

static SFUserInfo *defaultInfo;
static dispatch_once_t onceToken;
+ (instancetype)defaultInfo {
    dispatch_once(&onceToken, ^{
        defaultInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:USERINFO_PATH];
    });
    return defaultInfo;
}

- (void)saveUserInfo {
    [SFUserInfo mj_setupIgnoredCodingPropertyNames:^NSArray *{
        return @[@"role",@"authStatus"];
    }];
    [NSKeyedArchiver archiveRootObject:self toFile:USERINFO_PATH];
    defaultInfo = self;
}

- (void)clearUserInfo {
    defaultInfo = nil;
    onceToken = 0;
    [NSKeyedArchiver archiveRootObject:[SFUserInfo new] toFile:USERINFO_PATH];
}
@end
