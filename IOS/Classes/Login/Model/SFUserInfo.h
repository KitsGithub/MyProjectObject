//
//  SFUserInfo.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAuthStatusModle.h"

@interface SFUserInfo : NSObject

/**
 用户id
 */
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *token;
/**
 用户账号
 */
@property (nonatomic, copy) NSString *account;

/**
 用户名
 */
@property (nonatomic, copy) NSString *name;

/**
 手机号码
 */
@property (nonatomic, copy) NSString *mobile;

/**
 用户状态
 */
@property (nonatomic, copy) NSString *status;

/**
 认证状态
 */
@property (nonatomic, copy) NSString *verify_status;

/**
 注册时间
 */
@property (nonatomic, copy) NSString *reg_date;

/**
 用户角色 Car/ Goods
 */
@property (nonatomic, copy) NSString *role_type;
@property (nonatomic,assign) SFUserRole role;

/**
 性别
 */
@property (nonatomic, copy) NSString *sex;

/**
 大头像
 */
@property (nonatomic, copy) NSString *big_head_src;

/**
 小头像
 */
@property (nonatomic, copy) NSString *small_head_src;


/**
 用户认证信息
 */
@property (nonatomic,strong) SFAuthStatusModle *authStatus;
/**
 获取单例用户数据
 */
+ (instancetype)defaultInfo;

/**
 保存用户信息
 */
- (void)saveUserInfo;
- (void)clearUserInfo;

@end
