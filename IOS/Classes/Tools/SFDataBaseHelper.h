//
//  SFDataBaseHelper.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAccount.h"
#import "SFUserInfo.h"
#import "SFAuthStatusModle.h"

@interface SFDataBaseHelper : NSObject


+ (instancetype)shared;

- (SFAccount *)currentAccount;
- (void)saveAccount:(SFAccount *)account;


- (SFAuthStatusModle *)currentAuthStatus;
- (void)saveAuthStatus:(SFAuthStatusModle *)status;

- (void)clearAccount;

@end
