//
//  SFCarrierModel.h
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCarrierModel : NSObject

@property (nonatomic, strong) NSString *carNum;

@property (nonatomic, strong) NSArray *carrierListArray;


/**
 逗号隔开的多个司机  @"driver1, driver2,..."
 */
@property (nonatomic, copy) NSString *driver_by;


/**
 多个司机id
 */
@property (nonatomic, copy) NSString *driver_id;

/**
 逗号隔开的多个司机手机号码 @"13588884444,13522223333,..."
 */
@property (nonatomic, copy) NSString *driver_mobile;

/**
 逗号隔开的多个车牌号码
 */
@property (nonatomic, copy) NSString *car_no;

@property (nonatomic, assign) BOOL is_firstcar;

@property (nonatomic, strong) NSArray *driverNameArray;

@end
