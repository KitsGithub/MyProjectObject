//
//  SfOrderProtocol.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "SFOpration.h"


@protocol SfOrderProtocol <NSObject>

- (NSString *)guid;

- (NSString *)goods_order;

- (NSString *)order_id;

- (NSString *)from;

- (NSString *)to;

- (NSString *)cost;

- (NSString *)carownnerName;
- (NSString *)goodownnerName;

- (NSString *)licensePlateNumber; // 车牌号

- (NSString *)stateStr;

- (NSString *)goodsNameOrType;

- (NSString *)goodsWeight;

- (NSString *)carType;

- (NSString *)carLone;

- (SFTakingStatus)takingStatus;

- (SFOrderType)orderType;

@end

