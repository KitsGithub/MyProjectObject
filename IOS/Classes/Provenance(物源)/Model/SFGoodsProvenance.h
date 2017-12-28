//
//  SFGoodsProvenance.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//  我发的货

#import <Foundation/Foundation.h>
#import "SFProvenanceProtocol.h"

@interface SFGoodsProvenance : NSObject<SFProvenanceProtocol>

/**
 车源单id
 */
@property (nonatomic,copy)NSString *guid;

//出发地址信息
@property (nonatomic,copy)NSString *from_province;
@property (nonatomic,copy)NSString *from_city;
@property (nonatomic,copy)NSString *from_district;
@property (nonatomic,copy)NSString *from_address;

//到达地址信息
@property (nonatomic,copy)NSString *to_province;
@property (nonatomic,copy)NSString *to_address;
@property (nonatomic,copy)NSString *to_city;
@property (nonatomic,copy)NSString *to_district;


/**
 订单状态
 */
@property (nonatomic,copy)NSString *order_status;

/**
 发布车辆数
 */
@property (nonatomic,copy)NSNumber *car_count;
/**
 车源创建时间
 */
@property (nonatomic,copy)NSString *created_date;

/**
 待确认数量
 */
@property (nonatomic,copy)NSNumber *usercount;

/**
 用户名
 */
@property (nonatomic,copy) NSString *nick_name;

@property (nonatomic,copy)NSString *taking_status;

@property (nonatomic,assign)SFTakingStatus takingStatus;

- (NSArray *)statusCodeArr;
- (NSArray *)statusDescArr;

@end
