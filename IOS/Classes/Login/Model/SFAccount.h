//
//  SFUserInfo.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFAuthStatusModle;

@interface SFAccount : NSObject
{
    SFUserRole _role;
}
@property (nonatomic,assign)SFUserRole role;

@property (nonatomic,strong)NSString *guid;

@property (nonatomic,strong)NSString *user_id;

@property (nonatomic,strong)NSString *account;

@property (nonatomic,strong)NSString *mobile;

@property (nonatomic,strong)NSString *password;

@property (nonatomic,strong)NSString *token;



@property (nonatomic,strong)NSString *role_type;

@property (nonatomic,strong)NSString *name;


/**
 保密/男/女
 */
@property (nonatomic,strong)NSString *sex;

@property (nonatomic,strong)NSString *head_src;

@property (nonatomic,strong)NSString *reg_date;

@property (nonatomic,strong)NSString *updated_date;

@property (nonatomic,strong) SFAuthStatusModle *authStatus;

/**
 用户验证状态
 A 普通用户
 B 用户状态 审核中
 D 认证成功
 F 认证失败
 */
@property (nonatomic,strong)NSString *status;

@property (nonatomic,strong)NSString *verify_status;


@property (nonatomic,strong)NSString *code; // 验证码

+ (NSString *)roleTypeWithRole:(SFUserRole)role;

+ (instancetype)currentAccount;
@end
