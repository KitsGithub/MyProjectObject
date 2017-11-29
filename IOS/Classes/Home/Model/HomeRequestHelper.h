//
//  HomeRequestHelper.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsSupply.h"
#import "SFSearchResultProtocol.h"


#define kdefult_numberofpage   10 

@protocol BannerInfoProtocol <NSObject>

@property (nonatomic,strong)NSString *imgUrl; // 展示的图片url


@property (nonatomic,strong)NSString *targetUrl; // 跳转到的url


@optional
@property (nonatomic,assign)NSInteger  type; // banner类型 （待定）

@end


typedef NS_ENUM(NSUInteger, SFSearchType) {
    SFSearchTypeGoods,
    SFSearchTypeCars
};



@protocol CardSupplyProtrocol <NSObject>

@property (nonatomic,strong)id ownerInfo;

@property (nonatomic,strong)id carInfo;

@end




@interface HomeRequestHelper : NSObject


/**
 获取banner页相关信息

 @param success 成功回调。
 @param fault 失败回调
 */
+ (void)fectchBannerInfoListWithSuccess:(void(^)(NSArray <id<BannerInfoProtocol>>*))success fault:(SFErrorResultBlock)fault;



/**
 获取货源列表

 @param success 成功回调
 @param fault 失败回调
 */
+ (void)fetchGoodsSuplyListWithPage:(NSInteger)page num:(NSInteger)num Success:(void(^)(NSArray <GoodsSupply *>*))success fault:(SFErrorResultBlock)fault;

/**
 获取车源列表

 @param page 页码
 @param num 每个最大请求条数
 @param success 成功回调
 @param fault 失败回调
 */
+ (void)fetchCardListwithPage:(NSInteger)page  num:(NSInteger)num Success:(void(^)(NSArray <NSObject *>*))success  fault:(SFErrorResultBlock)fault;


/**
 搜索车源

 @param carType  车型
 @param from 出发地 省/市/区 形式 用/分割
 @param to 目的地。 省/市/区 形式 用/分割
 @param success 成功回调 返回SFSearchResultProtocol数组 
 @param fault 失败回调
 */
+ (void)searchCarsSupplyWithcarType:(NSString *)carType  from:(NSString *)from to:(NSString *)to page:(NSInteger)page Success:(void(^)(NSArray <SFSearchResultProtocol>*))success  fault:(SFErrorResultBlock)fault;


/**
 搜索货源

 @param carType 车型
 @param goodsType 货物类型
 @param from 出发地 省/市/区 形式 用/分割
 @param to 目的地   省/市/区 形式 用/分割
 @param success 成功回调 返回SFSearchResultProtocol数组
 @param fault 失败回调
 */
+ (void)searchGoodsSupplyWithcarType:(NSString *)carType goodsType:(NSString *)goodsType  from:(NSString *)from to:(NSString *)to page:(NSInteger)page Success:(void(^)(NSArray <SFSearchResultProtocol>*))success  fault:(SFErrorResultBlock)fault;


@end
