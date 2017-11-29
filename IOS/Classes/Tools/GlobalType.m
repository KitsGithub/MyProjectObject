//
//  GlobalType.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//


#import "GlobalType.h"
#import "SFGoodsProvenance.h"
#import "SFCarProvenance.h"
#import "SFReceiveGoods.h"
#import "SFBookingCar.h"

NSString *takingStatus_toDescription(SFTakingStatus status)
{
    
    if (status == SFTakingStatusUnkown) {
        return @"未知状态";
    }
    switch (status) {
        case SFTakingStatusPublished:
            return @"待确定";
            break;
        case SFTakingStatusNotPublish:
            return @"待确定";
            break;
        case SFTakingStatusCancel:
            return @"已取消";
            break;
        case SFTakingStatusRefuse:
            return @"已撤回";
        case SFTakingStatusWaiteForTraded:
            return @"待成交";
        case SFTakingStatusWaiteForDelivery:
            return @"等收货";
        case SFTakingStatusWaiteForPay:
            return @"待支付";
        case SFTakingStatusWaiteForEvaluate:
            return @"待评价";
        case SFTakingStatusFinish:
            return @"已完成";
            break;
        default:
            break;
    }
    return @"未知状态";
}




NSString *takingStatus_toString(SFTakingStatus status)
{
    switch (status) {
        case SFTakingStatusPublished:
            return @"A";
            break;
        case SFTakingStatusNotPublish:
            return @"B";
            break;
        case SFTakingStatusCancel:
            return @"C";
            break;
        case SFTakingStatusRefuse:
            return @"D";
            break;
        case SFTakingStatusWaiteForTraded:
            return @"F";
            break;
        case SFTakingStatusWaiteForDelivery:
            return @"G";
            break;
        case SFTakingStatusWaiteForPay:
            return @"H";
            break;
        case SFTakingStatusWaiteForEvaluate:
            return @"I";
            break;
        case SFTakingStatusFinish:
            return @"J";
            break;
        default:
            break;
    }
    return nil;
}


SFTakingStatus takingStatus_initWitString(NSString *str){
    if ([str isEqualToString:@"A"]) {
        return SFTakingStatusPublished;
    }else if ([str isEqualToString:@"B"]){
        return SFTakingStatusNotPublish;
    }else if ([str isEqualToString:@"C"]){
        return SFTakingStatusCancel;
    }else if ([str isEqualToString:@"D"]){
        return SFTakingStatusRefuse;
    }else if ([str isEqualToString:@"E"]){
        return SFTakingStatusUnkown;
    }else if ([str isEqualToString:@"F"]){
        return SFTakingStatusWaiteForTraded;
    }else if ([str isEqualToString:@"G"]){
        return SFTakingStatusWaiteForDelivery;
    }else if ([str isEqualToString:@"H"]){
        return SFTakingStatusWaiteForPay;
    }else if ([str isEqualToString:@"I"]){
        return SFTakingStatusWaiteForEvaluate;
    }else if ([str isEqualToString:@"J"]){
        return SFTakingStatusFinish;
    }
    return SFTakingStatusUnkown;
}



SFOrderType orderType_initWithStr(NSString *str)
{
    if ([str isEqualToString:@"F"]) {
        return SFOrderTypeFinish;
    }else if ([str isEqualToString:@"D"]){
        return SFOrderTypeWaiteForEvaluate;
    }
//    else if ([str isEqualToString:@"C"]){
//        return SFOrderTypeWaiteForPay;
//    }
    else if ([str isEqualToString:@"B"]){
        return SFOrderTypeWaiteForDelivery;
    }else if ([str isEqualToString:@"A"]){
        return SFOrderTypeWaiteForSent;
    }
    return SFOrderTypeAll;
}

NSString *orderType_CodeStr(SFOrderType status)
{
    switch (status) {
        case SFOrderTypeWaiteForSent:
            return @"A";
            break;
        case SFOrderTypeWaiteForDelivery:
            return @"B";
            break;
//        case SFOrderTypeWaiteForPay:
//            return @"C";
//            break;
        case SFOrderTypeWaiteForEvaluate:
            return @"D";
            break;
        case SFOrderTypeFinish:
            return @"F";
            break;
        default:
            return @"";
            break;
    }
    
}

SFProvenanceType SFProvenanceTypeCreate(SFUserRole role,SFProvenanceDirection direction)
{
    BOOL isPublishCar = direction  == SFProvenanceDirectionPublish && [SFAccount currentAccount].role == SFUserRoleCarownner;
    BOOL isPublishGoods = direction  == SFProvenanceDirectionPublish && [SFAccount currentAccount].role == SFUserRoleGoodsownner;
    BOOL isOrderedCar = direction  == SFProvenanceDirectionReceive && [SFAccount currentAccount].role == SFUserRoleGoodsownner;
    BOOL isReceiveGoods = direction  == SFProvenanceDirectionReceive && [SFAccount currentAccount].role == SFUserRoleCarownner;
    if (isPublishCar) {
        return SFProvenanceTypePublishCar;
    }else if (isPublishGoods){
        return SFProvenanceTypePublishGoods;
    }else if (isOrderedCar){
        return SFProvenanceTypeBookingCar;
    }else{
        return SFProvenanceTypeReceiveGoods;
    }
}

NSArray *SFProvenanceTypeGetCodeArr(SFProvenanceType type)
{
    switch (type) {
        case SFProvenanceTypePublishGoods:
            return [[SFGoodsProvenance new] statusCodeArr];
            break;
        case SFProvenanceTypePublishCar:
            return [[SFCarProvenance new] statusCodeArr];
            break;
        case SFProvenanceTypeReceiveGoods:
            return [[SFReceiveGoods new] statusCodeArr];
            break;
        case SFProvenanceTypeBookingCar:
            return [[SFBookingCar new] statusCodeArr];
            break;
        default:
            return nil;
            break;
    }
}


NSArray *SFProvenanceTypeGetDescArr(SFProvenanceType type)
{
    switch (type) {
        case SFProvenanceTypePublishGoods:
            return [[SFGoodsProvenance new] statusDescArr];
            break;
        case SFProvenanceTypePublishCar:
            return [[SFCarProvenance new] statusDescArr];
            break;
        case SFProvenanceTypeReceiveGoods:
            return [[SFReceiveGoods new] statusDescArr];
            break;
        case SFProvenanceTypeBookingCar:
            return [[SFBookingCar new] statusDescArr];
            break;
        default:
            return nil;
            break;
    }
}

// C待认证 B审核中 D认证成功 F认证失败
SFAuthStatus  SFAuthStatusCreate(NSString *code){
    if ([code isEqualToString:@"C"]) {
        return SFAuthStatusWaitForReview;
    }else if ([code isEqualToString:@"B"]){
        return SFAuthStatusReviewing;
    }else if ([code isEqualToString:@"D"]){
        return SFAuthStatusPass;
    }else{
        return SFAuthStatusRefuse;
    }
}

NSString * SFAuthStatusGetDesc(SFAuthStatus status)
{
    switch (status) {
        case SFAuthStatusWaitForReview:
            return @"待认证";
            break;
        case SFAuthStatusReviewing:
            return @"审核中";
        case SFAuthStatusPass:
            return @"认证成功";
        case SFAuthStatusRefuse:
            return @"认证失败";
        default:
            return @"";
            break;
    }
}


