//
//  SFOrder.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SfOrderProtocol.h"

@interface SFOrder : NSObject<SfOrderProtocol>


//"guid": "0b192294-bf9d-11e7-8e38-005056b66c79",（订单id）
//"order_no": "20171102000005",（单据编号）
//"goods_owner": "linje",（货主）
//"cars_owner": "广东广运运输有限公司",（车主）
//"order_date": "2017-11-02T15:12:05",（下单时间）
//"order_status": "A"（订单状态）
@property (nonatomic,copy)NSString *cars_owner;
@property (nonatomic,copy)NSString *goods_owner;
@property (nonatomic,copy)NSString *to_district;
@property (nonatomic,copy)NSString *car_long;
@property (nonatomic,copy)NSString *goods_weight;
@property (nonatomic,copy)NSString *issue_date;
@property (nonatomic,copy)NSString *car_count;
@property (nonatomic,copy)NSString *delivery_mobile;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *order_user;
@property (nonatomic,copy)NSString *to_city;
@property (nonatomic,copy)NSString *from_address;
@property (nonatomic,copy)NSString *attention_remark;
@property (nonatomic,copy)NSString *from_district;
@property (nonatomic,copy)NSString *shipment_date;
@property (nonatomic,copy)NSString *from_city;
@property (nonatomic,copy)NSString *goods_type;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *weight_unit;

@property (nonatomic,copy)NSString *to_province;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *order_no;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *from_province;
@property (nonatomic,copy)NSString *to_address;
@property (nonatomic,copy)NSString *delivery_date;
@property (nonatomic,copy)NSString *car_remark;
@property (nonatomic,copy)NSString *car_type;
@property (nonatomic,copy)NSString *goods_size;
@property (nonatomic,copy)NSString *usercount;
@property (nonatomic,copy)NSString *delivery_by;
@property (nonatomic,copy)NSString *guid;
@property (nonatomic,copy)NSString *goods_order;
@property (nonatomic,copy)NSString *issue_by;
@property (nonatomic,copy)NSString *order_fee;

- (NSArray *)statusCodeArr;
- (NSArray *)statusDescArr;

@end
