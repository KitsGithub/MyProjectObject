//
//  GoodsSupply.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSearchResultProtocol.h"
#import "SfOrderProtocol.h"
typedef enum : NSUInteger {
    Resource_Order = 0,      //货源
    Resource_Car = 1         //车源
} ResourceType;  //用户状态


@interface GoodsSupply : NSObject <SFSearchResultProtocol,SfOrderProtocol>


@property (nonatomic,strong)NSString *guid;

@property (nonatomic,strong)NSString *order_no;


// 出发地
@property (nonatomic,strong)NSString *from_province;

@property (nonatomic,strong)NSString *from_city;

@property (nonatomic,strong)NSString *from_district;

@property (nonatomic,strong)NSString *from_address;


// 目的地
@property (nonatomic,strong)NSString *to_province;

@property (nonatomic,strong)NSString *to_city;

@property (nonatomic,strong)NSString *to_district;

@property (nonatomic,strong)NSString *to_address;


// 货物信息
@property (nonatomic,strong)NSString *goods_type;

@property (nonatomic,strong)NSString *goods_name;

@property (nonatomic,strong)NSNumber *goods_size;

@property (nonatomic,strong)NSNumber *goods_weight;

@property (nonatomic,strong)NSString *weight_unit;

// 车辆信息
@property (nonatomic,strong)NSString *car_type;

@property (nonatomic,strong)NSString *car_long;

@property (nonatomic,strong)NSNumber *car_count;

@property (nonatomic,strong)NSString *price;

/**
 发货人
 */
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *head_src;

/**
 发货次数
 */
@property (nonatomic, strong) NSString *issueCount;

@property (nonatomic,strong)NSString *order_status;

@end
