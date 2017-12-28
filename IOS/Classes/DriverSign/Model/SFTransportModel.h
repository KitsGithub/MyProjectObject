//
//  SFTransportModel.h
//  SFLIS
//
//  Created by kit on 2017/12/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFTransportModel : NSObject

@property (nonatomic, copy) NSString *order_id;

/**
 出发地址信息
 */
@property (nonatomic, copy) NSString *from_province;
@property (nonatomic, copy) NSString *from_city;
@property (nonatomic, copy) NSString *from_district;
@property (nonatomic, copy) NSString *from_address;


/**
 到达地址信息
 */
@property (nonatomic, copy) NSString *to_province;
@property (nonatomic, copy) NSString *to_city;
@property (nonatomic, copy) NSString *to_district;
@property (nonatomic, copy) NSString *to_address;

/**
 到达时间
 */
@property (nonatomic, copy) NSString *deliver_date;

/**
 车牌号
 */
@property (nonatomic, copy) NSString *car_no;

/**
 司机
 */
@property (nonatomic, copy) NSString *driver_by;

/**
 运输状态
 */
@property (nonatomic, copy) NSString *trans_status;

@end
