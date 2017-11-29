//
//  GlobalType.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#ifndef GlobalType_h
#define GlobalType_h

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SFAuthType) {
    SFAuthTypeUser,
    SFAuthTypeCar,
    SFAuthTypeCarOwnner
};

// OrderStatus:（订单状态：A待发货 B待收货 C待支付 D待评价 F已完成 字符串选填）
typedef NS_ENUM(NSUInteger, SFOrderType) {
    SFOrderTypeAll = 0,
    SFOrderTypeWaiteForSent,              //A 等发货
    SFOrderTypeWaiteForDelivery,          //B 等待交付 等待收货 
//    SFOrderTypeWaiteForPay,               //C 待支付
    SFOrderTypeWaiteForEvaluate,          //D 待评价
    SFOrderTypeFinish                     //F 已完成
};


// 我接的单   A已确认  B待确认 C已撤回   D已回绝 F待成交 G待收货 H待支付 I待评价 J已完成
// 我发的车   A已接单  B待接单 C已取消   D已回绝 F待成交 G待收货               J已完成
// 我预订的车  A已确认 B待确认 C已取消   D已撤回                            J已完成 
// 我发的货           B待发布          D已撤回 F待成交 G待收货               J已完成 
typedef NS_ENUM(NSInteger, SFTakingStatus) {
    SFTakingStatusUnkown = -1,
    SFTakingStatusPublished = 0,           //A 等待接单 已经发布
    SFTakingStatusNotPublish,                 //B 已经确定
    SFTakingStatusCancel,                  //C 已取消
    SFTakingStatusRefuse,                  //D 已经撤回 已经回绝
    SFTakingStatusWaiteForTraded,          //F 待成交
    SFTakingStatusWaiteForDelivery,        //G 等待交付 等待收货
    SFTakingStatusWaiteForPay,                //H 待支付
    SFTakingStatusWaiteForEvaluate,           //I 待评价
    SFTakingStatusFinish                      //J 已完成
};

typedef NS_ENUM(NSUInteger, SFUserRole) {
    SFUserRoleUnknown = 0,
    SFUserRoleCarownner = 1 << 1,
    SFUserRoleGoodsownner  = 1 << 2,
};

typedef NS_ENUM(NSUInteger, SFProvenanceDirection) {
    SFProvenanceDirectionPublish,  // 发的车源 发布的货源
    SFProvenanceDirectionReceive // 我接的单。 我预定的车
};

typedef NS_ENUM(NSUInteger, SFProvenanceType) {
    SFProvenanceTypePublishGoods,
    SFProvenanceTypePublishCar,
    SFProvenanceTypeBookingCar,
    SFProvenanceTypeReceiveGoods
};

// C待认证 B审核中 D认证成功 F认证失败
typedef NS_ENUM(NSUInteger, SFAuthStatus) {
    SFAuthStatusWaitForReview,
    SFAuthStatusReviewing,
    SFAuthStatusPass,
    SFAuthStatusRefuse
};


SFProvenanceType SFProvenanceTypeCreate(SFUserRole role,SFProvenanceDirection direction);
NSArray *SFProvenanceTypeGetCodeArr(SFProvenanceType type);
NSArray *SFProvenanceTypeGetDescArr(SFProvenanceType type);


NSString *takingStatus_toDescription(SFTakingStatus status);
//NSArray<NSString *>*takingStatus_descriptions(void);
NSString *takingStatus_toString(SFTakingStatus status);
SFTakingStatus takingStatus_initWitString(NSString *str);

SFOrderType orderType_initWithStr(NSString *str);
NSString *orderType_CodeStr(SFOrderType status);

SFAuthStatus  SFAuthStatusCreate(NSString *code);
NSString * SFAuthStatusGetDesc(SFAuthStatus status);



#endif /* GlobalType_h */
