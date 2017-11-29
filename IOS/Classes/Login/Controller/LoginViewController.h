//
//  LoginViewController.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/10.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SFAccount.h"

@interface LoginViewController : BaseViewController

// 完成登录注册操作时的回调函数。 成功后返回账户信息；取消或者登陆注册失败，则返回空
@property (nonatomic,copy)void(^completeBlock)(SFAccount *);



@end
