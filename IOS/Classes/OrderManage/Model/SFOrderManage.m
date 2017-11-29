
//
//  SFOrderManage.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderManage.h"
#import "SFReceiveGoods.h"
#import "SFBookingCar.h"


@implementation SFOrderManage

+ (void)getOrderListWithType:(NSString *)type page:(NSInteger)page Success:(void(^)(NSArray <SFOrder *>*))success fault:(SFErrorResultBlock)fault
{
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"PageIndex"] = @(page);
    mdic[@"PageSize"]  = @(kSFOrder_numbers_per_page);
    mdic[@"UserId"]    = [SFAccount currentAccount].user_id;
    mdic[@"OrderStatus"] = type;
    [[SFNetworkManage shared] postWithPath:@"Order/GetMyOrderList" params:mdic success:^(id result) {
        NSArray <SFOrder *>*arr = [SFOrder mj_objectArrayWithKeyValuesArray:result];
        success(arr);
    } fault:^(SFNetworkError *err) {
        fault(err); 
    }];
}


+ (void)getProvenanceListWithDirection:(SFProvenanceDirection)direction Type:(NSString *)type page:(NSInteger)page Success:(void(^)(NSArray <id<SfOrderProtocol>>*))success fault:(SFErrorResultBlock)fault
{
    BOOL isPublishCar = direction  == SFProvenanceDirectionPublish && [SFAccount currentAccount].role == SFUserRoleCarownner;
    BOOL isPublishGoods = direction  == SFProvenanceDirectionPublish && [SFAccount currentAccount].role == SFUserRoleGoodsownner;
    BOOL isOrderedCar = direction  == SFProvenanceDirectionReceive && [SFAccount currentAccount].role == SFUserRoleGoodsownner;
    BOOL isReceiveGoods = direction  == SFProvenanceDirectionReceive && [SFAccount currentAccount].role == SFUserRoleCarownner;
    
    NSString *path;
    if (isPublishCar) {
        path =  @"CarsBooking/GetTakingCarsOrderList";  //我发的车
    }else if (isOrderedCar){
        path = @"GoodsOrder/GetCarOrderSrc";    //我预定的车
    }else if (isPublishGoods){
        path  = @"GoodsOrder/GetGoodSrc";       //我发的货
    }else{
        path  = @"CarsBooking/GetTakingGoodsOrderList"; //我接的单
    }
    NSInteger number = kSFOrder_numbers_per_page;
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"UserId"]  = [SFAccount currentAccount].user_id;
    params[@"OrderStatus"] = type;
    [[SFNetworkManage shared] postWithPath:path params:params success:^(id result) {
        NSArray <id<SfOrderProtocol>>*arr = nil;
        if (isPublishCar) {
            arr  = [SFCarProvenance mj_objectArrayWithKeyValuesArray:result];
        }else if (isOrderedCar){
            arr  = [SFBookingCar mj_objectArrayWithKeyValuesArray:result];
        }else if (isPublishGoods){
            arr  = [SFGoodsProvenance mj_objectArrayWithKeyValuesArray:result];
        }else if(isReceiveGoods){
            arr  = [SFReceiveGoods mj_objectArrayWithKeyValuesArray:result];
        }
        if (page  > 1) {
            success(@[]);
        }else{
            success(arr);
        }
        
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
}

+ (void)evalWithOrderId:(NSString *)orderId Start:(NSInteger)start content:(NSString *)content Success:(SFEmptyResultBlock)success fault:(SFErrorResultBlock)fault
{
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"UserId"] = USER_ID;
    mdic[@"OrderId"] = orderId;
    mdic[@"Content"] = content;
    mdic[@"Score"] = @(start);

    [[SFNetworkManage shared] postWithPath:@"Order/AssessOrder" params:mdic success:^(id res) {
        if (res) {
            success();
        }else{
            SFNetworkError *err = [SFNetworkError errorWithDomain:@"评价失败" code:900 userInfo:nil];
            fault(err);
        }
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        success();
    });
}

+ (void)cancelCarOrderWithId:(NSString *)guid Success:(SFBoolResultBlock)success fault:(SFErrorResultBlock)fault
{
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"Guid"]   = guid;
    mdic[@"UserId"] = [SFAccount currentAccount].user_id;
    [[SFNetworkManage shared] postWithPath:@"CarsBooking/CancelCarOrder" params:mdic success:^(id result) {
        BOOL isSuc = [result isKindOfClass:[NSString class]] && [(NSString *)result isEqualToString:@"true"];
        success(isSuc);
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
}

/**
 撤回已发布的车
 
 @param carId   车源car_id
 @param success 成功回调
 @param fault   失败回调
 */
+ (void)recallCarOrderWithId:(NSString *)carId Success:(SFBoolResultBlock)success fault:(SFErrorResultBlock)fault {
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"OrderId"]   = carId;
    mdic[@"UserId"] = [SFAccount currentAccount].user_id;
    
    NSString *header;
    if ([SFAccount currentAccount].role == SFUserRoleGoodsownner) {
        header = @"GoodsOrder/RecallGoodsOrder";
    } else {
        header = @"CarsBooking/RecallCarOrder";
    }
    
    [[SFNetworkManage shared] postWithPath:header params:mdic success:^(id result) {
        BOOL isSuc = [result intValue];
        success(isSuc);
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
}

/**
 车主取消接单
 
 @param guid    货主接单id
 @param success 成功回调
 @param fault   失败回调
 */
+ (void)cancelGoodOrderWithId:(NSString *)guid Success:(SFBoolResultBlock)success fault:(SFErrorResultBlock)fault {
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    mdic[@"Guid"]   = guid;
    mdic[@"UserId"] = [SFAccount currentAccount].user_id;
    
    NSString *header;
    if ([SFAccount currentAccount].role == SFUserRoleGoodsownner) {
        header = @"CarsBooking/CancelCarOrder";
    } else {
        header = @"GoodsOrder/CancelGoodsOrder";
    }
    
    [[SFNetworkManage shared] postWithPath:header params:mdic success:^(id result) {
        BOOL isSuc = result ;
        success(isSuc);
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
}

@end
