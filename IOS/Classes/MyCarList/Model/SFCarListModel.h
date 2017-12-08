//
//  SFCarListModel.h
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAuthStatusModle.h"
@interface SFCarListModel : NSObject

@property (nonatomic, copy) NSString *car_id;
@property (nonatomic, copy) NSString *belong_by;


/** 车辆信息 */
@property (nonatomic, copy) NSString *car_no;           //车牌
@property (nonatomic, copy) NSString *car_type;         //车的类型
@property (nonatomic, copy) NSString *car_long;         //车长
@property (nonatomic, copy) NSString *car_size;         //车体积
@property (nonatomic, copy) NSString *dead_weight;      //车重量

/** 车辆状态 A：空闲 B:待发布  C：已发布  E：作废车辆 */
@property (nonatomic, copy) NSString *issue_status;     //车辆状态
@property (nonatomic, copy) NSString *issue_date;       //日期

@property (nonatomic, copy) NSString *order_fee;

/** 认证状态 */
@property (nonatomic, copy) NSString *verify_status;    //认证状态
@property (nonatomic, copy) NSString *verify_statuscn;

@property (nonatomic, strong) SFAuthStatusModle *authStatus;
@end
