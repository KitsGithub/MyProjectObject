//
//  LoginRequest.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SFLoginresultBlock)(SFUserInfo *account);
typedef void(^SFCodeImageResult)(NSString *imgUrl);
@interface LoginRequest : NSObject


+ (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd succuss:(SFLoginresultBlock)succuss fault:(SFErrorResultBlock)fault;

+ (void)registWithAccount:(NSString *)account pwd:(NSString *)pwd mobile:(NSString *)mobile role:(SFUserRole)role code:(NSString *)code succuss:(SFLoginresultBlock)succuss fault:(SFErrorResultBlock)fault;

+ (void)logOutWithSuccuss:(SFEmptyResultBlock)succuss fault:(SFErrorResultBlock)fault;

+ (void)checkUserName:(NSString *)userName Succuss:(SFBoolResultBlock)succuss fault:(SFErrorResultBlock)fault;


@end
