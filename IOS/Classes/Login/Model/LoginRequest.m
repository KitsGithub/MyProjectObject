//
//  LoginRequest.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest


+ (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd succuss:(SFLoginresultBlock)succuss fault:(SFErrorResultBlock)fault
{
    if (!account || !pwd) {
        SFNetworkError *err = [[SFNetworkError alloc] initWithDomain:@"参数不完整" code:505 userInfo:nil];
        fault(err);
        return;
    }
    if (pwd.length  < 16) {
        pwd  = [pwd md5String];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"account"] = account;
    param[@"password"] = pwd;
    
    [[SFNetworkManage shared] postWithPath:@"account/Login" params:param success:^(NSDictionary *result) {
        SFUserInfo *account = [SFUserInfo mj_objectWithKeyValues:result];
        succuss(account);
    } fault:fault];
}

+ (void)registWithAccount:(NSString *)account pwd:(NSString *)pwd mobile:(NSString *)mobile role:(SFUserRole)role succuss:(SFLoginresultBlock)succuss fault:(SFErrorResultBlock)fault
{
    if (!account || !pwd || mobile == nil || role == SFUserRoleUnknown) {
        SFNetworkError *err = [[SFNetworkError alloc] initWithDomain:@"参数不完整" code:505 userInfo:nil];
        fault(err);
        return;
    }
    if (pwd.length  < 16) {
        pwd  = [pwd md5String];
    }
    NSDictionary *param = @{
                            @"account":account,
                            @"password":pwd,
                            @"mobile":mobile,
                            @"role_type":SF_USER.role_type
                            };
    [[SFNetworkManage shared] postWithPath:@"account/Reg" params:param success:^(NSDictionary *result) {
        SFUserInfo *account = [SFUserInfo mj_objectWithKeyValues:result];
        succuss(account);
    } fault:fault];
    
}

+ (void)checkUserName:(NSString *)userName Succuss:(SFBoolResultBlock)succuss fault:(SFErrorResultBlock)fault
{
    if (!userName) {
        SFNetworkError *err = [[SFNetworkError alloc] initWithDomain:@"参数不完整" code:505 userInfo:nil];
        fault(err);
        return;
    }
    NSDictionary *param = @{
                            @"account":userName
                            };
    [[SFNetworkManage shared] postWithPath:@"account/CheckExistAccount" params:param success:^(NSDictionary *result) {
        succuss(YES);
    } fault:fault];
    
    
}

+ (void)logOutWithSuccuss:(SFEmptyResultBlock)succuss fault:(SFErrorResultBlock)fault
{
    succuss();
}


@end
