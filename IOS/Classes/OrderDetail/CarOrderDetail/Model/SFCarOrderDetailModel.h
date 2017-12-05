//
//  SFCarOrderDetailModel.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCarOrderDetailModel : NSObject

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
@property (nonatomic, copy) NSString *depart_date;

@property (nonatomic, copy) NSString *car_long;
@property (nonatomic, copy) NSString *car_count;
@property (nonatomic, copy) NSString *dead_weight;
@property (nonatomic, copy) NSString *weight_unit;
@property (nonatomic, copy) NSString *car_type;
@property (nonatomic, copy) NSString *car_size;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head_src;
@property (nonatomic, copy) NSString *connect_by;
@property (nonatomic, copy) NSString *issue_date;
@property (nonatomic, copy) NSString *issue_by;


@property (nonatomic, copy) NSString *car_remark;

@end
