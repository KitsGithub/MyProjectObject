//
//  SFProvenance.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/31.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//  我发的车 


#import <Foundation/Foundation.h>
#import "SfOrderProtocol.h"

@interface SFCarProvenance : NSObject<SfOrderProtocol>
{
    @private
    SFTakingStatus _takingStatus;
}


@property (nonatomic,copy)NSString *guid;

//地址信息
@property (nonatomic,copy)NSString *from_address;
@property (nonatomic,copy)NSString *to_address;
//@property (nonatomic,copy)NSString *from_district;
@property (nonatomic,copy)NSString *from_province;
@property (nonatomic,copy)NSString *to_city;
@property (nonatomic,copy)NSString *to_district;

@property (nonatomic,copy)NSString *car_long;
@property (nonatomic,copy)NSNumber *goods_weight;
@property (nonatomic,copy)NSNumber *car_count;

@property (nonatomic,copy)NSString *issue_date;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *order_user;
@property (nonatomic,copy)NSString *issue_by;
@property (nonatomic,copy)NSString *car_remark;
@property (nonatomic,copy)NSString *car_type;
@property (nonatomic,copy)NSString *weight_unit;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *from_city;
@property (nonatomic,copy)NSString *from_district;
@property (nonatomic,copy)NSString *to_province;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *connect_mobile;
@property (nonatomic,copy)NSNumber *dead_weight;
@property (nonatomic,copy)NSNumber *car_size;

@property (nonatomic,copy)NSString *taking_status;

@property (nonatomic,assign)SFTakingStatus takingStatus;

- (SFOrderType)orderType;

- (NSArray *)statusCodeArr;
- (NSArray *)statusDescArr;

@end
