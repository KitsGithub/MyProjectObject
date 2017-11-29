//
//  HomeRequestHelper.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "HomeRequestHelper.h"
#import "SFNetworkManage.h"
#import "GoodsSupply.h"
#import "CarsSupply.h"

@implementation HomeRequestHelper


+ (void)fectchBannerInfoListWithSuccess:(void(^)(NSArray <id<BannerInfoProtocol>>*))success fault:(SFErrorResultBlock)fault
{
     success(@[@"http://c.hiphotos.baidu.com/image/pic/item/09fa513d269759ee976ed50bbbfb43166d22df30.jpg",@"http://img0.imgtn.bdimg.com/it/u=3330496398,528486966&fm=200&gp=0.jpg",@"http://c.hiphotos.baidu.com/image/pic/item/09fa513d269759ee976ed50bbbfb43166d22df30.jpg"]);
    return;
    NSString *url = [NSString stringWithFormat:@"%@/%@",Default_URL,@"api/carowner/GetCarSourceList"];
    [[SFNetworkManage shared] get:url params:@{@"PageIndex":@1} success:^(id result) {
       
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
    
    
}


+ (void)fetchGoodsSuplyListWithPage:(NSInteger)page num:(NSInteger)num Success:(void(^)(NSArray <GoodsSupply *>*))success fault:(SFErrorResultBlock)fault
{
    [[SFNetworkManage shared] postWithPath:@"goods/GetRealTimeGoodsPage" params:@{@"PageIndex":@(page),@"PageSize":@(num)} success:^(id result) {
        success([GoodsSupply mj_objectArrayWithKeyValuesArray:result]);
    } fault:^(SFNetworkError *err) {
         fault(err);
    }];

}


+ (void)fetchCardListwithPage:(NSInteger)page  num:(NSInteger)num Success:(void(^)(NSArray <NSObject *>*))success  fault:(SFErrorResultBlock)fault
{
    [[SFNetworkManage shared] postWithPath:@"cars/GetRealTimeCars" params:@{@"PageIndex":@(page),@"PageSize":@(num)} success:^(id result) {
        success([CarsSupply mj_objectArrayWithKeyValuesArray:result]);
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
}

+ (void)searchCarsSupplyWithcarType:(NSString *)carType  from:(NSString *)from to:(NSString *)to page:(NSInteger)page Success:(void(^)(NSArray <SFSearchResultProtocol>*))success  fault:(SFErrorResultBlock)fault
{
    if (!from) {
        from = @"";
    }
    if (!to) {
        to = @"";
    }
    if (!carType) {
        carType = @"";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"PageIndex":@(page),@"PageSize":@(kdefult_numberofpage)}];
    params[@"FromAddress"] =  from;
    params[@"ToAddress"]   = to;
    params[@"CarType"]   = carType;
    [[SFNetworkManage shared] postWithPath:@"cars/GetRealTimeCars" params:params success:^(id result) {
        success([CarsSupply mj_objectArrayWithKeyValuesArray:result]);
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
    
}

+ (void)searchGoodsSupplyWithcarType:(NSString *)carType goodsType:(NSString *)goodsType  from:(NSString *)from to:(NSString *)to page:(NSInteger)page Success:(void(^)(NSArray <SFSearchResultProtocol>*))success  fault:(SFErrorResultBlock)fault
{
    
    if (!from.length) {
        from = @"";
    }
    if (!to.length) {
        to = @"";
    }
    if (!carType.length) {
        carType = @"";
    }
    if (!goodsType.length) {
        goodsType = @"";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"PageIndex":@(page),@"PageSize":@(kdefult_numberofpage)}];
    params[@"FromAddress"] =  from;
    params[@"ToAddress"]   = to;
    params[@"CarType"]     = carType;
    params[@"GoodsType"]   = goodsType;
    
    [[SFNetworkManage shared] postWithPath:@"goods/GetRealTimeGoodsPage" params:params success:^(id result) {
        success([GoodsSupply mj_objectArrayWithKeyValuesArray:result]);
    } fault:^(SFNetworkError *err) {
        fault(err);
    }];
}



@end
