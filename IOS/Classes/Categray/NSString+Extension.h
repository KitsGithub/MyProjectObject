//
//  NSString+Extension.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)md5String;

- (NSString *)sha1String;

- (BOOL)isAvailablePwd;

- (BOOL)isAvailableMobile;

- (BOOL)isAvailableUserName;

- (BOOL)isAvailableCode;
- (BOOL)isAvailableCid;
+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;


@end
