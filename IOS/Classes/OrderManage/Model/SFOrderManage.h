//
//  SFOrderManage.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsSupply.h"
#import "SFCarProvenance.h"
#import "SFGoodsProvenance.h"
#import "SFOrder.h"




#define kSFOrder_numbers_per_page     20

@interface SFOrderManage : NSObject


/**
 获取订单列表
 
 @param type 订单类型
 @param page 分页页码
 @param success 成功回调 返回GoodsSupply数组
 @param fault 失败回调
 */
+ (void)getOrderListWithType:(NSString *)type page:(NSInteger)page Success:(void(^)(NSArray <SFOrder *>*))success fault:(SFErrorResultBlock)fault; 



/**
 获取物源列表 发布的车/预定的车/发布的货/接的单  根据账号角色确定
 
 @param direction 发布/接受
 @param type 物源状态类型
 @param page 页码
 @param success 成功回调
 @param fault 失败回调
 */
+ (void)getProvenanceListWithDirection:(SFProvenanceDirection)direction Type:(NSString *)type page:(NSInteger)page Success:(void(^)(NSArray <id<SfOrderProtocol>>*))success fault:(SFErrorResultBlock)fault;


/**
 取消预订的车

 @param guid 车源单的id
 @param success 是否成功的回调
 @param fault 失败回调
 */
+ (void)cancelCarOrderWithId:(NSString *)guid Success:(SFBoolResultBlock)success fault:(SFErrorResultBlock)fault;

/**
 撤回已发布的车

 @param carId   车源car_id
 @param success 成功回调
 @param fault   失败回调
 */
+ (void)recallCarOrderWithId:(NSString *)carId Success:(SFBoolResultBlock)success fault:(SFErrorResultBlock)fault;

/**
 车主取消接单
 
 @param guid    货主接单id
 @param success 成功回调
 @param fault   失败回调
 */
+ (void)cancelGoodOrderWithId:(NSString *)guid Success:(SFBoolResultBlock)success fault:(SFErrorResultBlock)fault;

/**
 评价接口
 
 @param start 评星等级。1-5之间
 @param content 评价内容
 @param success 成功回调
 @param fault 失败回调
 */
+ (void)evalWithOrderId:(NSString *)orderId Start:(NSInteger)start content:(NSString *)content Success:(SFEmptyResultBlock)success fault:(SFErrorResultBlock)fault;


@end

