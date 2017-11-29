//
//  CarsSupply.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFSearchResultProtocol.h"

@interface CarsSupply : NSObject<SFSearchResultProtocol>


/**
 货主对车辆的预订状态，A为已预订，B为未预订
 */
@property (nonatomic,strong)NSString *takingstatus;

/**
 车源单标识
 */
@property (nonatomic,strong)NSString *guid;
@property (nonatomic,strong)NSString *car_type;
@property (nonatomic,strong)NSString *car_long;
@property (nonatomic,strong)NSNumber *car_count;

/*
 "takingstatus" : "B",
 "to_district" : "市辖区",
 "diffreg" : 1,
 "from_district" : "东城区",
 "car_count" : 1,
 "nick_name" : "林加尔",
 "verfiystatus" : "已认证",
 "diffunit" : "天",
 "issuedate" : "2017-10-30 17:44:06",
 "to_city" : "合肥市",
 "car_type" : "保温车",
 "car_long" : "4.2米",
 "guid" : "11b3ecab-5ef6-4d48-9e96-f0aa562a062b",
 "from_city" : "市辖区",
 "head_src" : "",
 "from_province" : "北京市",
 "ordercount" : 1,
 "to_province" : "安徽省"
 */

//用户信息
@property (nonatomic,strong)NSString *nick_name;
@property (nonatomic,strong)NSString *verfiystatus;
@property (nonatomic,strong)NSString *head_src;
@property (nonatomic,strong)NSNumber *ordercount;


//到达城市
@property (nonatomic,strong)NSString *to_province;
@property (nonatomic,strong)NSString *to_city;
@property (nonatomic,strong)NSString *to_district;

//起始城市
@property (nonatomic,strong)NSString *from_province;
@property (nonatomic,strong)NSString *from_city;
@property (nonatomic,strong)NSString *from_district;


/**
 注册时间差
 */
@property (nonatomic,strong)NSNumber *diffreg;

/**
 注册时间差单位
 */
@property (nonatomic,strong)NSString *diffunit;

/**
 发布时间
 */
@property (nonatomic,strong)NSString *issuedate;




@end
