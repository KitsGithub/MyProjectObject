//
//  SFDirverModel.h
//  SFLIS
//
//  Created by kit on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAuthStatusModle.h"

@interface SFDriverModel : NSObject

@property (nonatomic, copy) NSString *guid;
/**
 司机名
 */
@property (nonatomic, copy) NSString *driver_by;

/**
 司机手机号
 */
@property (nonatomic, copy) NSString *driver_mobile;

/**
 司机id
 */
@property (nonatomic, copy) NSString *driver_id;


/**
 认证状态
 */
@property (nonatomic, copy) NSString *verify_statuscn;

@property (nonatomic, copy) NSString *verify_status;

@property (nonatomic, strong) SFAuthStatusModle *authStatus;

@end
