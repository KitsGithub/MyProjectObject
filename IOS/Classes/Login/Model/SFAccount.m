//
//  SFUserInfo.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAccount.h"
#import "SFDataBaseHelper.h"
#import "SFAuthStatusModle.h"

@implementation SFAccount

- (void)setRole:(SFUserRole)role
{
    _role  = role;
    [SFAccount roleTypeWithRole:role];
}

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

- (NSString *)guid {
    if (_guid.length) {
        return _guid;
    }
    return @"";
}

+ (NSString *)roleTypeWithRole:(SFUserRole)role
{
    switch (role) {
        case SFUserRoleCarownner:
            return  @"Car";
            break;
        case SFUserRoleGoodsownner:
           return  @"Goods";
        default:
            break;
    }
    return nil;
}

- (NSString *)sex {
    if (_sex.length) {
        return _sex;
    }
    return @"保密";
}

- (NSString *)head_src {
    if (_head_src.length) {
        return _head_src;
    }
    return @"";
}

- (void)setAuthStatus:(SFAuthStatusModle *)authStatus {
    [[SFDataBaseHelper shared] saveAuthStatus:authStatus];
}

- (SFAuthStatusModle *)authStatus {
    return [[SFDataBaseHelper shared] currentAuthStatus];
}


+ (instancetype)currentAccount
{
    return [[SFDataBaseHelper shared] currentAccount];
}

@end
