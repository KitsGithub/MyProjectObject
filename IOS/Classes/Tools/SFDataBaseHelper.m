//
//  SFDataBaseHelper.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDataBaseHelper.h"

static SFDataBaseHelper *_instance;

static  NSString *const restorekey_account    = @"SF_ACCOUNT";
static  NSString *const restorekey_authStatus    = @"SF_AUTHSTATUS";

//static  NSString const*restorekey_account    = @"account";
//static  NSString const*restorekey_pwd        = @"pwd";
//static  NSString const*restorekey_token      = @"token";
//static  NSString const*restorekey_mobile     = @"mobile";

@implementation SFDataBaseHelper


+ (instancetype)shared
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance  = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copy
{
    return _instance;
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance  = [super init];
    });
    return _instance;
}


/**
 获取当前用户信息
 */
- (SFAccount *)currentAccount
{
    NSDictionary *accountDic = [[NSUserDefaults standardUserDefaults] objectForKey:restorekey_account];
    if (![accountDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    SFAccount *account = [SFAccount mj_objectWithKeyValues:accountDic];
    return account;
}

/**
 保存用户信息
 */
- (void)saveAccount:(SFAccount *)account
{
    NSDictionary *accountDic = [account mj_keyValues];
    if (![accountDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:accountDic forKey:restorekey_account];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 保存用户认证状态
 */
- (void)saveAuthStatus:(SFAuthStatusModle *)status
{
    NSDictionary *statusDic = [status mj_keyValues];
    if (![statusDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:restorekey_authStatus forKey:restorekey_authStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 获取用户认证状态
 */
- (SFAuthStatusModle *)currentAuthStatus {
    NSDictionary *accountDic = [[NSUserDefaults standardUserDefaults] objectForKey:restorekey_authStatus];
    if (![accountDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    SFAuthStatusModle *account = [SFAuthStatusModle mj_objectWithKeyValues:accountDic];
    return account;
}



- (void)clearAccount {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:restorekey_account];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:restorekey_authStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
