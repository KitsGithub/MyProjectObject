//
//  SFGoodsDetailModel.h
//  SFLIS
//
//  Created by Mr_kit on 2017/12/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFGoodsDetailModel : NSObject
@property (nonatomic, copy) NSString *from_province;
@property (nonatomic, copy) NSString *from_city;
@property (nonatomic, copy) NSString *from_address;
@property (nonatomic, copy) NSString *from_district;

@property (nonatomic, copy) NSString *to_province;
@property (nonatomic, copy) NSString *to_city;
@property (nonatomic, copy) NSString *to_district;
@property (nonatomic, copy) NSString *to_address;


@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *connect_mobile;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *depart_date;

/**
 货物信息
 */
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_type;
@property (nonatomic, assign) NSNumber *goods_size;
@property (nonatomic, assign) NSNumber *goods_weight;


/**
 车辆需求信息
 */
@property (nonatomic, copy) NSString *car_long;
@property (nonatomic, copy) NSString *car_type;
@property (nonatomic, assign) NSNumber *car_count;


/**
 定价
 */
@property (nonatomic, copy) NSString *price;

/**
 收货人详情
 */
@property (nonatomic, copy) NSString *delivery_by;
@property (nonatomic, copy) NSString *delivery_mobile;


/**
 货主信息
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head_src;
@property (nonatomic, copy) NSString *connect_by;
@property (nonatomic, copy) NSString *issue_date;
@property (nonatomic, copy) NSString *issue_by;


/**
 备注
 */
@property (nonatomic, copy) NSString *car_remark;
@property (nonatomic, copy) NSString *attention_remark;

@end
