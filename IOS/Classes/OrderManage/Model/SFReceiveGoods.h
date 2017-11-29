//
//  SFReceiveGoods.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/7.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//  我接的货

#import <Foundation/Foundation.h>
#import "SfOrderProtocol.h"


@interface SFReceiveGoods : NSObject<SfOrderProtocol>


//地址信息
@property (nonatomic,copy)NSString *from_address;
@property (nonatomic,copy)NSString *to_address;
@property (nonatomic,copy)NSString *from_city;
@property (nonatomic,copy)NSString *from_district;
@property (nonatomic,copy)NSString *to_province;
@property (nonatomic,copy)NSString *to_city;
@property (nonatomic,copy)NSString *to_district;
//信息
@property (nonatomic,copy)NSString *orderuser;
@property (nonatomic,copy)NSString *weight_unit;
@property (nonatomic,copy)NSNumber *goods_weight;

@property (nonatomic,copy)NSString *car_long;
@property (nonatomic,copy)NSNumber *car_count;
@property (nonatomic,copy)NSString *issue_date;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *order_user;
@property (nonatomic,copy)NSString *issue_by;
@property (nonatomic,copy)NSString *car_remark;
@property (nonatomic,copy)NSString *car_type;

@property (nonatomic,copy)NSString *price;


@property (nonatomic,copy)NSString *delivery_mobile;

@property (nonatomic,copy)NSString *attention_remark;
@property (nonatomic,copy)NSString *shipment_date;
@property (nonatomic,copy)NSString *goods_type;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *order_no;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *from_province;;
@property (nonatomic,copy)NSString *delivery_date;

@property (nonatomic,copy)NSNumber *goods_size;
@property (nonatomic,copy)NSNumber *usercount;
@property (nonatomic,copy)NSString *delivery_by;
@property (nonatomic,copy)NSString *guid;

@property (nonatomic,copy)NSString *order_fee;

@property (nonatomic,copy)NSString *taking_status;

- (NSArray *)statusCodeArr;
- (NSArray *)statusDescArr;

@end
